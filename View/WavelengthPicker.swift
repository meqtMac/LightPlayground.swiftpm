//
//  LightPickerView.swift
//  LightPlayground
//
//  Created by 蒋艺 on 2023/4/3.
//

import SwiftUI

struct WavelengthPicker: View {
    @Binding var light: Light
    @State private var wavelength: Float = 580e-9
    var isMono: Bool {
        switch light {
            case .monochrome:
                return true
            case .white:
                return false
        }
    }
    
    init(light: Binding<Light>) {
        self._light = light
        switch light.wrappedValue {
            case .monochrome(let wavelength):
                self.wavelength = wavelength
            case .white:
                self.wavelength = 580e-9
        }
        self.wavelength = wavelength
    }
    
    var body: some View {
        VStack{
            Text("Light Source")
                .font(.title)
                .padding(.top, 5)
            
            switch light {
                case .monochrome(let wavelength):
                    Text(String(format: "𝜆=%.3f nm", wavelength*1e9))
                        .bold()
                        .foregroundColor(.accentColor)
                case .white:
                    HStack{
                        Text("𝜆1=440nm")
                            .foregroundColor(Color(cgColor: rgbColor(wavelength: 440e-9)))
                            .bold()
                        Text("𝜆2=510nm")
                            .foregroundColor(Color(cgColor: rgbColor(wavelength: 510e-9)))
                            .bold()
                        Text("𝜆3=650nm")
                            .foregroundColor(Color(cgColor: rgbColor(wavelength: 650e-9)))
                            .bold()
                    }
            }
            Divider()
            HStack{
                Button {
                    light = .white
                } label: {
                    Circle()
                        .foregroundColor(.white)
                        .overlay {
                            Circle()
                                .strokeBorder(lineWidth: 3)
                                .foregroundColor(isMono ? .black : .accentColor)
                        }
                }
                
                Spectrumiew(wavelength: $wavelength, circleColor: isMono ? .accentColor : .black)
            }
            .aspectRatio(18, contentMode: .fit)
            .padding()
            .onChange(of: wavelength) { newValue in
                light = .monochrome(wavelength: newValue)
            }
        }
    }
}

struct WavelengthPicker_Previews: PreviewProvider {
    static var previews: some View {
        WavelengthPicker(light: .constant(.monochrome(wavelength: 580e-9)))
            .frame(width: 200, height: 200 )
    }
}
