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
