//
//  LightViewModel.swift
//  LightPlayground
//
//  Created by 蒋艺 on 2023/3/30.
//

import SwiftUI
import Accelerate

class LightViewModel: ObservableObject {
    typealias T = Float
    let length: CGFloat
    @Published var position: CGFloat
    @Published var light: Light
    @Published var aperture: any Aperture
    var z: T { T(length - position) }
    var power: Int
    var simulator: Simulator<T>
    @Published var intensitySqrt: Bool
    
    init(length: CGFloat = 3,
         position: CGFloat  = 0.212,
         light: Light = .white,
         aperture: any Aperture = defaultApertures[8],
         power: Int = 10,
         intensitySqrt: Bool = true) {
        self.length = length
        self.position = position
        self.light = light
        self.aperture = aperture
        self.simulator = Simulator<T>(aperture: aperture, resolutionPower: power)
        self.power = power
        self.intensitySqrt = intensitySqrt
    }
    
    var cgColor: CGColor {
        switch light {
            case .monochrome(let wavelength):
                return rgbColor(wavelength: wavelength)
            case .white:
                return CGColor(red: 1, green: 1, blue: 1, alpha: 0.95)
        }
    }
    
    func updateSimulator(with aperture: any Aperture) {
        self.aperture = aperture
        simulator = Simulator<T>(aperture: aperture, resolutionPower: power)
    }
    
    var simulation: CGImage? {
        var cgImage: CGImage?
        switch light {
            case .monochrome(let wavelength):
                var intensity = simulator.intensity_angular_spectrum(wavelength: T(wavelength), at: T(z))
                if intensitySqrt{
                    vForce.sqrt(intensity, result: &intensity)
                }
                cgImage = colorizeImage(with: intensity, color: cgColor)!
            case .white:
                var rintesity = simulator.intensity_angular_spectrum(wavelength: T(650e-9), at: T(z))
                var gintesity = simulator.intensity_angular_spectrum(wavelength: T(510e-9), at: T(z))
                var bintesity = simulator.intensity_angular_spectrum(wavelength: T(440e-9), at: T(z))
                if intensitySqrt{
                    vForce.sqrt(rintesity, result: &rintesity)
                    vForce.sqrt(gintesity, result: &gintesity)
                    vForce.sqrt(bintesity, result: &bintesity)
                }
                cgImage = colorizeImage(rBuffer: rintesity, gBuffer: gintesity, bBuffer: bintesity)
        }
        return cgImage
   }
    
    func colorizeImage(with grayBuffer: LTArray2D<T>, color: CGColor) -> CGImage? {
        let componets = color.components!
        let red = T(componets[0])
        let green = T(componets[1])
        let blue = T(componets[2])
        let width = grayBuffer.width
        let height = grayBuffer.height
        var redBuffer = LTArray2D<T>(width: width, height: height)
        var greenBuffer = LTArray2D<T>(width: width, height: height)
        var blueBuffer = LTArray2D<T>(width: width, height: height)
        vDSP.multiply(red, grayBuffer, result: &redBuffer)
        vDSP.multiply(green, grayBuffer, result: &greenBuffer)
        vDSP.multiply(blue, grayBuffer, result: &blueBuffer)
        return colorizeImage(rBuffer: redBuffer, gBuffer: greenBuffer, bBuffer: blueBuffer)
    }
    
    func colorizeImage(rBuffer: LTArray2D<T>, gBuffer: LTArray2D<T>, bBuffer: LTArray2D<T>) -> CGImage? {
        let width = rBuffer.width
        let height = gBuffer.width
        let rUInt8Buffer = rBuffer.toUInt8()
        let bUInt8Buffer = bBuffer.toUInt8()
        let gUInt8Buffer = gBuffer.toUInt8()
        
        var rImageBuffer = rUInt8Buffer.vImageBuffer()
        var gImageBuffer = gUInt8Buffer.vImageBuffer()
        var bImageBuffer = bUInt8Buffer.vImageBuffer()
        
        var destImageBuffer: vImage_Buffer
        do {
            destImageBuffer = try vImage_Buffer(width: width, height: height, bitsPerPixel: 32)
            vImageOverwriteChannels_ARGB8888(&rImageBuffer, &destImageBuffer, &destImageBuffer, 0x4, vImage_Flags(kvImageNoFlags))
            vImageOverwriteChannels_ARGB8888(&gImageBuffer, &destImageBuffer, &destImageBuffer, 0x2, vImage_Flags(kvImageNoFlags))
            vImageOverwriteChannels_ARGB8888(&bImageBuffer, &destImageBuffer, &destImageBuffer, 0x1, vImage_Flags(kvImageNoFlags))
            vImageOverwriteChannelsWithScalar_ARGB8888(255, &destImageBuffer, &destImageBuffer, 0x8, vImage_Flags(kvImageNoFlags))
        }catch{
            return nil
        }
        
        guard
            let format = vImage_CGImageFormat(
                bitsPerComponent: 8,
                bitsPerPixel: 32,
                colorSpace: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                renderingIntent: .defaultIntent) else {
            return nil
        }
        let result = try? destImageBuffer.createCGImage(format: format)
        defer {
            destImageBuffer.free()
        }
        return result
    }
}

/// Represents a physical light source, either as a single wavelength or a mixture of wavelengths.
public enum Light {
    case monochrome(wavelength: Float)
    case white
}

/// Converts a wavelength in meters to an RGB color using a pre-defined formula.
/// The formula is based on CIE 1931 color matching functions.
/// - Parameter wavelength: The wavelength to convert, in meters.
/// - Returns: An `(r, g, b)` tuple representing the color.
func rgbColor(wavelength: Float) -> CGColor {
    // Convert wavelength to RGB color using a pre-defined formula
    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    
    if wavelength >= 380e-9 && wavelength <= 440e-9 {
        r = CGFloat(( 440e-9 - wavelength) / (440e-9 - 380e-9))
        g = 0.0
        b = 1.0
    } else if wavelength >= 440e-9 && wavelength <= 490e-9 {
        r = 0.0
        g = CGFloat((wavelength - 440e-9) / (490e-9 - 440e-9))
        b = 1.0
    } else if wavelength >= 490e-9 && wavelength <= 510e-9 {
        r = 0.0
        g = 1.0
        b = CGFloat((510e-9 - wavelength) / (510e-9 - 490e-9))
    } else if wavelength >= 510e-9 && wavelength <= 580e-9 {
        r = CGFloat((wavelength - 510e-9) / (580e-9 - 510e-9))
        g = 1.0
        b = 0.0
    } else if wavelength >= 580e-9 && wavelength <= 645e-9 {
        r = 1.0
        g = CGFloat((645e-9 - wavelength) / (645e-9 - 580e-9))
        b = 0.0
    } else if wavelength >= 645e-9 && wavelength <= 780e-9 {
        r = 1.0
        g = 0.0
        b = 0.0
    }else {
        return CGColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    return CGColor(red: r, green: g, blue: b, alpha: 1)
}
