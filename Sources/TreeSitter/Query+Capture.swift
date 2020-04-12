//
//  Query+Capture.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import tree_sitter

extension Query {
    public struct Capture {

        // MARK: - Properties

        internal var rawValue: TSQueryCapture


        // MARK: - Initialisation

        internal init (rawValue: TSQueryCapture) {
            self.rawValue = rawValue
        }


        // MARK: - Wrapped Properties

        public var index: UInt32 {
            return self.rawValue.index
        }

        public var node: Node {
            return Node(rawValue: self.rawValue.node)
        }
    }
}
