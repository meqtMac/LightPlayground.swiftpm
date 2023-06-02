//
//  File.swift
//  
//
//  Created by 蒋艺 on 2023/4/6.
//

import Foundation
import SwiftUI

struct RectangleAperture: Aperture {
    let id = UUID()
    let size: CGSize = CGSize(width: 1e-2, height: 1e-2)
    var radius: CGFloat
    /// angle in radian
    var theta: CGFloat
    init(radius: CGFloat, theta: CGFloat) {
        self.radius = radius
        self.theta = theta
    }
    
    func path(in rect: CGRect) -> Path {
        let scale = rect.width / size.width
        
        let xOffset = (size.width - 2 * radius * cos(theta)) * scale / 2
        let yOffset = ( size.height - 2 * radius * sin(theta) ) * scale / 2
        let rectOrigin = CGPoint(x: rect.origin.x + xOffset, y: rect.origin.y + yOffset)
        let rectSize = CGSize(width: 2 * radius * cos(theta) * scale, height: 2 * radius * sin(theta) * scale)
        let rectRect = CGRect(origin: rectOrigin, size: rectSize)
        
        return Path(rectRect)
    }
}
