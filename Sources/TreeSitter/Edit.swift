//
//  Edit.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import tree_sitter

public struct Edit {

    // MARK: - Properties

    public var startByte: UInt32
    public var oldEndByte: UInt32
    public var newEndByte: UInt32

    public var startPoint: Point
    public var oldEndPoint: Point
    public var newEndPoint: Point

    internal lazy var rawValue: TSInputEdit = {
        return TSInputEdit (
            start_byte: self.startByte,
            old_end_byte: self.oldEndByte,
            new_end_byte: self.newEndByte,
            start_point: self.startPoint.rawValue,
            old_end_point: self.oldEndPoint.rawValue,
            new_end_point: self.newEndPoint.rawValue
        )
    }()


    // MARK: - Initialisation

    public init(startByte: UInt32, oldEndByte: UInt32, newEndByte: UInt32, startPoint: Point, oldEndPoint: Point, newEndPoint: Point) {
        self.startByte = startByte
        self.oldEndByte = oldEndByte
        self.newEndByte = newEndByte
        self.startPoint = startPoint
        self.oldEndPoint = oldEndPoint
        self.newEndPoint = newEndPoint
    }
}
