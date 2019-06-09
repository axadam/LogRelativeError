//
//  LogTenable.swift
//  LogRelativeError
//
//  Created by Adam Roberts on 6/8/19.
//

import Foundation

/// Simple protocol to qualify types for which we have log10
///
/// Discard when Swift 5.1 comes out with its ElementaryFunctions protocol
public protocol LogTenable: FloatingPoint {
    /// Base 10 logarithm
    ///
    /// Required by the LRE algorithm to count decimal digits. We want
    /// to get this conformance from ElementaryFunctions once 5.1
    /// comes out.
    func log10() -> Self
    
    /// How many significant decimal digits a floating point type has
    ///
    /// Required so that LRE won't expect more digits to be correct
    /// than the type's storage can handle. Recommended to be set
    /// by hand for each type but a sensible default is provided
    /// for BinaryFloatingPoint types.
    ///
    static var significantDecimalDigits: Self { get }
}

public extension BinaryFloatingPoint {
    static var significantDecimalDigits: Double {
        let d = pow(2.0,Double(significandBitCount)).log10()
        return floor(d)
    }
}

func log10<T: LogTenable>(_ x: T) -> T {
    return x.log10()
}

extension Float: LogTenable {
    public func log10() -> Float {
        return Foundation.log10(self)
    }
    
    public static var significantDecimalDigits: Float { return 6.0 }
}

extension Double: LogTenable {
    public func log10() -> Double {
        return Foundation.log10(self)
    }

    public static var significantDecimalDigits: Double { return 15.0 }
}
