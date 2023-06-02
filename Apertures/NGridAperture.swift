//
//  File.swift
//  
//
//  Created by 蒋艺 on 2023/4/6.
//

import Foundation
import SwiftUI

struct NGirdAperture: Aperture {
    let id = UUID()
    let size: CGSize = CGSize(width: 1e-2, height: 1e-2)
    var radius: CGFloat
    let n: Int
    init(radius: CGFloat, n: Int) {
        self.radius = min(radius, self.size.width/2)
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
                
                if i % 2 == 1 || j % 2 == 1 {
                    path.addRect(rect)
                } else {
                    path.move(to: CGPoint(x: x, y: y))
                }
            }
        }
        
        return path
    }
}
