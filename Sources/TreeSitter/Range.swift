//
//  Range.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import tree_sitter

public struct Range {

    // MARK: - Properties

    internal var rawValue: TSRange


    // MARK: - Initialisation

    internal init (rawValue: TSRange) {
        self.rawValue = rawValue
    }

    public init (startPoint: Point, endPoint: Point, startByte: UInt32, endByte: UInt32) {
        self.rawValue = TSRange(start_point: startPoint.rawValue, end_point: endPoint.rawValue, start_byte: startByte, end_byte: endByte)
    }


    // MARK: - Wrapped Properties

    public var startPoint: Point {
        get { Point(rawValue: self.rawValue.start_point) }
        set { self.rawValue.start_point = newValue.rawValue }
    }

    public var endPoint: Point {
        get { Point(rawValue: self.rawValue.end_point) }
        set { self.rawValue.end_point = newValue.rawValue }
    }

    public var startByte: UInt32 {
        get { self.rawValue.start_byte }
        set { self.rawValue.start_byte = newValue }
    }

    public var endByte: UInt32 {
        get { self.rawValue.end_byte }
        set { self.rawValue.end_byte = newValue }
    }

}


