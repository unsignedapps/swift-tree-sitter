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

    /// You shouldn't ever directly need to initialise `Language`, but
    /// just in case you're pulling in your own library definitions, this is here.
    ///
    public init (rawValue: UnsafePointer<TSLanguage>) {
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


// MARK: - Equatable Conformance

extension Language: Equatable {
    public static func == (lhs: Language, rhs: Language) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
