//
//  Tree.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import tree_sitter

public class Tree {

    // MARK: - Properties

    internal var rawValue: OpaquePointer


    // MARK: - Initialisation

    internal init (rawValue: OpaquePointer) {
        self.rawValue = rawValue
    }


    // MARK: - Copying

    /// Create a shallow copy of the syntax tree. This is very fast.
    ///
    /// This function is mostly intended to be used when you need multiple
    /// threads as trees are not thread safe.
    ///
    public func copy () -> Tree? {
        guard let copy = ts_tree_copy(self.rawValue) else { return nil }
        return Tree(rawValue: copy)
    }


    // MARK: - Nodes and Languages

    ///  The root node of the syntax tree
    var rootNode: Node {
        return Node(rawValue: ts_tree_root_node(self.rawValue))
    }

    /// The language that was used to parse the syntax tree
    var language: Language {
        return Language(rawValue: ts_tree_language(self.rawValue))
    }


    // MARK: - Editing Trees

    public func edit (_ edit: Edit) {
        var rawValue = edit.rawValue
        ts_tree_edit(self.rawValue, &rawValue)
    }

    /// Compare an old edited syntax tree to a new syntax tree representing the same
    /// document, returning an array of ranges whose syntactic structure has changed.
    ///
    /// For this to work correctly, the old syntax tree must have been edited such
    /// that its ranges match up to the new tree. Generally, you'll want to call
    /// this function right after calling the `Parser.parse` function.
    /// You need to pass the old tree that was passed to parse, as well as the new
    /// tree that was returned from that function.
    ///
    public func changedRanges (oldTree: Tree) -> [Range] {
        var count: UInt32 = 0
        let buffer = UnsafeBufferPointer(start: ts_tree_get_changed_ranges(oldTree.rawValue, self.rawValue, &count), count: Int(count))
        return Array(buffer).map(Range.init(rawValue:))
    }
}
