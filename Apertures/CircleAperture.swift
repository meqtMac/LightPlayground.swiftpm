//
//  File.swift
//  
//
//  Created by 蒋艺 on 2023/4/6.
//

import Foundation
import SwiftUI
import Accelerate

struct CircleAperture: Aperture {
    var id = UUID()
    var size: CGSize = CGSize(width: 1e-2, height: 1e-2)
    var radius: CGFloat
    
    init(radius: CGFloat) {
        self.radius = min(radius, size.width / 2)
    }
   
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = radius / size.width * rect.width
        var path = Path.init()
        path.addArc(center: center, radius: radius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: true)
        return path
    }
    
}


