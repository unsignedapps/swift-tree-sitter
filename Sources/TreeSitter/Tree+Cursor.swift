//
//  Tree.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import tree_sitter

extension Tree {
    public class Cursor {

        // MARK: - Properties

        internal var rawValue: TSTreeCursor


        // MARK: - Initialisation

        public convenience init (node: Node) {
            self.init(rawNode: node.rawValue)
        }

        internal convenience init (rawNode: TSNode) {
            self.init(rawValue: ts_tree_cursor_new(rawNode))
        }

        internal init (rawValue: TSTreeCursor) {
            self.rawValue = rawValue
        }

        deinit {
            ts_tree_cursor_delete(&self.rawValue)
        }


        // MARK: - Moving The Cursor

        /// Re-initialize a tree cursor to start at a different node.
        public func reset (node: Node) {
            ts_tree_cursor_reset(&self.rawValue, node.rawValue)
        }

        /// Moves the cursor to the parent and returns whether the move was successful
        public func gotoParent () -> Bool {
            return ts_tree_cursor_goto_parent(&self.rawValue)
        }

        /// Moves the cursor to the next sibling and returns whether the move was successful
        public func gotoNextSibling () -> Bool {
            return ts_tree_cursor_goto_next_sibling(&self.rawValue)
        }

        /// Moves the cursor to the first child and returns whether the move was successful
        public func gotoFirstChild () -> Bool {
            return ts_tree_cursor_goto_first_child(&self.rawValue)
        }

        /// Moves the cursor to the first child that extends beyond the given offset
        /// and if successfull wiill return the index of the child node where it was found
        public func gotoFirstChild (offset byte: UInt32) -> Int? {
            let index = Int(ts_tree_cursor_goto_first_child_for_byte(&self.rawValue, byte))
            return index == -1 ? nil : index
        }


        // MARK: - Current Node

        /// The tree cursor's current node. You can also move it by supplying
        /// a new non-nil node.
        public var current: Node? {
            get { Node(traversalNode: ts_tree_cursor_current_node(&self.rawValue)) }
            set {
                guard let newValue = newValue else { return }
                self.reset(node: newValue)
            }
        }

        /// Get the field of the receiver''s current node, if the current node has a field
        var currentField: Field? {
            let field = ts_tree_cursor_current_field_id(&self.rawValue)
            guard field != 0 else { return nil }

            let name = ts_tree_cursor_current_field_name(&self.rawValue).flatMap(String.init(cString:))
            return Field(rawValue: field, name: name)
        }


        // MARK: - Copying Cursors

        /// Creates a copy of the receiver. Probably for thread safety.
        ///
        /// - SeeAlso: Tree.copy
        ///
        public func copy () -> Tree.Cursor {
            return Cursor(rawValue: ts_tree_cursor_copy(&self.rawValue))
        }
    }
}
