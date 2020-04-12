// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-tree-sitter",
    products: [
        .library(name: "swift-tree-sitter", targets: [ "tree_sitter" ]),
    ],
    dependencies: [
    ],
    targets: [
        .target (
            name: "tree_sitter",
            path: "lib",
            sources: [ "src/lib.c" ],
            publicHeadersPath: "include/tree_sitter",
            cSettings: [
                .headerSearchPath("include"),
                .headerSearchPath("src")
            ]
        )
    ],

    cLanguageStandard: .gnu99
)
