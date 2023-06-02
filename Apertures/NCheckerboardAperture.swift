//
//  File.swift
//  
//
//  Created by 蒋艺 on 2023/4/6.
//

import Foundation
import SwiftUI

struct NCheckerboardAperture: Aperture {
    let id = UUID()
    let size: CGSize = CGSize(width: 1e-2, height: 1e-2)
    var radius: CGFloat
    var n: Int
    init(radius: CGFloat, n: Int) {
        self.radius = min(size.width / 2, radius)
        self.n = n
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width / CGFloat(n) * 2 * radius / size.width
        let height = rect.height / CGFloat(n) * 2 * radius / size.height
        for i in 0..<n {
            for j in 0..<n {
                let x = (CGFloat(i) - CGFloat(n)/2) * width + rect.midX
                let y = (CGFloat(j) - CGFloat(n)/2) * height + rect.midY
                let rect = CGRect(x: x, y: y, width: width, height: height)
                
                if (i+j) % 2 == 0 {
                    path.addRect(rect)
                } else {
                    path.move(to: CGPoint(x: x, y: y))
                }
            }
        }
        
        return path
    }
}
