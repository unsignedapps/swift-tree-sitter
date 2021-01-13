# tree-sitter

[![Build Status](https://travis-ci.org/tree-sitter/tree-sitter.svg?branch=master)](https://travis-ci.org/tree-sitter/tree-sitter)
[![Build status](https://ci.appveyor.com/api/projects/status/vtmbd6i92e97l55w/branch/master?svg=true)](https://ci.appveyor.com/project/maxbrunsfeld/tree-sitter/branch/master)

Tree-sitter is a parser generator tool and an incremental parsing library. It can build a concrete syntax tree for a source file and efficiently update the syntax tree as the source file is edited. Tree-sitter aims to be:

- **General** enough to parse any programming language
- **Fast** enough to parse on every keystroke in a text editor
- **Robust** enough to provide useful results even in the presence of syntax errors
- **Dependency-free** so that the runtime library (which is written in pure C) can be embedded in any application

[Documentation](https://tree-sitter.github.io/tree-sitter/)


## Swift Wrapper

This fork of tree-sitter comes with a minimal Swift Wrapper thats designed to incorporate Swift conventions while staying out of the way of the fast C library underneath.

Documentation is copied from the C library where possible but there are a number of gaps. Consult `lib/include/tree_sitter/api.h` and the C source in `lib/src/` for accurate information on how things work.

### Installation

To include `swift-tree-sitter` in your Swift package add the following dependency to your Package.swift:

```swift
.package(url: "https://github.com/unsignedapps/swift-tree-sitter.git", from: "0.16.5.1")
```

**Note:** The first version that has Swift Package Manager support is 0.16.5.1.

Don't forget to include the library in your target:

```swift
.target(name: "BestExampleApp", dependencies: [ "TreeSitter" ])
```

And import the module in your code:

```swift
import Foundation
import TreeSitter
```

### TODO

This is a partial wrapper. Some things still to be done:

* Unit Tests
* Logging
* DOT graphs

## Links

- [Documentation](https://tree-sitter.github.io)
- [Rust binding](lib/binding_rust/README.md)
- [WASM binding](lib/binding_web/README.md)
- [Command-line interface](cli/README.md)
