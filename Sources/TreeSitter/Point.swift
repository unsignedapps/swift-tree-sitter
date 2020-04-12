//
//  Point.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import tree_sitter

public struct Point {

    // MARK: - Properties

    internal var rawValue: TSPoint


    // MARK: - Initialisation

    internal init (rawValue: TSPoint) {
        self.rawValue = rawValue
    }


    // MARK: - Wrapped Properties

    public var row: UInt32 {
        get { self.rawValue.row }
        set { self.rawValue.row = newValue}
    }

    public var column: UInt32 {
        get { self.rawValue.column }
        set { self.rawValue.column = newValue}
    }

}


// MARK: - Comparable Implementation

extension Point: Equatable, Comparable {
    public static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }

    /// From point.h
    public static func < (lhs: Point, rhs: Point) -> Bool {
        return (lhs.row < rhs.row) || (lhs.row == rhs.row && lhs.column < rhs.column);
    }
}
