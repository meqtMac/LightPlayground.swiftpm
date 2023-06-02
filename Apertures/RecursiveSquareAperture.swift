//
//  File.swift
//  
//
//  Created by 蒋艺 on 2023/4/7.
//

import SwiftUI

struct RecursiveSquareAperture: Aperture {
    let id = UUID()
    let size: CGSize = CGSize(width: 1e-2, height: 1e-2)
    let radius: CGFloat
    let order: Int
    
    init(radius: CGFloat, n: Int) {
        self.radius = min(size.width / sqrt(2), radius)
        self.order = n
    }
   
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let side = radius * sqrt(2) * rect.width / size.width
        let rect = CGRect(x: rect.midX - side / 2, y: rect.midY - side / 2, width:  side, height: side)
        drawSquare(center: CGPoint(x: rect.midX, y: rect.midY), rect: rect, order: order, path: &path)
        return path
    }
    
    private func drawSquare(center: CGPoint, rect: CGRect, order: Int, path: inout Path) {
        let subSide = rect.size.width / 3
        let subRectSize = CGSize(width: subSide, height: subSide)
        let subRect = CGRect(x: center.x - subSide/2, y: center.y - subSide/2, width: subSide, height: subSide)
        path.addRect(subRect)
        
        guard order > 0 else {
            return
        }
        
        let directions = [
            CGVector(dx: -1, dy: -1),
            CGVector(dx: 0, dy: -1),
            CGVector(dx: 1, dy: -1),
            CGVector(dx: 1, dy: 0),
            CGVector(dx: 1, dy: 1),
            CGVector(dx: 0, dy: 1),
            CGVector(dx: -1, dy: 1),
            CGVector(dx: -1, dy: 0)
        ]
        
        for direction in directions {
            let subCenter = CGPoint(x: center.x + direction.dx * subSide, y: center.y + direction.dy * subSide)
            let subRect = CGRect(origin: subCenter, size: subRectSize)
            drawSquare(center: subCenter, rect: subRect, order: order - 1, path: &path)
        }
    }
}
