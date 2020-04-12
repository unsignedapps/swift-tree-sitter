//
//  Node.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import tree_sitter

public struct Node {

    // MARK: - Properties

    internal var rawValue: TSNode


    // MARK: - Initialisation

    internal init (rawValue: TSNode) {
        self.rawValue = rawValue
    }

    internal init? (traversalNode: TSNode) {
        guard ts_node_is_null(traversalNode) == false else { return nil }
        self.rawValue = traversalNode
    }


    // MARK: - Wrapped Properties

    public var tree: Tree {
        return Tree(rawValue: self.rawValue.tree)
    }

    
    // MARK: - Node Metadata

    public var symbol: Symbol {
        return Symbol(rawValue: ts_node_symbol(self.rawValue))
    }

    /// The receiver's type name.
    public var type: String {
        return String(cString: ts_node_type(self.rawValue))
    }


    // MARK: - Location of node in Tree

    /// The byte location where the node starts
    public var startByte: UInt32 {
        return ts_node_start_byte(self.rawValue)
    }

    /// The byte location where the node ends
    public var endByte: UInt32 {
        return ts_node_end_byte(self.rawValue)
    }

    /// The `Point` where the node starts
    public var startPoint: Point {
        return Point(rawValue: ts_node_start_point(self.rawValue))
    }

    /// The `Point` where the node ends
    public var endPoint: Point {
        return Point(rawValue: ts_node_end_point(self.rawValue))
    }


    // MARK: - Node Contents

    /// An S-expression representing the node.
    public var stringValue: String {
        return String(cString: ts_node_string(self.rawValue))
    }

    /// Whether a nude is null.
    ///
    /// Typically means we've gone off the end of an array of siblings
    ///
    public var isNull: Bool {
        return ts_node_is_null(self.rawValue)
    }

    /// Check if the node is "named". Named nodes correspond to named rules in the
    /// grammar, whereas *anonymous* nodes correspond to string literals in the
    /// grammar.
    public var isNamed: Bool {
        return ts_node_is_named(self.rawValue)
    }

    /// Check if the node is *missing*. Missing nodes are inserted by the parser in
    /// order to recover from certain kinds of syntax errors.
    public var isMissing: Bool {
        return ts_node_is_missing(self.rawValue)
    }

    /// Check if the node is *extra*. Extra nodes represent things like comments,
    /// which are not required the grammar, but can appear anywhere.
    public var isExtra: Bool {
        return ts_node_is_extra(self.rawValue)
    }

    /// Checks if a node has been edited.
    public var hasChanges: Bool {
        return ts_node_has_changes(self.rawValue)
    }

    /// Check if a node is a syntax error or contains syntax errors.
    public var hasError: Bool {
        return ts_node_has_error(self.rawValue)
    }


    // MARK: - Node Traversal

    /// Get the node's immediate parent, or nil if you're at the top of the tree
    public var parent: Node? {
        return Node(traversalNode: ts_node_parent(self.rawValue))
    }

    /// Get *al* of the notes children
    public var children: NodeCollection {
        return NodeCollection(parent: self, namedOnly: false)
    }

    /// Get the node's *named* children
    public var namedChildren: NodeCollection {
        return NodeCollection(parent: self, namedOnly: true)
    }

    /// Get the child with the given name
    public func child (named: String) -> Node? {
        return Node(traversalNode: ts_node_child_by_field_name(self.rawValue, named, UInt32(named.count)))
    }

    /// Get the child for the given field
    public func child (for field: Field) -> Node? {
        return Node(traversalNode: ts_node_child_by_field_id(self.rawValue, field.rawValue))
    }

    /// Get the receiver's next named sibling
    public var nextNamedSibling: Node? {
        return Node(traversalNode: ts_node_next_named_sibling(self.rawValue))
    }

    /// Get the receiver's previous named sibling
    public var previousNamedSibling: Node? {
        return Node(traversalNode: ts_node_prev_named_sibling(self.rawValue))
    }

    /// Get the receiver's next sibling
    public var nextSibling: Node? {
        return Node(traversalNode: ts_node_next_sibling(self.rawValue))
    }

    /// Get the receiver's previous sibling
    public var previousSibling: Node? {
        return Node(traversalNode: ts_node_prev_sibling(self.rawValue))
    }


    // MARK: - Node Lookup at Offsets

    /// Get the node's first child that extends beyond the given byte offset.
    public func firstChild (offset byte: UInt32) -> Node? {
        return Node(traversalNode: ts_node_first_child_for_byte(self.rawValue, byte))
    }

    /// Get the node's first *named* child that extends beyond the given byte offset.
    public func firstNamedChild (offset byte: UInt32) -> Node? {
        return Node(traversalNode: ts_node_first_named_child_for_byte(self.rawValue, byte))
    }


    // MARK: - Node Lookup by Range

    /// Get the smallest node within the receiver that spans the given range of bytes
    public func firstDescendant (spanning range: ClosedRange<UInt32>) -> Node? {
        return Node(traversalNode: ts_node_descendant_for_byte_range(self.rawValue, range.lowerBound, range.upperBound))
    }

    /// Get the smallest node within the receiver that spans the given positions
    public func firstDescendant (spanning range: ClosedRange<Point>) -> Node? {
        return Node(traversalNode: ts_node_descendant_for_point_range(self.rawValue, range.lowerBound.rawValue, range.upperBound.rawValue))
    }

    /// Get the smallest node within the receiver that spans the given range of bytes
    public func firstNamedDescendant (spanning range: ClosedRange<UInt32>) -> Node? {
        return Node(traversalNode: ts_node_descendant_for_byte_range(self.rawValue, range.lowerBound, range.upperBound))
    }

    /// Get the smallest node within the receiver that spans the given positions
    public func firstNamedDescendant (spanning range: ClosedRange<Point>) -> Node? {
        return Node(traversalNode: ts_node_descendant_for_point_range(self.rawValue, range.lowerBound.rawValue, range.upperBound.rawValue))
    }


    // MARK: - Editing

    /// Edit the node to keep it in-sync with source code that has been edited.
    ///
    /// This function is only rarely needed. When you edit a syntax tree with the
    /// `Tree.edit` function, all of the nodes that you retrieve from the tree
    /// afterward will already reflect the edit. You only need to use `Node.edit`
    /// when you have a `Node` instance that you want to keep and continue to use
    /// after an edit.
    public mutating func edit (_ edit: Edit) {
        var rawValue = edit.rawValue
        ts_node_edit(&self.rawValue, &rawValue)
    }
}


// MARK: - Equatable Implementation

extension Node: Equatable {
    public static func == (lhs: Node, rhs: Node) -> Bool {
        return ts_node_eq(lhs.rawValue, rhs.rawValue)
    }
}


public struct NodeCollection: Collection, BidirectionalCollection {

    public typealias Element = Node

    internal let parent: Node
    internal let namedOnly: Bool

    private var current: TSNode? = nil

    public var startIndex = 0
    public var endIndex: Int

    internal init (parent: Node, namedOnly: Bool) {
        self.parent = parent
        self.namedOnly = namedOnly

        let count = namedOnly ? ts_node_named_child_count(parent.rawValue) : ts_node_child_count(parent.rawValue)
        self.endIndex = Int(count) - 1
    }

    public subscript(position: Int) -> Node {
        let next = self.namedOnly ? ts_node_named_child(self.parent.rawValue, UInt32(position)) : ts_node_child(self.parent.rawValue, UInt32(position))
        return Node(rawValue: next)
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }

    public func index(before i: Int) -> Int {
        return i - 1
    }
}
