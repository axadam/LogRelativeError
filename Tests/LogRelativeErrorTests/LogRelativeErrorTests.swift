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
    
    func testStore() {
        let rs: ResultStore = ResultStore()
        let t = "Table 1"
        let f = "Field A"
        
        AssertLRE(1.2340, "1.2345", digits: 3.3, resultStore: rs, table: t, testCase: "no annotation", field: f)
        AssertLRE(1.2345, "1.2345", resultStore: rs, table: t, testCase: "annotation", field: f, annotation: "35 iters")
        
        let md = """
# Table 1
| Case | Field A |
| --- | ---: |
| annotation | 5.0  (35 iters) |
| no annotation | 3.4 |
"""
        XCTAssertEqual(md, rs.md())
    }

    static var allTests = [
        ("testLRENonZero", testLRENonZero),
    ]
}
