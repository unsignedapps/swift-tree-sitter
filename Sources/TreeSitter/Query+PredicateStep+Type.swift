//
//  Query+PredicateStep+Type.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import tree_sitter

extension Query.PredicateStep {
    public enum StepType {

        // MARK: - Cases

        case capture (name: String?)
        case string (value: String?)
        case done

    }
}


// MARK: - Interoperability

extension Query.PredicateStep.StepType {

    var rawValue: TSQueryPredicateStepType {
        switch self {
        case .capture:      return TSQueryPredicateStepTypeCapture
        case .string:       return TSQueryPredicateStepTypeString
        case .done:         return TSQueryPredicateStepTypeDone
        }
    }

}
