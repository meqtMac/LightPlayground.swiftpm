//
//  InstrumentsView.swift
//  LightPlayground
//
//  Created by 蒋艺 on 2023/4/2.
//

import SwiftUI

struct InstrumentsView<lContent: View, rContent: View, mContent: View>: View {
    let length: CGFloat
    @Binding var position: CGFloat
    let lView: lContent
    let rView: rContent
    let mView: mContent
    
    var mViewRotateAngel: Angle{
        Angle(radians: atan(2 * position/length - 1) - CGFloat.pi / 2)
    }
    
    var body: some View {
            GeometryReader { geometry in
                
                GeometryReader{ geometry in
                    let height = geometry.size.width * 0.1 / length
                    let width = geometry.size.width
                    
                    lView
                        .frame(width: height, height: height)
                        .cornerRadius(5)
                        .rotation3DEffect(Angle(radians: CGFloat.pi/4), axis:  (0, 1, 0))
                        .offset(x: -height/2)
                    
                    rView
                        .frame(width: height, height: height)
                        .cornerRadius(5)
                        .rotation3DEffect(Angle(radians: -CGFloat.pi/4), axis:  (0, 1, 0))
                        .offset(x: width-height/2)
                    
                    mView
                        .frame(width: height, height: height)
                        .cornerRadius(5)
                        .rotation3DEffect(mViewRotateAngel, axis: (0, 1, 0))
                        .offset(x: position / length * width - height/2)
                        .gesture(
                            DragGesture()
                                .onChanged({ gesture in
                                    position = gesture.location.x / geometry.size.width * length
                                    position = max(0, min(length-0.01, position))
                                })
                        )
                    
                    RulerView(
                        length: length,
                        tickLength: .cm,
                        position: $position,
                        showMark: false,
                        showText: false)
                    .offset(x: 0, y: 1.25*height)
                }
            }
            .aspectRatio(length*3.5+1, contentMode: .fit)
            .overlay(alignment: .bottom) {
                Text(String(format: "z=%.3fm", length-position))
                    .foregroundColor(.accentColor)
                    .bold()
            }
    }

}

struct InstrumentsView_Previews: PreviewProvider {
    static let lView: some View = Rectangle().foregroundColor(.red)
    static let rView: some View = Rectangle().foregroundColor(.blue)
    static let mView: some View = Rectangle().foregroundColor(.green)
    
    static var previews: some View {
        InstrumentsView(length: 3, position: .constant(1.1351351), lView: lView, rView: rView, mView: mView)
            .roundedBorder(radius: 20, lineWidth: 5)
    }
}
