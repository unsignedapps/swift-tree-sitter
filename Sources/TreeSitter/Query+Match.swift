//
//  Query+Match.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import tree_sitter

extension Query {
    public struct Match {

        // MARK: - Properties

        internal var rawValue: TSQueryMatch


        // MARK: - Initialisation

        internal init (rawValue: TSQueryMatch) {
            self.rawValue = rawValue
        }


        // MARK: - Wrapped Properties

        public var id: UInt32 {
            return self.rawValue.id
        }

        public var patternIndex: UInt16 {
            return self.rawValue.pattern_index
        }

        public var captures: [Capture] {
            guard self.rawValue.capture_count > 0 else { return [] }
            let buffer = UnsafeBufferPointer(start: self.rawValue.captures, count: Int(self.rawValue.capture_count))
            return buffer.map(Capture.init(rawValue:))
        }
    }
}
