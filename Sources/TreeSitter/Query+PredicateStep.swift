//
//  Query+PredicateStep.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import tree_sitter

extension Query {
    public struct PredicateStep {

        // MARK: - Properties

        internal var rawValue: TSQueryPredicateStep
        public var type: StepType


        // MARK: - Initialisation

        internal init (rawValue: TSQueryPredicateStep, type: StepType) {
            self.rawValue = rawValue
            self.type = type
        }


        // MARK: - Wrapped Properties

        var id: UInt32 {
            return self.rawValue.value_id
        }
    }
}
