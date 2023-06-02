////
////  LTMathTest.swift
////
////
////  Created by 蒋艺 on 2023/4/13.
////
//
//import XCTest
//import Accelerate
//
//public final class LTMathTest: XCTestCase {
//
//    public override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    public override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    public func testReshape() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//        let width = 128
//        let height = 156
//        let lt = LTArray2D<Float>(width: width, height: height)
//        lt.inPlaceReshape(width: height, height: width)
//        XCTAssertEqual(lt.width, height)
//        XCTAssertEqual(lt.height, width)
////        XCTAssertThrowsError(lt.inPlaceReshape(width: 100, height: 100))
//    }
//
//    public func testRsqAndkApprox() throws {
//        func panel(x: Float, y: Float, Nx: Int, Ny: Int) -> LTArray2D<Float> {
//            let x = LTArray2D.linspace(start: -x/2, end: x/2, width: Nx, height: 1)
//            let y = LTArray2D.linspace(start: -y/2, end: y/2, width: Ny, height: 1)
//            vDSP_vsq(x.data, 1, x.data, 1, vDSP_Length(Nx))
//            vDSP_vsq(y.data, 1, y.data, 1, vDSP_Length(Ny))
//            return LTArray2D.add_meshgrid(row: x, column: y)
//        }
//
//        let x: Float = 1.0
//        let y: Float = 2.0
//        let Nx: Int = 8
//        let Ny: Int = 16
//        let panel1 = panel(x: x, y: y, Nx: Nx, Ny: Ny)
//        let panel2 = Simulator.rsq(width: x, height: y, Nx: Nx, Ny: Ny)
//        let panel3 = Simulator.kz_1stOrderAprx(width: Float(Nx)/x, height: Float(Ny)/y, Nx: Nx, Ny: Ny)
//        XCTAssert(LTArray2D.valueEqual(lhs: panel1, rhs: panel2))
//        XCTAssert(LTArray2D.valueEqual(lhs: panel1, rhs: panel3))
//    }
//
//    public func testFloatInitPerformance() throws {
//        let power = 10
//        self.measure {
//            let _ = Simulator<Float>(aperture: defaultApertures[0],
//                              resolutionPower: power)
//            return
//        }
//    }
//
//    public func testSimulate512Performance() throws {
//        let power = 9
//        let simulater = Simulator<Float>(aperture: defaultApertures[7],
//                                  resolutionPower: power)
//        self.measure {
//            let _ = simulater.simulate(wavelength: 6.2e-7, at: 1)
//        }
//    }
//
//   public func testSimulate1024Perform() throws {
//        let power = 10
//        let simulater = Simulator<Float>(aperture: defaultApertures[7],
//                                  resolutionPower: power)
//        self.measure {
//            let _ = simulater.simulate(wavelength: 6.2e-7, at: 1)
//        }
//    }
//
//   public func testSimulate2048Perform() throws {
//        let power = 11
//        let simulater = Simulator<Float>(aperture: defaultApertures[7],
//                                  resolutionPower: power)
//        self.measure {
//            let _ = simulater.simulate(wavelength: 6.2e-7, at: 1)
//        }
//    }
//   public func testDoubleInitPerformance() throws {
//        let power = 10
//        self.measure {
//            let _ = Simulator<Double>(aperture: defaultApertures[0],
//                              resolutionPower: power)
//            return
//        }
//    }
//
//   public func testSimulateDouble512Performance() throws {
//        let power = 9
//        let simulater = Simulator<Double>(aperture: defaultApertures[7],
//                                  resolutionPower: power)
//        self.measure {
//            let _ = simulater.simulate(wavelength: 6.2e-7, at: 1)
//        }
//    }
//
//   public func testSimulateDouble1024Perform() throws {
//        let power = 10
//        let simulater = Simulator<Double>(aperture: defaultApertures[7],
//                                  resolutionPower: power)
//        self.measure {
//            let _ = simulater.simulate(wavelength: 6.2e-7, at: 1)
//        }
//    }
//
//   public func testSimulateDouble2048Perform() throws {
//        let power = 11
//        let simulater = Simulator<Double>(aperture: defaultApertures[7],
//                                  resolutionPower: power)
//        self.measure {
//            let _ = simulater.simulate(wavelength: 6.2e-7, at: 1)
//        }
//    }
//}
