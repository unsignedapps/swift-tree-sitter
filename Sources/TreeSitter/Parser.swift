//
//  Parser.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import Foundation
import tree_sitter

public class Parser {

    // MARK: - Properties

    internal var rawValue: OpaquePointer


    // MARK: - Initialisation

    public init () {
        self.rawValue = ts_parser_new()
        ts_parser_set_cancellation_flag(self.rawValue, &self._isCancelled)
    }

    /// Delete the parser, freeing all of the memory that it used.
    deinit {
        ts_parser_delete(self.rawValue)
    }


    // MARK: - Language

    /// Get the parser's current language.
    public var language: Language? {
        get {
            guard let language = ts_parser_language(self.rawValue) else { return nil }
            return Language(rawValue: language)
        }
    }

    /// Set the language that the parser should use for parsing.
    ///
    /// Returns a boolean indicating whether or not the language was successfully
    /// assigned. True means assignment succeeded. False means there was a version
    /// mismatch: the language was generated with an incompatible version of the
    /// Tree-sitter CLI. Check the language's version using `ts_language_version`
    /// and compare it to this library's `TREE_SITTER_LANGUAGE_VERSION` and
    /// `TREE_SITTER_MIN_COMPATIBLE_LANGUAGE_VERSION` constants.
    ///
    public func setLanguage (_ language: Language) throws {
        if ts_parser_set_language(self.rawValue, language.rawValue) == false {
            throw Error.languageVersionMismatch(language)
        }
    }


    // MARK: - Included Ranges

    /// The ranges of text that the paser will include when parsing
    ///
    /// By default, the parser will always include entire documents. This
    /// allows you to parse only a *portion* of a document but still return a syntax
    /// tree whose ranges match up with the document as a whole. You can also set
    /// multiple disjoint ranges.
    ///
    public var includedRanges: [Range] {
        get {
            var count: UInt32 = 0
            let buffer = UnsafeBufferPointer(start: ts_parser_included_ranges(self.rawValue, &count), count: Int(count))
            return Array(buffer).map(Range.init(rawValue:))
        }
        set {
            let raw = newValue.map { $0.rawValue }
            ts_parser_set_included_ranges(self.rawValue, raw, UInt32(raw.count))
        }
    }


    // MARK: - Parsing

    /// Use the parser to parse a source code string
    ///
    ///
    /// If you have already parsed an earlier version of this document and the
    /// document has since been edited, pass the previous syntax tree so that the
    /// unchanged parts of it can be reused. This will save time and memory.
    /// For this to work correctly, you must have already edited the old syntax tree
    /// using the `Tree.edit` function in a way that exactly matches the source code changes.
    ///
    /// - Parameters:
    ///   - string:     A source code string
    ///   - encoding:   An optional string encoding. Defaults to .utf8.
    ///   - oldTree:    An existing tree that you've edited. This can save time and memory in re-parsing.
    ///                 If you're parsing a new tree omit this or set to `nil`.
    ///
    /// - Returns:      A parsed `Tree`, or nil if parsing was cancelled (see `Parser.isCancelled`) or timed out.
    ///
    public func parse (string: String, encoding: InputEncoding = .utf8, oldTree: Tree? = nil) throws -> Tree? {
        guard self.language != nil else { throw Error.noLanguage }

        guard let tree = ts_parser_parse_string_encoding(self.rawValue, oldTree?.rawValue, string, UInt32(string.count), encoding.rawValue) else { return nil }
        return Tree(rawValue: tree)
    }

    /// Instruct the parser to start the next parse from the beginning.
    ///
    /// If the parser previously failed because of a timeout or a cancellation, then
    /// by default, it will resume where it left off on the next call to
    /// `Parser.parse`. If you don't want to resume, and instead intend to use
    /// this parser to parse some other document, call `reset()` first.
    ///
    public func reset () {
        ts_parser_reset(self.rawValue)
    }


    // MARK: - Timeouts

    /// The maximum duration that parsing is allowed to take.
    ///
    /// If parsing takes longer than this value it will finish early and return `nil`.
    ///
    public var timeout: TimeInterval {
        get { TimeInterval(Double(ts_parser_timeout_micros(self.rawValue)) / 1_000_000) }
        set { ts_parser_set_timeout_micros(self.rawValue, UInt64(Double(newValue * 1_000_000))) }
    }


    // MARK: - Cancellation

    private var _isCancelled: Int = 0

    /// Whether or not the parsing should be cancelled.
    public var isCancelled: Bool {
        get { self._isCancelled != 0 }
        set { self._isCancelled = newValue ? 1 : 0}
    }
}


// MARK: - Errors

extension Parser {
    enum Error: Swift.Error {
        case noLanguage
        case languageVersionMismatch (Language)
        case timedout
    }
}
