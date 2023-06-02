import SwiftUI
import Accelerate

/// LTArray2D of type UInt8 is used for grayscale image initialization and grayscale image return
public extension LTArray2D where T == UInt8 {
    
    /// init a UInt8 LTArray2D from a swift path function by it's grayscale image
    convenience init(path: (CGRect) -> Path, width: Int, height: Int) {
        
        guard width > 0, height > 0 else {
            fatalError("LTArray2D dimensions must be greater than 0")
        }
        self.init(width: width, height: height)
        let path = path(CGRect(x: 0, y: 0, width: width, height: height)).cgPath
        let context = CGContext(data: data,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: height,
                                space: CGColorSpaceCreateDeviceGray(),
                                bitmapInfo: CGImageAlphaInfo.none.rawValue)!
        context.addPath(path)
        context.setFillColor(gray: 1, alpha: 1) // fill with white
        context.fillPath()
    }
    
    /// return a grayscale cg Image from a `LTArray2D<UInt8>`
    var grayCGImage: CGImage? {
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bytesPerPixel = 1
        let bitsPerComponent = 8
        let bytesPerRow = bytesPerPixel * width
        let bitmapInfo = CGImageAlphaInfo.none.rawValue
        
        guard let context = CGContext(data: data, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }
        return context.makeImage()
    }
    
    
}

