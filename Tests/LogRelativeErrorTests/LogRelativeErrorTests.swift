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

    static var allTests = [
        ("testLRENonZero", testLRENonZero),
    ]
}
