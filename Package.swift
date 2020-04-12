// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TreeSitter",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],

    products: [
        .library(name: "TreeSitter", targets: [ "TreeSitter" ]),
    ],

    dependencies: [],

    targets: [
        // Our Public Swift wrapper that lives in Sources/TreeSitter
        .target(name: "TreeSitter", dependencies: [ "tree_sitter" ]),

        // The original C tree-sitter library that lives in ./lib
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
