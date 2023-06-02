import Accelerate

public class LTArray2DComplex<T> where T: vDSP_FloatingPointGeneratable {
    private var real: LTArray2D<T>
    private var imag: LTArray2D<T>
    
    public let width: Int
    public let height: Int
    public var count: Int {
        width * height
    }
    
    init(real: LTArray2D<T>, imag: LTArray2D<T>) {
        guard real.width == imag.width && real.height == imag.height else {
            fatalError("real and imag LTArray2D<Float> of Different Shape")
        }
        self.width = real.width
        self.height = real.height
        self.real = real
        self.imag = imag
    }
}

// MARK: Float Specific
public extension LTArray2DComplex where T == Float {
    var dsp: DSPSplitComplex {
        DSPSplitComplex(realp: real.data, imagp: imag.data)
    }
    
    func fft2D(forward: Bool = true){
        let log2m = vDSP_Length(log2(Float(width)) )
        let log2n = vDSP_Length(log2(Float(height)) )
        
        let fftSetup = vDSP_create_fftsetup(max(log2m, log2n), Int32(kFFTRadix2))!
        defer {
            vDSP_destroy_fftsetup(fftSetup)
        }
        var dspPtr = dsp
        vDSP_fft2d_zip(fftSetup,
                       &dspPtr, 1, 0,
                       log2m, log2n, forward ? FFTDirection(kFFTDirection_Forward) : FFTDirection(kFFTDirection_Inverse))
    }
    
    
    
}

// MARK: Double specific
public extension LTArray2DComplex where T == Double {
    var dsp: DSPDoubleSplitComplex {
        DSPDoubleSplitComplex(realp: real.data, imagp: imag.data)
    }
    
    func fft2D(forward: Bool = true){
        let log2m = vDSP_Length(log2(Float(width)) )
        let log2n = vDSP_Length(log2(Float(height)) )
        
        let fftSetupD = vDSP_create_fftsetupD(max(log2m, log2n), Int32(kFFTRadix2))!
        defer {
            vDSP_destroy_fftsetupD(fftSetupD)
        }
        var dspPtr = dsp
        vDSP_fft2d_zipD(fftSetupD,
                       &dspPtr, 1, 0,
                       log2m, log2n, forward ? FFTDirection(kFFTDirection_Forward) : FFTDirection(kFFTDirection_Inverse))
    }
}

// MARK: Uniform
public extension LTArray2DComplex where T == Float {
    
    convenience init(width: Int, height: Int) {
        precondition(width > 0 && height > 0, "shape must be positive")
        self.init(real: LTArray2D<T>(width: width, height: height),
                  imag: LTArray2D<T>(width: width, height: height))
    }
    
    convenience init(real: LTArray2D<T>) {
        self.init(real: LTArray2D<T>(copyOf: real), imag: LTArray2D<T>(width: real.width, height: real.height))
    }

    convenience init(imag: LTArray2D<T>) {
        self.init(real: LTArray2D(width: imag.width, height: imag.height), imag: LTArray2D(copyOf: imag))
    }
    
    convenience init(radius: LTArray2D<T>, phase: LTArray2D<T>) {
        precondition(radius.width == phase.width && radius.height == phase.width, "radius and phase must be of same shape")
        self.init(phase: phase)
        vDSP.multiply(real, radius, result: &real)
        vDSP.multiply(imag, radius, result: &imag)
    }
    
    convenience init(phase: LTArray2D<T> ) {
        let width = phase.width
        let height = phase.height
        var cphase = LTArray2D<T>(width: width, height: height)
        var sphase = LTArray2D<T>(width: width, height: height)
        vForce.cos(phase, result: &cphase)
        vForce.sin(phase, result: &sphase)
        self.init(real: cphase, imag: sphase)
    }
    
    func intensity() -> LTArray2D<T> {
        var intensity = LTArray2D<T>(width: width, height: height)
        vDSP.squareMagnitudes(dsp, result: &intensity)
        return intensity
    }
    
    func multiply(by ltArray2DComplex: LTArray2DComplex<T>) {
        var dspPtr = dsp
        vDSP.multiply(dsp, by: ltArray2DComplex.dsp, count: count, useConjugate: false, result: &dspPtr)
    }
}

public extension LTArray2DComplex where T == Double {
    
    convenience init(width: Int, height: Int) {
        precondition(width > 0 && height > 0, "shape must be positive")
        self.init(real: LTArray2D<T>(width: width, height: height),
                  imag: LTArray2D<T>(width: width, height: height))
    }
    
    convenience init(real: LTArray2D<T>) {
        self.init(real: LTArray2D<T>(copyOf: real), imag: LTArray2D<T>(width: real.width, height: real.height))
    }
    
    convenience init(imag: LTArray2D<T>) {
        self.init(real: LTArray2D<T>(width: imag.width, height: imag.height), imag: LTArray2D<T>(copyOf: imag))
    }
    
    convenience init(radius: LTArray2D<T>, phase: LTArray2D<T>) {
        precondition(radius.width == phase.width && radius.height == phase.width, "radius and phase must be of same shape")
        self.init(phase: phase)
        vDSP.multiply(real, radius, result: &real)
        vDSP.multiply(imag, radius, result: &imag)
    }
    
    convenience init(phase: LTArray2D<T> ) {
        let width = phase.width
        let height = phase.height
        var cphase = LTArray2D<T>(width: width, height: height)
        var sphase = LTArray2D<T>(width: width, height: height)
        vForce.cos(phase, result: &cphase)
        vForce.sin(phase, result: &sphase)
        self.init(real: cphase, imag: sphase)
    }
    
    func intensity() -> LTArray2D<T> {
        var intensity = LTArray2D<T>(width: width, height: height)
        vDSP.squareMagnitudes(dsp, result: &intensity)
        return intensity
    }
    
    func multiply(by ltArray2DComplex: LTArray2DComplex<T>) {
        var dspPtr = dsp
        vDSP.multiply(dsp, by: ltArray2DComplex.dsp, count: count, useConjugate: false, result: &dspPtr)
    }
}



