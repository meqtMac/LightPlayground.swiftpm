import Accelerate


public class LTArray2D<T>: AccelerateMutableBuffer {
    
    public func withUnsafeMutableBufferPointer<R>(_ body: (inout UnsafeMutableBufferPointer<T>) throws -> R) rethrows -> R {
        var unsafeMutableBufferPointer = UnsafeMutableBufferPointer(start: data, count: count)
        return try body(&unsafeMutableBufferPointer)
    }
    
    public func withUnsafeBufferPointer<R>(_ body: (UnsafeBufferPointer<T>) throws -> R) rethrows -> R {
        return try body(UnsafeBufferPointer(start: data, count: count))
    }
    
    public typealias Element = T
    
    var data: UnsafeMutablePointer<T>
    
    deinit {
        data.deallocate()
    }
    
    public var width: Int
    public var height: Int
    public var count: Int { width * height }
    
    init(width: Int, height: Int, data: UnsafeMutablePointer<T>) {
        self.width = width
        self.height = height
        self.data = data
    }
    
    
    
    public init(width: Int, height: Int) {
        guard width > 0, height > 0 else {
            fatalError("LTArray2D dimensions must be greater than 0")
        }
        let count = width * height
        let data = UnsafeMutablePointer<T>.allocate(capacity: count)
        self.data = data
        self.width = width
        self.height = height
    }
    
    public subscript(x: Int, y: Int) -> T {
        get {
            precondition(x >= 0 && x < width, "Index out of range")
            precondition(y >= 0 && y < height, "Index out of range")
            return data[x + y * width]
        }
        set(newValue) {
            precondition(x >= 0 && x < width, "Index out of range")
            precondition(y >= 0 && y < height, "Index out of range")
            data[x + y * width] = newValue
        }
    }
    
    public func vImageBuffer() -> vImage_Buffer {
        return vImage_Buffer(data: data,
                             height: vImagePixelCount(height),
                             width: vImagePixelCount(width),
                             rowBytes: MemoryLayout<T>.stride * width)
    }
    
    /// data is in LTArray2D is stored as a 1d array, this function didn't change the order of data in array
    public func inPlaceReshape(width: Int, height: Int) {
        precondition(width * height == count, "new shape invalid")
        self.width = width
        self.height = height
    }
    
    /// two LTArray2D have same shape
    public static func shapeEqual(lhs: LTArray2D, rhs: LTArray2D) -> Bool {
        return lhs.height == rhs.height && lhs.width == rhs.width
    }
}
