import XCTest
@testable import LogRelativeError

final class LogRelativeErrorTests: XCTestCase {
    func testLRENonZero() {
        // Test LRE with a non-zero value for relative comparison
        let lre = LRE(1.0000000001e10, 1.000000000e10)
        XCTAssertEqual(lre, 10, accuracy: 1e-15)
    }

    func testLREZero() {
        // Test LRE with zero for absolute comparison
        let lre = LRE(0.0000000001, 0.000000000)
        XCTAssertEqual(lre, 10, accuracy: 1e-15)
    }
    
    func testCountDigits() {
        /// test that we're counting digits correctly
        XCTAssertEqual(countDigits("1.234e-10"), 4)
        XCTAssertEqual(countDigits("1.234E10"), 4)
        XCTAssertEqual(countDigits("1.234 x 10^-10"), 4)
        XCTAssertEqual(countDigits("0.00001234"), 4)
        XCTAssertEqual(countDigits("123456.789"), 9)
    }

    static var allTests = [
        ("testLRENonZero", testLRENonZero),
    ]
}
