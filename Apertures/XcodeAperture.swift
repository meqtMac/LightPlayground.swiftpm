//
//  File.swift
//  
//
//  Created by 蒋艺 on 2023/4/7.
//

import SwiftUI

struct XcodeAperture: Aperture {
    let id = UUID()
    let size: CGSize = CGSize(width: 1e-2, height: 1e-2)
    var radius: CGFloat
    init(radius: CGFloat) {
        self.radius = min(radius, size.width * 4 / 9)
    }
    
    func path(in rect: CGRect) -> Path {
        // Calculate the width and height of the capsule
        let capsuleWidth = rect.width * 2 * radius / size.width
        let capsuleHeight = rect.height * 0.25 * radius / size.width
        
        // Create a rectangle for the center capsule
        let centerCapsuleRect = CGRect(x: -capsuleWidth / 2, y: -capsuleHeight/2 + capsuleHeight, width: capsuleWidth, height: capsuleHeight)
        
        let capsule = Path(roundedRect: centerCapsuleRect, cornerRadius: capsuleHeight / 2)
        
        let leftRotationTransform = CGAffineTransform(rotationAngle: CGFloat.pi * 2 / 3)
        let rightRotationTransform = CGAffineTransform(rotationAngle: CGFloat.pi * 4 / 3)
        let offsetx = rect.width/2 + rect.origin.x
        let offsety = rect.height/2 + capsuleHeight + rect.origin.y
        
        var path = Path()
        path.addPath(capsule.offsetBy(dx: offsetx, dy: offsety))
        path.addPath(capsule.applying(leftRotationTransform).offsetBy(dx: offsetx, dy: offsety))
        path.addPath(capsule.applying(rightRotationTransform).offsetBy(dx: offsetx, dy: offsety))
        
        return path
    }
    
}
