//
//  File.swift
//  
//
//  Created by 蒋艺 on 2023/4/6.
//

import SwiftUI

struct DoubleLayerHexagonAperture: Aperture {
    let id = UUID()
    let size: CGSize = CGSize(width: 1e-2, height: 1e-2)
    var radius: CGFloat
    var outerRadius: CGFloat {
        min(size.width, radius)
    }
    
    var innerRadius: CGFloat {
        outerRadius * 0.75
    }
    
    func path(in rect: CGRect) -> Path {
        let angle = 2 * CGFloat.pi / 6
        let ratio: CGFloat = rect.width / size.width
        let innerPoints = (0..<6).map { i in
            CGPoint(x: rect.midX + innerRadius * ratio * cos(CGFloat(i) * angle), y: rect.midY + innerRadius * ratio * sin(CGFloat(i) * angle))
        }
        
        let outerPoints = (0..<6).map { i in
            CGPoint(x: rect.midX + outerRadius * ratio  * cos(CGFloat(i) * angle ), y: rect.midY + outerRadius * ratio * sin(CGFloat(i) * angle ))
        }
        
        var path = Path()
        for i in 0..<6 {
            let startPoint = outerPoints[i]
            path.move(to: startPoint)
            path.addLine(to: innerPoints[i])
            path.addLine(to: innerPoints[(i + 1) % 6])
            path.addLine(to: outerPoints[(i + 1) % 6])
            path.addLine(to: startPoint)
        }
        return path
    }
}
