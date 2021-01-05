//
//  InputEncoding.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import tree_sitter

public enum InputEncoding {

    // MARK: - Cases

    case utf8
    case utf16

}


// MARK: - Interoperability

internal extension InputEncoding {

    var rawValue: TSInputEncoding {
        switch self {
        case .utf8:     return TSInputEncodingUTF8
        case .utf16:    return TSInputEncodingUTF16
        }
    }

    init? (rawValue: TSInputEncoding) {
        switch rawValue {
        case TSInputEncodingUTF8:   self = .utf8
        case TSInputEncodingUTF16:  self = .utf16
        default:                    return nil
        }
    }
}



