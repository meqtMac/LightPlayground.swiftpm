import Accelerate

public extension LTArray2D where T == UInt8 {
    /// `i * (max - min) / 255.0 + min`
    func float(max: Float = 1, min: Float = 0) -> LTArray2D<Float> {
        var newLTArray2D = LTArray2D<Float>(width: width, height: height)
        to(max: max, min: min, result: &newLTArray2D)
        return newLTArray2D
    }
    
    func double(max: Double = 1, min: Double = 0) -> LTArray2D<Double> {
        var newLTArray2D = LTArray2D<Double>(width: width, height: height)
        to(max: max, min: min, result: &newLTArray2D)
        return newLTArray2D
    }
    
    func to(max: Double = 1, min: Double = 0, result: inout LTArray2D<Double>) {
        vDSP.convertElements(of: self, to: &result)
        vDSP.add(multiplication: (result, (max - min) / Double(255.0)), min, result: &result)
    }
    
    func to(max: Float = 1, min: Float = 0, result: inout LTArray2D<Float> ) {
        vDSP.convertElements(of: self, to: &result)
        vDSP.add(multiplication: (result, (max - min) / Float(255.0)), min, result: &result)
    }
}

public extension LTArray2D where T == Double {
    func toUInt8(max: T = 1, min: T = 0) -> LTArray2D<UInt8> {
        let tempFloat = toFloat()
        return tempFloat.toUInt8(max: Float(max), min: Float(min))
    }
    
    func toFloat() -> LTArray2D<Float> {
        var tempFloat = LTArray2D<Float>(width: width, height: height)
        vDSP.convertElements(of: self, to: &tempFloat)
        to(result: &tempFloat)
        return tempFloat
    }
   
    func to(result: inout LTArray2D<Float>) {
        vDSP.convertElements(of: self, to: &result)
    }
}

public extension LTArray2D where T == Float {
    func toUInt8(max: Float = 1, min: Float = 0) -> LTArray2D<UInt8> {
        let ltArray2D = LTArray2D<UInt8>(width: width, height: height)
        
        var dataBuffer = self.vImageBuffer()
        var newDataBuffer = ltArray2D.vImageBuffer()
        
        vImageConvert_PlanarFtoPlanar8(&dataBuffer, &newDataBuffer, max, min, vImage_Flags(kvImageNoFlags))
        return ltArray2D
    }
    
    func toDouble() -> LTArray2D<Double> {
        var templtd = LTArray2D<Double>(width: width, height: height)
        to(result: &templtd)
        return templtd
    }
    
    /// convert double precision float point to single precision float point
    func to(result: inout LTArray2D<Double>) {
        vDSP.convertElements(of: self, to: &result)
    }
}
