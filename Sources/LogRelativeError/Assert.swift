//
//  Assert.swift
//  LogRelativeError
//
//  Created by Adam Roberts on 6/8/19.
//

import XCTest

/// Asserts that one value matches another to a certain number of digits.
///
/// Uses the LRE function to find how many digits of `x` match `c`, then
/// asserts that that number is at least as many as specified by `digits`.
/// Message will also surface the observed vs expected values in the error
/// message.
public func AssertLRE<T: LogTenable>(_ x: T, _ c: T, digits: T, file: StaticString = #file, line: UInt = #line) {
    let lre = LRE(x, c)
    XCTAssertGreaterThanOrEqual(lre, digits, "saw \(x) vs \(c)", file: file, line: line)
}

/// Asserts that a numerical value matches a reference value to a certain number of digits
///
/// Measures the Log Relative Error (LRE) of the value `x` when compared to reference value `c`.
/// LRE approximately corresponds to how many decimal digits are correct. It then asserts that
/// this is the expected number of digits. It will flag if `x` is either more or less precise than expected.
///
/// By default the expected number of digits is the minimum of the machine precision of the type of  `x`
/// or the number of digits provided for `c`. If `exact` is set to `true` then the default is always the
/// machine precision of the type of `x`. You can also specify the number of digits expected.
///
/// If you would like to report on the results of your tests you can use a `ResultStore` to keep
/// the results of each test and then print out its contents in the `tearDown` method of your test
/// class.
///
/// - Parameters:
///   - x: The candidate value
///   - c: The reference value as a string. The number of digits provided in the string affects
///        the default number of expected digits.
///   - exact: If true then expect the full machine precision of the type of `x`
///   - digits: Override the number of expected digits to have correct (in LRE units)
///   - resultStore: Specify in which `ResultStore` to store this result
///   - table: If using a result store specify which table this result goes in
///   - testCase: If using a result store specify which row this result goes in
///   - field: If using a result store specify which column this result goes in
public func AssertLRE<T: LogTenable>(_ x: T, _ c: String, exact: Bool = false, digits: T? = nil, resultStore: ResultStore? = nil, table: String? = nil, testCase: String? = nil, field: String? = nil, file: StaticString = #file, line: UInt = #line) {
    let referenceDigits = countDigits(c)
    guard referenceDigits > 0 else { fatalError("couldn't count reference value digits")}
    guard let referenceValue = T(c) else { fatalError("couldn't parse reference value") }
    let testValue = exact ? x : x.roundedTo(digits: referenceDigits)
    let digitsPossible = exact ? T.significantDecimalDigits : min(T.significantDecimalDigits, T(referenceDigits))
    let lreRounded = min(digitsPossible,LRE(testValue, referenceValue))
    let lreRaw = min(digitsPossible,LRE(x,referenceValue))
    let (lre,value, rawString) = lreRounded >= lreRaw ? (lreRounded,testValue," (\(x))") : (lreRaw,x,"")
    let digitsToUse: T = {
        if let digits = digits {
            return min(digits,digitsPossible)
        }
        return digitsPossible
    }()
    if let resultStore = resultStore, let table = table, let testCase = testCase, let field = field {
        let lreReult = LREResult(table: table, testCase: testCase, field: field, lre: Double(lre.description)!)
        resultStore.addResult(lreReult)
    }
    XCTAssertGreaterThanOrEqual(lre, digitsToUse, "saw \(value)\(rawString) vs \(c)", file: file, line: line)
    XCTAssertLessThanOrEqual(lre, digitsToUse + T(1)/T(10), "BETTER than expected. Raise digits parameter.", file: file, line: line)
}
