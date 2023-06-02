//
//  File.swift
//  
//
//  Created by 蒋艺 on 2023/4/6.
//

import Foundation
import SwiftUI

struct PentagramAperture: Aperture {
    let id = UUID()
    let size: CGSize = CGSize(width: 1e-2, height: 1e-2)
    var radius: CGFloat
   
    func path(in rect: CGRect) -> Path {
        let side = radius * rect.width / size.width
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let insetRatio = sin(CGFloat.pi  / 10) / sin(CGFloat.pi * 3 / 10)
        
        var path = Path()
        path.move(to: CGPoint(x: center.x, y: center.y - side))
        for i in 0..<10 {
            let angle = 2 * CGFloat.pi * CGFloat(i) / 5.0
            let x = rect.midX + side * sin(angle) * insetRatio
            let y = rect.midY + side * cos(angle) * insetRatio
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
            if i % 2 == 0 {
                let insetAngle = angle + CGFloat.pi / 5.0
                let insetX = rect.midX + side * sin(insetAngle)
                let insetY = rect.midY + side * cos(insetAngle)
                path.addLine(to: CGPoint(x: insetX, y: insetY))
            }
        }
        path.closeSubpath()
        return path
    }
}
