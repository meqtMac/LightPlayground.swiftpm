//
//  SwiftUIView.swift
//  
//
//  Created by 蒋艺 on 2023/4/15.
//

import SwiftUI

struct Spectrumiew: View {
    @Binding var wavelength: Float
    var circleColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            let circleSize = geometry.size.height
            let spectrumWidth = geometry.size.width
            
            let spectrumGradient = LinearGradient(
                gradient: Gradient(colors: spectrumColors()),
                startPoint: .leading,
                endPoint: .trailing
            )
            let capsuleMask = Capsule()
                .frame(height: geometry.size.height)
            
            ZStack{
                spectrumGradient
                    .frame(width: spectrumWidth)
                    .mask(capsuleMask)
                
                Circle()
                    .frame(height: geometry.size.height)
                    .foregroundColor(Color(rgbColor(wavelength: wavelength)))
                    .offset(x: (spectrumWidth-circleSize) * CGFloat((wavelength - 580e-9) / 400e-9))
                   .gesture(DragGesture()
                        .onChanged { gesture in
                            wavelength = max(380e-9, min(779e-9, Float(gesture.location.x) / Float(geometry.size.width) * 400e-9 + 580e-9) )
                       }
                    )
                   .overlay {
                        Circle()
                            .strokeBorder(lineWidth: 3)
                            .foregroundColor(circleColor)
                            .offset(x: (spectrumWidth-circleSize) * CGFloat((wavelength - 580e-9) / 400e-9))
                    }
            }
        }
        .aspectRatio(18, contentMode: .fit)
    }
    
    func spectrumColors() -> [Color] {
        var colors: [Color] = []
        for wavelength in stride(from: 380e-9, through: 780e-9, by: 5e-9) {
            
            let color = rgbColor(wavelength: Float(wavelength))
            colors.append(Color(cgColor: color))
        }
        return colors
    }
    
}

struct SpectrumView_Previews: PreviewProvider {
    static var previews: some View {
        Spectrumiew(wavelength: .constant(380e-9), circleColor: .accentColor)
    }
}
