//
//  SwiftUIView.swift
//  
//
//  Created by 蒋艺 on 2023/4/7.
//

import SwiftUI


struct StartPageView: View {
    @Binding var isPresent: Bool
    @State var posititon: CGFloat = 0.2
    @State var step: Int = 1
    @State var light = Light.monochrome(wavelength: 550e-9)
    @State var selectedAperture: any Aperture = SlitsAperture(n: 4)
    @State var hideAperture = false
    let endStep: Int = 6
    
    let gridItemLayout = [GridItem](repeating: GridItem(), count: 3)
    var spectrumGradient: LinearGradient {
        LinearGradient(
        gradient: Gradient(colors: spectrumColors()),
        startPoint: .leading,
        endPoint: .trailing)
    }
    func spectrumColors() -> [Color] {
        var colors: [Color] = []
        for wavelength in stride(from: 380e-9, through: 780e-9, by: 5e-9) {
            
            let color = rgbColor(wavelength: Float(wavelength))
            colors.append(Color(cgColor: color))
        }
        return colors
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $step) {
                ScrollView {
                    Text("Welcome to the wonderful world of diffraction!")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Text("The phenomenon of diffraction is a fundamental concept in physics and optics that explains the bending and spreading of light waves when they encounter obstacles or pass through narrow openings. Diffraction is responsible for creating patterns of light and dark fringes that can be observed when light passes through a small aperture or a narrow slit. This concept has significant implications for a wide range of fields, including astronomy, microscopy, and spectroscopy, and is essential to our understanding of the behavior of light.")
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 50)
                    
                    Divider()
                        .padding(.horizontal, 50)
                    
                    Text("App Running Example")
                        .font(.title)
                        .bold()
                    
                    HStack{
                        ApertureShape(aperture: RecursiveSquareAperture(radius: 5.0e-3, n: 2))
                            .frame(width: 200, height: 200)
                            .aspectRatio(1/1, contentMode: .fit)
                            .foregroundColor(.white)
                            .background(.black)
                        
                        GeometryReader { geometry in
                            if let cgImage = LightViewModel(
                                length: 3,
                                position: 2.97,
                                light: .white,
                                aperture: RecursiveSquareAperture(radius: 5e-3, n: 3),
                                power: 10,
                                intensitySqrt: true
                            ).simulation {
                                Image(decorative: cgImage, scale: 1)
                                    .resizable()
                            }
                        }.frame(width: 200, height: 200)
                        
                        GeometryReader { geometry in
                            if let cgImage = LightViewModel(
                                length: 3,
                                position: 1.5,
                                light: .white,
                                aperture: RecursiveSquareAperture(radius: 5e-3, n: 3),
                                power: 10,
                                intensitySqrt: true
                            ).simulation {
                                Image(decorative: cgImage, scale: 1)
                                    .resizable()
                            }
                        }.frame(width: 200, height: 200)
                    }
                    .padding(.horizontal, 50)
                    
                    Text("The images above show some examples of the application in action. The image on the left represents the aperture shape, while the middle and right images depict the simulation results at different distances. These visualizations demonstrate how the app can simulate the diffraction of light and show how the pattern of light and dark fringes changes as the distance between the aperture and the simulation panel is adjusted.")
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 50)
                        .padding(.bottom, 20)
                    
                    if let markdown = try? AttributedString(markdown: "With this app, you can simulate a variety of aperture shapes, select different light sources with varying wavelengths, adjust the distance between the aperture and the simulation panel, and view the simulation results **in real-time**.") {
                        Text(markdown)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 50)
                    }
                    
                }
                .padding()
                .tag(1)
                
                ScrollView(){
                    Text("Instruments Setup")
                        .font(.title)
                        .bold()
                        .padding()
                    InstrumentsView(
                        length: 1.8,
                        position: $posititon,
                        lView: Rectangle().foregroundColor(.red),
                        rView: Rectangle().foregroundColor(.blue),
                        mView: Rectangle().foregroundColor(.green)
                    ).padding(.horizontal, 50)
                    
                    Divider()
                        .padding(.horizontal, 50)
                    
                    
                    Text("This illustration depicts the spatial relationship of the instruments used in the simulation. The red instrument represents the light source, the green instrument represents the aperture, and the blue instrument represents the simulation results panel. This visualization helps to show how the simulation works by simulating the behavior of light as it passes through the aperture and forms a diffraction pattern on the simulation panel.")
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal,50)
                        .padding(.bottom, 25)
                    
                    if let markdown = try? AttributedString(markdown: "To adjust the distance between the aperture and the simulation panel, simply **drag the aperture** with your finger. If you lost track of the aperture, tap top trailing button on simulation in app to rescue.") {
                        Text(markdown)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 50)
                    }
                }
                .padding()
                .tag(2)
                
                ScrollView{
                    Text("Apertures")
                        .font(.title)
                        .bold()
                    Divider()
                        .padding(.horizontal, 50)
                    Button {
                        hideAperture.toggle()
                    } label: {
                        Image(systemName: "square.on.circle")
                    }
                    .padding()
                    
                    Text("To choose from a selection of apertures to simulate with, simply **tap the button** to show the aperture sheet within the app.")
                        .padding(.horizontal, 50)
                    
                    if !hideAperture{
                        AperturePickerView(
                            selectedAperture: $selectedAperture,
                            cgColor: UIColor(Color.accentColor).cgColor )
                        .padding(.horizontal, 100)
                    }
                }
                .padding()
                .tag(3)
                
                ScrollView{
                    WavelengthPicker(light: $light)
                    
                    Text("To choose a monochrome light source for the simulation, **drag the circle** to select the desired wavelength.")
                        .padding(.horizontal, 50)
                        .padding(.bottom, 25)
                    
                    Text("To simulate with a synthesized white light, which is a combination of blue light with a wavelength of 440nm, green light with a wavelength of 510nm, and red light with a wavelength of 650nm, simply **tap on the white circle.**")
                        .padding(.horizontal, 50)
                        .padding(.bottom, 25)
                     
                   
                    
                    HStack{
                        Circle()
                            .foregroundColor(Color(cgColor: rgbColor(wavelength: 440e-9)))
                        Spacer()
                        Circle()
                            .foregroundColor(Color(cgColor: rgbColor(wavelength: 510e-9)))
                        Spacer()
                        Circle()
                            .foregroundColor(Color(cgColor: rgbColor(wavelength: 650e-9)))
                    }
                    .frame(width: 300, height: 40)
                    .padding(.bottom, 25)
                    
                }
                .padding()
                .tag(4)
                
                VStack{
                    Text("Simulation Setting")
                        .font(.title)
                        .bold()
                    Divider()
                        .padding(.horizontal, 50)
                    
                    Text("Below are some buttons and their corresponding functionalities: ")
                        .padding(.horizontal, 50)
                        List{
                            HStack{
                                Text("Change the layout, speed up the simulation.")
                                Spacer()
                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                                    .foregroundColor(.accentColor)
                            }
                            Toggle("Enhance the level of detail in the simulation.", isOn: .constant(true))
                        }
                    
               }
                .padding()
                .tag(5)
                
                
                
                
                VStack {
                    Text("Let's dive into the wounderful world of diffraction with this app!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(spectrumGradient)
                        .multilineTextAlignment(.center)
                        .padding()
                                        
                    Text("This app is designed to be used in full screen, landscape mode.")
 
                }
                .padding()
                .tag(6)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            HStack{
                if step == 1 {
                    Image(systemName: "arrowshape.turn.up.left.fill")
                        .hidden()
                }else{
                    Image(systemName: "arrowshape.turn.up.left.fill")
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            step -= 1
                        }
                }
                
                Button {
                    withAnimation {
                        if step == endStep {
                            isPresent = false
                        } else {
                            step += 1
                        }
                    }
                } label: {
                    if step == endStep {
                        Text("Finish Guide")
                            .frame(width: 200)
                            .padding()
                    } else {
                        Text("Continue")
                            .frame(width: 200)
                            .padding()
                    }
                }
                .foregroundColor(.primary)
                .background(.tint)
                .clipShape(Capsule())
                
                Image(systemName: "arrowshape.turn.up.left.fill")
                    .hidden()
                    .foregroundColor(.accentColor)
            }
            .padding()
        }
    }
}

struct StartPageView_Previews: PreviewProvider {
    static var previews: some View {
        StartPageView(isPresent: .constant(false),
                      step: 5)
    }
}
