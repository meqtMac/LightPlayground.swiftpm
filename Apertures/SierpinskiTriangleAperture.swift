//
//  File.swift
//  
//
//  Created by 蒋艺 on 2023/4/6.
//

import SwiftUI

struct SierpinskiTriangleAperture: Aperture {
    let id = UUID()
    var size: CGSize = CGSize(width: 1e-2, height: 1e-2)
    var radius: CGFloat
    var n: Int
    
   
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let triangleSide = radius * sqrt(3) * rect.width / size.width
        let center = CGPoint(x: rect.midX, y: rect.midY)
        drawChildTriangles(order: n, center: center, triangleSide: triangleSide, path: &path)
        return path
    }
    
    private func drawChildTriangles(order: Int, center: CGPoint, triangleSide: CGFloat, path: inout Path) {
        if order == 0 {
            // Base case: draw the central triangle
            let triangleHeight = sqrt(3) / 2 * triangleSide
            let topPoint = CGPoint(x: center.x, y: center.y - triangleSide / sqrt(3))
            let bottomLeftPoint = CGPoint(x: center.x - triangleSide / 2, y: center.y + triangleHeight / 2 )
            let bottomRightPoint = CGPoint(x: center.x + triangleSide / 2, y: center.y + triangleHeight / 2 )
            path.move(to: topPoint)
            path.addLine(to: bottomLeftPoint)
            path.addLine(to: bottomRightPoint)
            path.closeSubpath()
        } else {
            let triangleHeight = sqrt(3) / 2 * triangleSide
            let leftCenter = CGPoint(x: center.x - triangleSide / 4, y: center.y + triangleHeight / 4)
            let rightCenter = CGPoint(x: center.x + triangleSide / 4, y: center.y + triangleHeight / 4)
            let topCenter = CGPoint(x: center.x, y: center.y - triangleSide / 2 / sqrt(3))
            drawChildTriangles(order: order - 1, center: topCenter,  triangleSide: triangleSide / 2, path: &path)
            drawChildTriangles(order: order - 1, center: leftCenter,  triangleSide: triangleSide / 2, path: &path)
            drawChildTriangles(order: order - 1, center: rightCenter,  triangleSide: triangleSide / 2, path: &path)
        }
    }
}
