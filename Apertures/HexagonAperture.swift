//
//  File.swift
//  
//
//  Created by 蒋艺 on 2023/4/6.
//

import Foundation
import SwiftUI

struct HexagonAperture: Aperture {
    let id = UUID()
    let size: CGSize = CGSize(width: 1e-2, height: 1e-2)
    let radius: CGFloat
   
    func path(in rect: CGRect) -> Path {
        let side = radius / size.width * rect.width
        var path = Path()
        path.addHexagon(center: CGPoint(x: rect.midX, y: rect.midY), side: side)
       return path
    }
}

extension Path {
    mutating func addHexagon(center: CGPoint, side: CGFloat) {
        move(to: CGPoint(x: center.x + side, y: center.y))
        for i in 1...6 {
            let angle = CGFloat.pi / 3 * CGFloat(i)
            let x = center.x + side * cos(angle)
            let y = center.y + side * sin(angle)
            addLine(to: CGPoint(x: x, y: y))
        }
        closeSubpath()
    }
}

