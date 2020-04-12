//
//  Symbol+Type.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import tree_sitter

extension Symbol {
    public enum SymbolType {

        // MARK: - Cases

        case regular
        case anonymous
        case auxiliary

    }
}


// MARK: - Interoperability

internal extension Symbol.SymbolType {

    var rawValue: TSSymbolType {
        switch self {
        case .regular:      return TSSymbolTypeRegular
        case .anonymous:    return TSSymbolTypeAnonymous
        case .auxiliary:    return TSSymbolTypeAuxiliary
        }
    }

    init? (rawValue: TSSymbolType) {
        switch rawValue {
        case TSSymbolTypeRegular:   self = .regular
        case TSSymbolTypeAnonymous: self = .anonymous
        case TSSymbolTypeAuxiliary: self = .auxiliary
        default:                    return nil
        }
    }
}


