//
//  Aperture.swift
//  LightPlayground
//
//  Created by 蒋艺 on 2023/4/4.
//

import Foundation
import SwiftUI

/// A protocol that defines the basic interface for an aperture object, which is used in simulating light passing through a given opening.
public protocol Aperture: Identifiable, Equatable {
    var id: UUID { get }
    /// The size of the aperture's border in meters.
    var size: CGSize { get }
    var radius: CGFloat { get }
    
    /// Generates a Path object representing the outline of the aperture within the specified rectangle.
    /// - Parameter rect: The rectangle within which the Path object should be generated.
    /// - Returns: A Path object representing the outline of the aperture within the specified rectangle.
    func path(in rect: CGRect) -> Path
}

public var defaultApertures: [any Aperture] = [
    SlitsAperture(radius: 0.75e-3, n: 2),
    SlitsAperture(radius: 0.75e-3, n: 4),
    SlitsAperture(radius: 0.4e-3, n: 3),
    SlitsAperture(radius: 0.4e-3, n: 5),
    RectangleAperture(radius: 0.75e-3, theta: CGFloat.pi / 4),
    RectangleAperture(radius: 0.75e-3, theta: CGFloat.pi / 6),
    DiamondAperture(radius: 0.75e-3),
    HexagonAperture(radius: 0.75e-3),
    DoubleLayerHexagonAperture(radius: 0.75e-3),
    CellularAperture(radius: 0.75e-3, n: 3),
    CellularAperture(radius: 0.75e-3, n: 6),

    //    CircleAperture(radius: 1e-3),
    //    RingAperture(radius: 1e-3, subRadius: 0.3e-3, n: 20),
    NCheckerboardAperture(radius: 0.75e-3, n: 9),
    NGirdAperture(radius: 0.75e-3, n: 9),
    NCheckerboardAperture(radius: 0.4e-3, n: 5),
    NGirdAperture(radius: 0.4e-3, n: 5),
    //    SierpinskiTriangleAperture(radius: 1e-3, n: 4),
    RecursiveSquareAperture(radius: 0.75e-3, n: 2),
    //    XcodeAperture(radius: 1e-3),
    //    AppleLogoAperture(radius: 1e-3)
]
