import Accelerate

// Common Implementation of Float and Double
public extension LTArray2D where T == Float {
    convenience init(repeating: T, width: Int, height: Int) {
        self.init(width: width, height: height)
        var ptr = UnsafeMutableBufferPointer(start: data, count: count)
        vDSP.fill(&ptr, with: repeating)
    }
    
    func copy() -> LTArray2D<T> {
        return LTArray2D<T>.init(copyOf: self)
    }
    
    static func linspace(start: T, end: T, width: Int, height: Int = 1) -> LTArray2D<T> {
        var lt = LTArray2D<T>(width: width, height: height)
        vDSP.formRamp(withInitialValue: start,
                      increment: (end-start)/T(width*height-1),
                      result: &lt)
        return lt
    }
    
    /// `A_{n, m} = x_n + y_m`
    static func add_meshgrid(row: LTArray2D<T>, column: LTArray2D<T>) -> LTArray2D<T> {
        precondition(row.height == 1 && column.height == 1, "row and column must be one dimension vector ")
        let Nx = row.width
        let Ny = column.width
        let Ix = LTArray2D<T>(repeating: 1.0, width: 1, height: Ny)
        var xx = row.mmul(with: Ix)
        let Iy = LTArray2D<T>(repeating: 1.0, width: Nx, height: 1)
        column.inPlaceReshape(width: 1, height: Ny)
        let yy = Iy.mmul(with: column)
        column.inPlaceReshape(width: Ny, height: 1)
        vDSP.add(xx, yy, result: &xx)
        return xx
    }
    
    /// two LTArray2D have same shape and value
    static func valueEqual(lhs: LTArray2D<T>, rhs: LTArray2D<T>) -> Bool {
        if !shapeEqual(lhs: lhs, rhs: rhs) {
            return false
        }
        return vDSP.distanceSquared(lhs, rhs) == 0
    }
}

public extension LTArray2D where T == Double {
    convenience init(repeating: T, width: Int, height: Int) {
        self.init(width: width, height: height)
        var ptr = UnsafeMutableBufferPointer(start: data, count: count)
        vDSP.fill(&ptr, with: repeating)
    }
    
    func copy() -> LTArray2D<T> {
        return LTArray2D<T>.init(copyOf: self)
    }
    
    static func linspace(start: T, end: T, width: Int, height: Int = 1) -> LTArray2D<T> {
        var lt = LTArray2D<T>(width: width, height: height)
        vDSP.formRamp(withInitialValue: start,
                      increment: (end-start)/T(width*height-1),
                      result: &lt)
        return lt
    }
    
    /// `A_{n, m} = x_n + y_m`
    static func add_meshgrid(row: LTArray2D<T>, column: LTArray2D<T>) -> LTArray2D<T> {
        precondition(row.height == 1 && column.height == 1, "row and column must be one dimension vector ")
        let Nx = row.width
        let Ny = column.width
        let Ix = LTArray2D<T>(repeating: 1.0, width: 1, height: Ny)
        var xx = row.mmul(with: Ix)
        let Iy = LTArray2D<T>(repeating: 1.0, width: Nx, height: 1)
        column.inPlaceReshape(width: 1, height: Ny)
        let yy = Iy.mmul(with: column)
        column.inPlaceReshape(width: Ny, height: 1)
        vDSP.add(xx, yy, result: &xx)
        return xx
    }
    
    /// two LTArray2D have same shape and value
    static func valueEqual(lhs: LTArray2D<T>, rhs: LTArray2D<T>) -> Bool {
        if !shapeEqual(lhs: lhs, rhs: rhs) {
            return false
        }
        return vDSP.distanceSquared(lhs, rhs) == 0
    }
}

// MARK: Float specific implementation
public extension LTArray2D where T == Float {
    /// Copy constructor of single precision float
    convenience init(copyOf ltArray2D: LTArray2D<T>) {
        self.init(width: ltArray2D.width, height: ltArray2D.height)
        vDSP_mmov(ltArray2D.data,
                  self.data,
                  vDSP_Length(width),
                  vDSP_Length(height),
                  vDSP_Length(width),
                  vDSP_Length(width))
    }
    
    /// matrix multiply for single precision float
    func mmul(with other: LTArray2D<T>) -> LTArray2D<T> {
        precondition(height == other.width, "Invalid matrix dimensions")
        let M = vDSP_Length( self.width)
        let P = vDSP_Length( self.height)
        let N = vDSP_Length( other.height)
        let result = LTArray2D<T>(width: self.width, height: other.height)
        
        vDSP_mmul(self.data,  vDSP_Stride(1),
                  other.data, vDSP_Stride(1),
                  result.data, vDSP_Stride(1),
                  M, N, P)
        return result
    }
}

// MARK: Double specific implementation
public extension LTArray2D where T == Double {
    /// Copy constructor
    convenience init(copyOf ltArray2D: LTArray2D<T>) {
        self.init(width: ltArray2D.width, height: ltArray2D.height)
        vDSP_mmovD(ltArray2D.data,
                  self.data,
                  vDSP_Length(width),
                  vDSP_Length(height),
                  vDSP_Length(width),
                  vDSP_Length(width))
    }
   
    /// matrix multiply
    func mmul(with other: LTArray2D<T>) -> LTArray2D<T> {
        precondition(height == other.width, "Invalid matrix dimensions")
        let M = vDSP_Length( self.width)
        let P = vDSP_Length( self.height)
        let N = vDSP_Length( other.height)
        let result = LTArray2D<T>(width: self.width, height: other.height)
        
        vDSP_mmulD(self.data,  vDSP_Stride(1),
                  other.data, vDSP_Stride(1),
                  result.data, vDSP_Stride(1),
                  M, N, P)
        return result
    }
}


