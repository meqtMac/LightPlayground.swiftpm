//
//  File.swift
//  
//
//  Created by 蒋艺 on 2023/4/6.
//

import Foundation
import SwiftUI

struct DiamondAperture: Aperture {
    let id = UUID()
    let size: CGSize = CGSize(width: 1e-2, height: 1e-2)
    let radius: CGFloat
   
    func path(in rect: CGRect) -> Path {
        let side = rect.width * radius / size.width
       
        var path = Path()
        path.move(to: CGPoint(x: side / 2 + rect.midX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: side * sqrt(3) / 2 + rect.midY))
        path.addLine(to: CGPoint(x: -side / 2 + rect.midX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: -side*sqrt(3)/2 + rect.midY))
        path.closeSubpath()
        
        return path
    }
    
}
