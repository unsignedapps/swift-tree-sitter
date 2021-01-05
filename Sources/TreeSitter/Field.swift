//
//  Field.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import tree_sitter

public struct Field {

    // MARK: - Properties

    public var name: String?
    internal var rawValue: TSFieldId


    // MARK: - Initialisation

    internal init (rawValue: TSFieldId, name: String? = nil) {
        self.rawValue = rawValue
        self.name = name
    }

    public init (name: String, in language: Language) {
        self.name = name
        self.rawValue = ts_language_field_id_for_name(language.rawValue, name, UInt32(name.utf8.count))
    }


    // MARK: - Field Names

    public func name (in language: Language) -> String? {
        guard let name = ts_language_field_name_for_id(language.rawValue, self.rawValue) else { return nil }
        return String(cString: name)
    }
}

