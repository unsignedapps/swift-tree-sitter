//
//  Symbol+Metadata.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import Foundation

extension Symbol {
    public struct Metadata {

        // MARK: - Properties

        public var named: Bool
        public var visible: Bool


        // MARK: - Initialisation

        internal init (named: Bool, visible: Bool) {
            self.named = named
            self.visible = visible
        }
    }
}
