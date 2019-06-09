//
//  LogRelativeError.swift
//  LogRelativeError
//
//  Created by Adam Roberts on 6/8/19.
//

import Foundation

/// Log Relative Error (LRE)
///
/// Gives the number of correct digits. If the reference value is non-zero
/// it uses relative error. If the reference value is zero it uses absolute.
///
/// Assessing the Reliability of Statistical Software, B.D. McCullogh 1998
public func LRE<T: LogTenable>(_ x: T, _ c: T) -> T {
    switch c {
    case 0: return min( T.significantDecimalDigits, -log10(abs(x - c)         ) )
    case _: return min( T.significantDecimalDigits, -log10(abs(x - c) / abs(c)) )
    }
}
