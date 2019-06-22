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
public protocol LogTenable: FloatingPoint, LosslessStringConvertible {
    /// Base 10 logarithm
    ///
    /// Required by the LRE algorithm to count decimal digits. We want
    /// to get this conformance from ElementaryFunctions once 5.1
    /// comes out.
    func log10() -> Self
    
    /// Power function
    ///
    /// pow(a,b) = a^b
    ///
    /// Remove once 5.1 comes out
    func pow(_ x: Self) -> Self
    
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

extension LogTenable {
    func roundedTo(digits: Int) -> Self {
        let factor = Self(10).pow(Self(digits - 1) - abs(self).log10().rounded(.down))
        return (self * factor).rounded() / factor
    }
}

func log10<T: LogTenable>(_ x: T) -> T {
    return x.log10()
}

func pow<T: LogTenable>(_ a: T, b: T) -> T {
    return a.pow(b)
}

extension Float: LogTenable {
    public func log10() -> Float {
        return Foundation.log10(self)
    }
    
    public func pow(_ x: Float) -> Float {
        return Foundation.powf(self, x)
    }
    
    public static var significantDecimalDigits: Float { return 6.0 }
}

extension Double: LogTenable {
    public func log10() -> Double {
        return Foundation.log10(self)
    }

    public func pow(_ x: Double) -> Double {
        return Foundation.pow(self, x)
    }
    
    public static var significantDecimalDigits: Double { return 15.0 }
}
