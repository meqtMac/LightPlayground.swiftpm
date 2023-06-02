//
//  File.swift
//  
//
//  Created by 蒋艺 on 2023/4/6.
//

import Foundation
import SwiftUI

struct SlitsAperture: Aperture {
    let id = UUID()
    let size: CGSize = CGSize(width: 1e-2, height: 1e-2)
    var radius: CGFloat
    var n: Int
    
    init(radius: CGFloat = 1e-3, n: Int) {
        self.radius = min(size.width / 2, radius)
        self.n = n
    }
    
   
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let ratio = rect.width / size.width * 2 * radius / size.width
        let slitWidth = size.width * ratio / 50
        let gapWidth = size.width * ratio / CGFloat(n+1)
        let startY = rect.midY - size.height * ratio / 2
        let endY = rect.midY + size.height * ratio / 2
        
        for i in 0..<n {
            let centerX = rect.midX + (CGFloat(1-n)/2 + CGFloat(i)) * gapWidth
            let startX = centerX - slitWidth / 2
            let endX = centerX + slitWidth / 2
            path.move(to: CGPoint(x: startX, y: startY))
            path.addLine(to: CGPoint(x: startX, y: endY))
            path.addLine(to: CGPoint(x: endX, y: endY))
            path.addLine(to: CGPoint(x: endX, y: startY))
            path.closeSubpath()
        }
        
        return path
    }
    
}
