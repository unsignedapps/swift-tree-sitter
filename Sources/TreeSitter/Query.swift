//
//  Query.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import Foundation
import tree_sitter

public class Query {

    // MARK: - Properties

    internal var rawValue: OpaquePointer


    // MARK: - Initialisation

    /// Create a new query from a string containing one or more S-expression
    /// patterns. The query is associated with a particular language, and can
    /// only be run on syntax nodes parsed with that language.
    ///
    /// If any of the patterns are invalid this will throw a Query.Error
    public init (query: String, language: Language) throws {
        var errorOffset: UInt32 = 0
        var errorType: TSQueryError = TSQueryErrorNone

        guard let rawValue = ts_query_new(language.rawValue, query, UInt32(query.count), &errorOffset, &errorType) else {
            throw Error(error: errorType, offset: errorOffset)
        }

        self.rawValue = rawValue
    }

    deinit {
        ts_query_delete(self.rawValue)
    }


    // MARK: - Query Information

    /// Get the number of patterns in the query
    public var patternCount: Int {
        return Int(ts_query_pattern_count(self.rawValue))
    }

    /// Get the number of captures in the query
    public var captureCount: Int {
        return Int(ts_query_capture_count(self.rawValue))
    }

    /// Get the number of string literals in the query
    public var stringCount: Int {
        return Int(ts_query_string_count(self.rawValue))
    }

    /// Get the byte offset where the given pattern starts in the query's source.
    ///
    /// This can be useful when combining queries by concatenating their source
    /// code strings.
    public func offset (for pattern: UInt32) -> UInt32 {
        return ts_query_start_byte_for_pattern(self.rawValue, pattern)
    }


    // MARK: - Predicate Steps

    /// Get all of the predicates for the given pattern in the query.
    ///
    /// There are three types of steps in this array, which correspond
    /// to the three legal values for the `type` property:
    /// - `.capture` - Steps with this type represent names
    ///    of captures. Their `value_id` can be used with the
    ///   `ts_query_capture_name_for_id` function to obtain the name of the capture.
    /// - `.string` - Steps with this type represent literal
    ///    strings. Their `value_id` can be used with the
    ///    `ts_query_string_value_for_id` function to obtain their string value.
    /// - `.done` - Steps with this type are *sentinels*
    ///    that represent the end of an individual predicate. If a pattern has two
    ///    predicates, then there will be two steps with this `type` in the array.
    ///
    public func predicates (patternIndex: UInt32) -> [PredicateStep] {
        var length: UInt32 = 0
        guard let result = ts_query_predicates_for_pattern(self.rawValue, patternIndex, &length) else { return [] }

        let buffer = UnsafeBufferPointer(start: result, count: Int(length))
        return buffer
            .compactMap { step in
                switch step.type {
                case TSQueryPredicateStepTypeCapture:
                    var length: UInt32 = 0
                    let ptr = ts_query_capture_name_for_id(self.rawValue, step.value_id, &length)
                    let name = ptr.flatMap { NSString(bytes: $0, length: Int(length), encoding: String.Encoding.utf8.rawValue) }

                    return PredicateStep(rawValue: step, type: .capture(name: name as String?))

                case TSQueryPredicateStepTypeString:
                    var length: UInt32 = 0
                    let ptr = ts_query_string_value_for_id(self.rawValue, step.value_id, &length)
                    let value = ptr.flatMap { NSString(bytes: $0, length: Int(length), encoding: String.Encoding.utf8.rawValue) }

                    return PredicateStep(rawValue: step, type: .string(value: value as String?))

                case TSQueryPredicateStepTypeDone:
                    return PredicateStep(rawValue: step, type: .done)

                default:
                    return nil
                }
            }
    }


    // MARK: - Disabling Parts of a Query

    /// Disable a certain capture within a query.
    ///
    /// This prevents the capture from being returned in matches, and also avoids
    /// any resource usage associated with recording the capture. Currently, there
    /// is no way to undo this.
    ///
    public func disable (capture name: String) {
        ts_query_disable_capture(self.rawValue, name, UInt32(name.count))
    }

    /// Disable a certain pattern within a query.
    ///
    /// This prevents the pattern from matching and removes most of the overhead
    /// associated with the pattern. Currently, there is no way to undo this.
    public func disable (pattern index: UInt32) {
        ts_query_disable_pattern(self.rawValue, index)
    }
}


// MARK: - Errors

extension Query {
    public enum Error: Swift.Error {
        case none
        case syntax (offset: Int)
        case nodeType (offset: Int)
        case field (offset: Int)
        case capture (offset: Int)
        case unknown (offset: Int)

        internal init (error: TSQueryError, offset: UInt32) {
            switch error {
            case TSQueryErrorNone:      self = .none
            case TSQueryErrorSyntax:    self = .syntax(offset: Int(offset))
            case TSQueryErrorNodeType:  self = .nodeType(offset: Int(offset))
            case TSQueryErrorField:     self = .field(offset: Int(offset))
            case TSQueryErrorCapture:   self = .capture(offset: Int(offset))
            default:                    self = .unknown(offset: Int(offset))
            }
        }
    }
}
