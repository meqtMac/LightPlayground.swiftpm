import SwiftUI
import Accelerate

public class Simulator<T> where T: vDSP_FloatingPointGeneratable  {
    /// 2^power
    public var wResolution: Int
    /// width of the aperture in meter
    public var width: T
    /// height of the aperture in meter
    public var height: T
    /// transmittance matrix representing a aperture
    var transmittance: LTArray2D<T>
    /// it's meaning varies with different method
    var phaseCache: LTArray2D<T>
    var method: Method
    
    init(wResolution: Int,
         width: T,
         height: T,
         transmittance: LTArray2D<T>,
         phaseCache: LTArray2D<T>,
         method: Method) {
        self.wResolution = wResolution
        self.width = width
        self.height = height
        self.transmittance = transmittance
        self.phaseCache = phaseCache
        self.method = method
    }
    
    public enum Method {
        case fft2d
        case angular_spectrum
    }
}

public extension Simulator where T == Float {
    convenience init(aperture: any Aperture,
                     resolutionPower: Int,
                     method: Method = .angular_spectrum) {
        let phaseCache: LTArray2D<T>
        let width = T(aperture.size.width)
        let height = T(aperture.size.height)
        let wResolution = 1 << resolutionPower
        
        switch method {
            case .fft2d:
                phaseCache = Self.rsq(
                    width: width,
                    height: height,
                    Nx: wResolution,
                    Ny: wResolution)
            case .angular_spectrum:
                phaseCache = Self.kz_1stOrderAprx(
                    width: width,
                    height: height,
                    Nx: wResolution,
                    Ny: wResolution)
        }
        self.init(wResolution: wResolution,
                  width: width,
                  height: height,
                  transmittance: Self.transmittance(
                    path: aperture.path,
                    wResoultion: wResolution,
                    hResolution: wResolution),
                  phaseCache: phaseCache,
                  method: method)
        
    }
    
    func update(aperture: any Aperture,
                resolutionPower: Int,
                method: Method = .angular_spectrum) {
        let phaseCache: LTArray2D<T>
        let width = T(aperture.size.width)
        let height = T(aperture.size.height)
        let wResolution = 1 << resolutionPower
        switch method {
            case .fft2d:
                phaseCache = Self.rsq(
                    width: width,
                    height: height,
                    Nx: wResolution,
                    Ny: wResolution)
            case .angular_spectrum:
                phaseCache = Self.kz_1stOrderAprx(
                    width: width,
                    height: height,
                    Nx: wResolution,
                    Ny: wResolution
                )
        }
        let transmittance = Self.transmittance(
            path: aperture.path,
            wResoultion: wResolution,
            hResolution: wResolution)
        self.phaseCache = phaseCache
        self.width = width
        self.height = height
        self.wResolution = wResolution
        self.transmittance = transmittance
        self.method = method
    }
    
    var apertureImage: CGImage? {
        transmittance.toUInt8().grayCGImage
    }
    
    func simulate(wavelength: T, at z: T) -> CGImage? {
        var intensity: LTArray2D<T>
        switch method {
            case .fft2d:
                intensity = intensity_fft2d(wavelength: wavelength, at: z)
            case .angular_spectrum:
                intensity = intensity_angular_spectrum(wavelength: wavelength, at: z)
        }
        return intensity.toUInt8(max: 1, min: 0).grayCGImage
    }
    
    func getPhase(wavelength: T, z: T) -> LTArray2D<T> {
        var phase = LTArray2D<T>(width: wResolution, height: wResolution)
        switch method {
            case .fft2d:
                vDSP.multiply(T.pi / (wavelength * z), phaseCache, result: &phase)
            case .angular_spectrum:
                vDSP.multiply(z * T.pi * wavelength, phaseCache, result: &phase)
        }
        return phase
    }
    
    private func intensity_fft2d(wavelength: T, at z: T) -> LTArray2D<T> {
        let ltArray2DComplex = LTArray2DComplex(radius: transmittance, phase: getPhase(wavelength: wavelength, z: z))
        ltArray2DComplex.fft2D()
        return ltArray2DComplex.intensity()
    }
    
    func intensity_angular_spectrum(wavelength: T, at z: T) -> LTArray2D<T> {
        let amplitue = LTArray2DComplex(real: transmittance)
        amplitue.fft2D()
        amplitue.multiply(by: LTArray2DComplex(phase: getPhase(wavelength: wavelength, z: z)) )
        amplitue.fft2D(forward: false)
        var intensity = amplitue.intensity()
        let maximum = vDSP.maximum(intensity)
        let minimum = vDSP.minimum(intensity)
        vDSP.add(multiplication: (intensity, 1/(maximum-minimum)), -minimum/(maximum-minimum), result: &intensity)
        return intensity
    }
}

public extension Simulator where T == Double {
    convenience init(aperture: any Aperture,
                     resolutionPower: Int,
                     method: Method = .angular_spectrum) {
        let phaseCache: LTArray2D<T>
        let width = T(aperture.size.width)
        let height = T(aperture.size.height)
        let wResolution = 1 << resolutionPower
        
        switch method {
            case .fft2d:
                phaseCache = Self.rsq(
                    width: width,
                    height: height,
                    Nx: wResolution,
                    Ny: wResolution)
            case .angular_spectrum:
                phaseCache = Self.kz_1stOrderAprx(
                    width: width,
                    height: height,
                    Nx: wResolution,
                    Ny: wResolution)
        }
        self.init(wResolution: wResolution,
                  width: width,
                  height: height,
                  transmittance: Self.transmittance(
                    path: aperture.path,
                    wResoultion: wResolution,
                    hResolution: wResolution),
                  phaseCache: phaseCache,
                  method: method)
        
    }
    
    func update(aperture: any Aperture,
                resolutionPower: Int,
                method: Method = .angular_spectrum) {
        let phaseCache: LTArray2D<T>
        let width = T(aperture.size.width)
        let height = T(aperture.size.height)
        let wResolution = 1 << resolutionPower
        switch method {
            case .fft2d:
                phaseCache = Self.rsq(
                    width: width,
                    height: height,
                    Nx: wResolution,
                    Ny: wResolution)
            case .angular_spectrum:
                phaseCache = Self.kz_1stOrderAprx(
                    width: width,
                    height: height,
                    Nx: wResolution,
                    Ny: wResolution
                )
        }
        let transmittance = Self.transmittance(
            path: aperture.path,
            wResoultion: wResolution,
            hResolution: wResolution)
        self.phaseCache = phaseCache
        self.width = width
        self.height = height
        self.wResolution = wResolution
        self.transmittance = transmittance
        self.method = method
    }
    
    var apertureImage: CGImage? {
        transmittance.toUInt8().grayCGImage
    }
    
    func simulate(wavelength: T, at z: T) -> CGImage? {
        var intensity: LTArray2D<T>
        switch method {
            case .fft2d:
                intensity = intensity_fft2d(wavelength: wavelength, at: z)
            case .angular_spectrum:
                intensity = intensity_angular_spectrum(wavelength: wavelength, at: z)
        }
        return intensity.toUInt8(max: 1, min: 0).grayCGImage
    }
    
    func getPhase(wavelength: T, z: T) -> LTArray2D<T> {
        var phase = LTArray2D<T>(width: wResolution, height: wResolution)
        switch method {
            case .fft2d:
                vDSP.multiply(T.pi / (wavelength * z), phaseCache, result: &phase)
            case .angular_spectrum:
                vDSP.multiply(-z * T.pi * wavelength, phaseCache, result: &phase)
        }
        return phase
    }
    
    private func intensity_fft2d(wavelength: T, at z: T) -> LTArray2D<T> {
        let ltArray2DComplex = LTArray2DComplex(radius: transmittance, phase: getPhase(wavelength: wavelength, z: z))
        ltArray2DComplex.fft2D()
        return ltArray2DComplex.intensity()
    }
    
    func intensity_angular_spectrum(wavelength: T, at z: T) -> LTArray2D<T> {
        let amplitue = LTArray2DComplex(real: transmittance)
        amplitue.fft2D()
        amplitue.multiply(by: LTArray2DComplex(phase: getPhase(wavelength: wavelength, z: z)) )
        amplitue.fft2D(forward: false)
        var intensity = amplitue.intensity()
        let maximum = vDSP.maximum(intensity)
        let minimum = vDSP.minimum(intensity)
        vDSP.add(multiplication: (intensity, 1/(maximum-minimum)), -minimum, result: &intensity)
        return intensity
    }
}

extension Simulator where T == Float {
    /// `x_n = width * (n - N//2)`, `y_m = height * (m - M//2)`, `rsq_{n,m} = x_n^2 + y_m^2`
    static func rsq(width: T, height: T, Nx: Int, Ny: Int) -> LTArray2D<T> {
        var x = LTArray2D<T>.linspace(start: -width/2,
                                      end: width/2,
                                      width: Nx)
        var y = LTArray2D<T>.linspace(start: -height/2,
                                      end: height/2,
                                      width: Ny)
        vDSP.square(x, result: &x)
        vDSP.square(y, result: &y)
        return LTArray2D<T>.add_meshgrid(row: x, column: y)
    }
    
    /// ` -𝜋/𝜆 * T_{k,p} ` `T_{k, p} = ((k-N/2)/W)^2 + ((p-N/2)/H)^2 `
    static func kz_1stOrderAprx(width: T, height: T, Nx: Int, Ny: Int) -> LTArray2D<T> {
        var x = LTArray2D<T>.linspace(start: -T(Nx)/(width*2),
                                      end: T(Nx)/(width*2),
                                      width: Nx)
        var y = LTArray2D<T>.linspace(start: -T(Ny)/(height*2),
                                      end: T(Ny)/(height*2),
                                      width: Ny)
        
        vDSP.square(x, result: &x)
        vDSP.square(y, result: &y)
        return  LTArray2D<T>.add_meshgrid(row: x, column: y)
    }
    
    static func transmittance(path: (CGRect) -> Path, wResoultion: Int, hResolution: Int) ->
    LTArray2D<T> {
        precondition(wResoultion > 0 && hResolution > 0,"LTArray2D dimensions must be greater than 0")
        let ltUInt8 = LTArray2D<UInt8>(path: path, width: wResoultion, height: hResolution)
        var outputLTArray2D = LTArray2D<T>(width: wResoultion, height: hResolution)
        ltUInt8.to(result: &outputLTArray2D)
        return outputLTArray2D
    }
}

extension Simulator where T == Double {
    /// `x_n = width * (n - N//2)`, `y_m = height * (m - M//2)`, `rsq_{n,m} = x_n^2 + y_m^2`
    static func rsq(width: T, height: T, Nx: Int, Ny: Int) -> LTArray2D<T> {
        var x = LTArray2D<T>.linspace(start: -width/2, end: width/2, width: Nx)
        var y = LTArray2D<T>.linspace(start: -height/2, end: height/2, width: Ny)
        vDSP.square(x, result: &x)
        vDSP.square(y, result: &y)
        return LTArray2D<T>.add_meshgrid(row: x, column: y)
    }
    
    /// ` -𝜋/𝜆 * T_{k,p} ` `T_{k, p} = ((k-N/2)/W)^2 + ((p-N/2)/H)^2 `
    static func kz_1stOrderAprx(width: T, height: T, Nx: Int, Ny: Int) -> LTArray2D<T> {
        var x = LTArray2D<T>.linspace(start: -T(Nx)/(width*2),
                                      end: T(Nx)/(width*2),
                                      width: Nx)
        var y = LTArray2D<T>.linspace(start: -T(Ny)/(height*2),
                                      end: T(Ny)/(height*2),
                                      width: Ny)
        
        vDSP.square(x, result: &x)
        vDSP.square(y, result: &y)
        return  LTArray2D<T>.add_meshgrid(row: x, column: y)
    }
    
    static func transmittance(path: (CGRect) -> Path, wResoultion: Int, hResolution: Int) ->
    LTArray2D<T> {
        precondition(wResoultion > 0 && hResolution > 0,"LTArray2D dimensions must be greater than 0")
        let ltUInt8 = LTArray2D(path: path, width: wResoultion, height: hResolution)
        var outputLTArray2D = LTArray2D<T>(width: wResoultion, height: hResolution)
        ltUInt8.to(result: &outputLTArray2D)
        return outputLTArray2D
    }
}


