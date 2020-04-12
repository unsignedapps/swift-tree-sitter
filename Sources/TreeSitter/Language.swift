//
//  Language.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import tree_sitter

public struct Language {

    // MARK: - Properties

    internal var rawValue: UnsafePointer<TSLanguage>


    // MARK: - Initialisation

    internal init (rawValue: UnsafePointer<TSLanguage>) {
        self.rawValue = rawValue
    }


    // MARK: - Language Information

    public var symbolCount: Int {
        return Int(ts_language_symbol_count(self.rawValue))
    }

    public var fieldCount: Int {
        return Int(ts_language_field_count(self.rawValue))
    }

    public var version: UInt32 {
        return ts_language_version(self.rawValue)
    }
}
