//
//  ResultStore.swift
//  LogRelativeError
//
//  Created by Adam Roberts on 6/19/19.
//

import Foundation

public struct LREResult {
    public let table: String
    public let testCase: String
    public let field: String
    public let lre: Double
    public let digitsPossible: Double
    public let annotation: String?
    
    public init(table: String, testCase: String, field: String, lre: Double, digitsPossible: Double, annotation: String? = nil) {
        self.table = table
        self.testCase = testCase
        self.field = field
        self.lre = lre
        self.digitsPossible = digitsPossible
        self.annotation = annotation
    }
}

public extension LREResult {
    var isFullPrecision: Bool { return lre >= digitsPossible }
}

struct LRETable {
    let title: String
    let testCases: [String]
    let fields: [String]
    let entries: [LREResult]
    
    init(title: String, entries: [LREResult]) {
        self.title = title
        self.entries = entries
        self.testCases = Set(entries.map { $0.testCase }).sorted()
        self.fields = Set(entries.map { $0.field }).sorted()
    }
    
    func md() -> String {
        let mdTitle = "# \(title)"
        let mdHeader = fields.reduce("| Case |") { "\($0) \($1) |" }
        let mdSep = "| --- | " + Array(repeating: "---:", count: fields.count).joined(separator: " | ") + " |"
        let mdRows = testCases.map { testCase in
            return fields.reduce("| \(testCase) |", { accum, field in
                if let entry = entries.first(where: { $0.testCase == testCase && $0.field == field} ) {
                    let ann = { () -> String in
                        guard let annot = entry.annotation else { return "" }
                        return " (\(annot)) "
                    }()
                    let b = entry.isFullPrecision ? "__" : ""
                    return "\(accum) \(b)\((entry.lre * 10).rounded() / 10)\(b) \(ann)|"
                }
                return "\(accum) . |"
            })
        }.joined(separator: "\n")
        return [mdTitle,mdHeader,mdSep,mdRows].joined(separator: "\n")
    }
}

public class ResultStore {
    public var results: [LREResult] = []
    public func addResult(_ r: LREResult) {
        results.append(r)
    }
    public init() {}
    
    func tables() -> [LRETable] {
        let byTitle = Dictionary(grouping: results, by: { $0.table })
        return byTitle.map { arg in
            let (title,entries) = arg
            return LRETable(title: title, entries: entries)
        }
    }
    
    public func md() -> String {
        return tables().map { $0.md() }.joined(separator: "\n\n\n")
    }
}
