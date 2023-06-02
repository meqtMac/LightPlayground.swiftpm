//
//  File.swift
//  
//
//  Created by 蒋艺 on 2023/4/7.
//

import SwiftUI

struct CellularAperture: Aperture {
    let id = UUID()
    let size: CGSize = CGSize(width: 1e-2, height: 1e-2)
    /// radius for a single hexagon
    let radius: CGFloat
    let n: Int
    init(radius: CGFloat, n: Int) {
        self.radius = min(radius, size.width/2 )
        self.n = n
    }
    
    private struct MyCoordinate: Equatable {
        var i: Int
        var j: Int
        static func + (lhs: MyCoordinate, rhs: MyCoordinate) -> MyCoordinate {
            return MyCoordinate(i: lhs.i + rhs.i, j: lhs.j + rhs.j)
        }
        var cgPoint: CGPoint {
            CGPoint(x: CGFloat(i) * cos(CGFloat.pi/6), y: CGFloat(j) + CGFloat(i)*sin(CGFloat.pi/6))
        }
    }
    
    private let directions = [MyCoordinate(i: 0, j: 1),
                              MyCoordinate(i: 0, j: -1),
                              MyCoordinate(i: 1, j: 0),
                              MyCoordinate(i: -1, j: 0),
                              MyCoordinate(i: 1, j: -1),
                              MyCoordinate(i: -1, j: 1)]
    
    private var myCoordinates: [MyCoordinate] {
        var coordinates: [MyCoordinate] = []
        coordinatesHelper(coordinates: &coordinates, order: self.n)
        return coordinates
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let side = radius * (rect.width / size.width / CGFloat(2*n+1) )
        for coordinate in myCoordinates {
            let centerX = rect.midX + 2 * side * coordinate.cgPoint.x
            let centerY = rect.midY + 2 * side * coordinate.cgPoint.y
            path.addHexagon(center: CGPoint(x: centerX, y: centerY), side: side)
        }
        return path
    }
    
    private func coordinatesHelper(coordinates: inout [MyCoordinate], order: Int) {
        if order == 0 {
            return
        }else if order == 1 {
            coordinates = directions
        }else {
            coordinatesHelper(coordinates: &coordinates, order: order-1)
            let count = coordinates.count
            for i in 0..<count {
                for direction in directions {
                    let newCoordinate = coordinates[i] + direction
                    if newCoordinate != MyCoordinate(i: 0, j: 0) && !coordinates.contains(newCoordinate) {
                        coordinates.append(newCoordinate)
                    }
                }
            }
        }
    }
}

