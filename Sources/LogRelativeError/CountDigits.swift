//
//  CountDigits.swift
//  LogRelativeError
//
//  Created by Adam Roberts on 6/17/19.
//

import Foundation

/// Count the digits in a string representation of a number
///
/// Use regex to remove punctuation, exponent notation, and leading zeroes.
/// Then count characters to find out how many digits a string actually specifies.
func countDigits(_ s: String) -> Int {
    // match an exponent notation suffix
    let regExponent = try! NSRegularExpression(pattern: "[xe].*", options: .caseInsensitive)
    
    // match non-numeric characters
    let regPunctuation = try! NSRegularExpression(pattern: "[^0-9]", options: [])
    
    // match leading zeroes
    let regZero = try! NSRegularExpression(pattern: "^0+", options: [])
    
    // apply regexes
    let modstring = regExponent.stringByReplacingMatches(in: s, options: [], range: NSRange(location: 0, length: s.count), withTemplate: "")
    let modstring2 = regPunctuation.stringByReplacingMatches(in: modstring, options: [], range: NSRange(location: 0, length: modstring.count), withTemplate: "")
    let modstring3 = regZero.stringByReplacingMatches(in: modstring2, options: [], range: NSRange(location: 0, length: modstring2.count), withTemplate: "")
    
    // get the final count of characters
    if modstring3.count == 0 && modstring2.count > 0 {
        // it's all zeroes so return the count of zeroes
        return modstring2.count
    }
    return modstring3.count
}
