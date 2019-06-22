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
