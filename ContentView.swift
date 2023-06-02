import SwiftUI

struct ContentView: View{
    
    @ObservedObject var lightViewModel: LightViewModel
    @State var panelSheet: Bool = false
    @State var apertureSheet: Bool = false
    @State var startPage: Bool = true
    @State var minimizeInstruments: Bool = false
    @State var apertureBuffer: any Aperture = defaultApertures[0]
    
    let radius: CGFloat = 20
    let lineWidth: CGFloat = 5
    var lightColor: Color { Color(lightViewModel.cgColor) }
    let aperturnScale: CGFloat = 5
    
    init(lightViewModel: LightViewModel, panelSheet: Bool = false, apertureSheet: Bool = false, startPage: Bool = false, minimizeInstruments: Bool = false) {
        self.lightViewModel = lightViewModel
        self.panelSheet = panelSheet
        self.apertureSheet = apertureSheet
        self.startPage = startPage
        self.minimizeInstruments = minimizeInstruments
        self.apertureBuffer = lightViewModel.aperture
    }
       
    var apertureView: some View {
            ApertureShape(aperture: lightViewModel.aperture)
            .scaleEffect(CGSize(width: aperturnScale, height: aperturnScale))
            .foregroundColor(lightColor)
    }
    
    var simulationView: some View {
            GeometryReader { geometry in
                if let cgImage = lightViewModel.simulation {
                    Image(decorative: cgImage, scale: 1)
                        .resizable()
                }else{
                    EmptyView()
                }
            }
    }
    
    var instrumentView: some View {
        let radius: CGFloat = 5
        let lineWidth: CGFloat = 3
        return InstrumentsView(
            length: lightViewModel.length,
            position: $lightViewModel.position,
            lView:
                Rectangle()
                .foregroundColor(lightColor)
                .roundedBorder(radius: radius, lineWidth: lineWidth)
            ,
            rView:
                simulationView
                .roundedBorder(radius: radius, lineWidth: lineWidth)
            ,
            mView:
                apertureView
                .roundedBorder(radius: radius, lineWidth: lineWidth)
        )
        .padding(.horizontal, 50)
    }
    
    var miniInstrumentView: some View {
        VStack {
            Text("Instruments")
                .font(.title)
            
            Text(String(format: "z=%.3fm", lightViewModel.z))
                .foregroundColor(.accentColor)
                .bold()
            Divider()
            RulerView(length: lightViewModel.length, tickLength: 0.06, position: $lightViewModel.position, showMark: true, showText: false)
                .padding()
       }
    }
    
    
    var body: some View {
        VStack {
            HStack(alignment: .top){
                VStack {
                    if minimizeInstruments {
                        miniInstrumentView
                       .roundedBorder(radius: radius, lineWidth: lineWidth)
                        Spacer()
                    }
                    
                    WavelengthPicker(light: $lightViewModel.light)
                        .roundedBorder(radius: radius, lineWidth: lineWidth)
                    
                    Spacer()
                    
                    apertureView
                        .overlay(content: {
                            ZStack {
                            RulerView(length: 0.1/aperturnScale, tickLength: 0.0025, position: .constant(0.1), showMark: false, showText: false)
                             RulerView(length: 0.1/aperturnScale, tickLength: 0.00025, position: .constant(0.1), showMark: false, showText: false)
                                    .foregroundColor(.secondary)
                            }
                        })
                        .overlay(alignment: .bottom, content: {
                            Text("stroke length: 0.25mm")
                                .bold()
                                .padding()
                        })
                        .overlay(content: {
                            RulerView(length: 0.1/aperturnScale, tickLength: 0.0025, position: .constant(0.1), showMark: false, showText: false)
                                .rotationEffect(.radians(CGFloat.pi/2))
                        })
                        .overlay(alignment: .top, content: {
                            Text("Aperture")
                                .font(.title)
                                .padding(.top, 5)
                                .padding(.bottom)
                        })
                        .overlay(alignment: .topTrailing) {
                            Button {
                                apertureSheet.toggle()
                                apertureBuffer = lightViewModel.aperture
                            } label: {
                                Image(systemName: "square.on.circle")
                                    .font(.title)
                                    .padding()
                            }
                        }
                        .roundedBorder(radius: radius, lineWidth: lineWidth)
                       .aspectRatio(1, contentMode: .fit)
               }
                
                simulationView
                    .overlay(alignment: .bottom, content: {
                        Toggle(isOn: $lightViewModel.intensitySqrt) {
                                EmptyView()
                        }
                        .padding()
                        .tint(.accentColor)
                    })
                    .overlay(alignment: .top, content: {
                        Text("Simulation")
                            .font(.title)
                            .padding(.top, 5)
                            .padding(.bottom)
                            .foregroundColor(.white)
                    })
                    .overlay(alignment: .topTrailing)  {
                        Button {
                            withAnimation {
                                minimizeInstruments.toggle()
                            }
                        } label: {
                            Image(systemName: minimizeInstruments ?  "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                                .font(.title)
                                .padding()
                        }
                    }
                    .overlay(content: {
                        ZStack {
                         RulerView(length: 0.1, tickLength: 0.01, position: .constant(0.1), showMark: false, showText: false)
                            .foregroundColor(.white)
                            RulerView(length: 0.1, tickLength: 0.001, position: .constant(0.1), showMark: false, showText: false)
                                .foregroundColor(.white.opacity(0.5))
                        }
                   })
                    .overlay(alignment: .bottom, content: {
                        Text("stroke length: 1mm")
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                    })
                    .overlay(content: {
                            RulerView(length: 0.1, tickLength: 0.01, position: .constant(0.1), showMark: false, showText: false)
                            .foregroundColor(.white)
                                .rotationEffect(Angle(radians: CGFloat.pi/2))
                    })
                    .roundedBorder(radius: radius, lineWidth: lineWidth)
                    .aspectRatio(1, contentMode: .fill)
            }
            .padding()
            
            if !minimizeInstruments {
               instrumentView
           }
        }
        .sheet(isPresented: $startPage) {
            StartPageView(
                isPresent: $startPage
            )
        }
        .sheet(isPresented: $apertureSheet) {
            AperturePickerView(
                selectedAperture: $apertureBuffer,
                cgColor: lightViewModel.cgColor
            )
        }
        .onChange(of: apertureSheet) { newValue in
            lightViewModel.updateSimulator(with: apertureBuffer)
        }
    }
}

struct RoundedBorder: ViewModifier {
    let radius: CGFloat
    let lineWidth: CGFloat
    
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: radius)
                .strokeBorder(lineWidth: lineWidth)
        )
        .cornerRadius(radius)
    }
}

extension View {
    func roundedBorder(radius: CGFloat, lineWidth: CGFloat) -> some View {
        self.modifier(RoundedBorder(radius: radius, lineWidth: lineWidth))
    }
}

struct ContentView_Previews: PreviewProvider {
    @StateObject static var lightViewModel = LightViewModel()
    static var previews: some View {
        ContentView(lightViewModel:  lightViewModel)
    }
}
