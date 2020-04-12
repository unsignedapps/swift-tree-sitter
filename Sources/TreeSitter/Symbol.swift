//
//  Symbol.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import tree_sitter

public struct Symbol {

    // MARK: - Properties

    internal var rawValue: TSSymbol


    // MARK: - Initialisation

    internal init (rawValue: TSSymbol) {
        self.rawValue = rawValue
    }

    public init? (name: String, isNamed: Bool, in language: Language) {
        let symbol = ts_language_symbol_for_name(language.rawValue, name, UInt32(name.count), isNamed)
        guard symbol != 0 else { return nil }
        self.init(rawValue: symbol)
    }


    // MARK: - Naming

    public func name (in language: Language) -> String? {
        guard let name = ts_language_symbol_name(language.rawValue, self.rawValue) else { return nil }
        return String(cString: name)
    }
}

