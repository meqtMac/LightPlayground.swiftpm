//
//  File.swift
//  
//
//  Created by 蒋艺 on 2023/4/6.
//

import SwiftUI

struct PentagonAperture: Aperture {
    let id = UUID()
    let size: CGSize = CGSize(width: 1e-2, height: 1e-2)
    var radius: CGFloat
    
   func path(in rect: CGRect) -> Path {
        let angle = CGFloat.pi / 2.5
        let side = rect.width * radius / size.width
        var points = [CGPoint]()
        
        for i in 0..<5 {
            let x = rect.midX + side * cos(angle * CGFloat(i) - CGFloat.pi / 2)
            let y = rect.midY + side * sin(angle * CGFloat(i) - CGFloat.pi / 2)
            let point = CGPoint(x: x, y: y)
            points.append(point)
        }
        
        let path = Path { path in
            path.addLines(points)
            path.closeSubpath()
        }
        
        return path
    }
}
