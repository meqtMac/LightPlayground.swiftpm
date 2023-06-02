//
//  File.swift
//  
//
//  Created by 蒋艺 on 2023/4/6.
//

import SwiftUI

struct RingAperture: Aperture {
    let id = UUID()
    let size: CGSize = CGSize(width: 1e-2, height: 1e-2)
    var radius: CGFloat
    var subRadius: CGFloat
    var n: Int
   
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let angleStep = CGFloat.pi * 2 / CGFloat(n)
        let side = radius * rect.width / size.width
        let subSide = subRadius * rect.width / size.width
        
        for i in 0..<n {
            path.addArc(center: CGPoint(x: center.x + side * sin(angleStep*CGFloat(i)), y: center.y + side * cos(angleStep*CGFloat(i))), radius: subSide , startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360), clockwise: true)
        }
        
        return path
    }
}
