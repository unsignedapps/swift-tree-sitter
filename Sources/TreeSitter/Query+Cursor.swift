//
//  Query+Cursor.swift
//  TreeSitter: Swift Wrapper for https://github.com/tree-sitter/tree-sitter
//
//  Created by Rob Amos on 12/4/20.
//

import tree_sitter

extension Query {
    public class Cursor {

        // MARK: - Properties

        internal var query: Query
        internal var node: Node
        internal lazy var rawValue: OpaquePointer = {
            let cursor = ts_query_cursor_new()!
            ts_query_cursor_exec(cursor, query.rawValue, node.rawValue)
            return cursor
        }()


        // MARK: - Initialisation

        /// Create a new cursor for executing a given query on the specified node.
        ///
        /// The cursor stores the state that is needed to iteratively search
        /// for matches. The query is lazily executed, so only when you start
        /// working with results.
        ///
        /// There are two options for consuming the results of the query:
        ///
        /// 1. Repeatedly call `nextMatch()` to iterate over all of the
        /// the *matches* in the order that they were found. Each match contains the
        /// index of the pattern that matched, and an array of captures. Because
        /// multiple patterns can match the same set of nodes, one match may contain
        /// captures that appear *before* some of the captures from a previous match.
        ///
        /// 2. Repeatedly call `nextCapture()` to iterate over all of the
        /// individual *captures* in the order that they appear. This is useful if
        /// don't care about which pattern matched, and just want a single ordered
        /// sequence of captures.
        ///
        public init (query: Query, node: Node) {
            self.query = query
            self.node = node
        }

        deinit {
            ts_query_cursor_delete(self.rawValue)
        }


        // MARK: - Adjust Query Execution

        /// Set the range of bytes in which the query will be executed
        public func setRange (_ bytes: ClosedRange<UInt32>) {
            ts_query_cursor_set_byte_range(self.rawValue, bytes.lowerBound, bytes.upperBound)
        }

        /// Set the range of points in which the query will be executed
        public func setRange (_ points: ClosedRange<Point>) {
            ts_query_cursor_set_point_range(self.rawValue, points.lowerBound.rawValue, points.upperBound.rawValue)
        }


        // MARK: - Retrieving Matches and Captures

        /// Advance to the next match of the currently running query.
        /// Returns nil if there are no more matches.
        public func nextMatch () -> Match? {
            var match = TSQueryMatch()
            guard ts_query_cursor_next_match(self.rawValue, &match) == true else { return nil }
            return Match(rawValue: match)
        }

        /// Removes the specified match and assocaited captures
        public func remove (match: Match) {
            ts_query_cursor_remove_match(self.rawValue, match.id)
        }

        /// Advance to the next capture of the currently running query.
        /// Returns nil if there are no more captures.
        public func nextCapture () -> Capture? {
            var match = TSQueryMatch()
            var index: UInt32 = 0
            guard ts_query_cursor_next_capture(self.rawValue, &match, &index) == true else { return nil }

            let buffer = UnsafeBufferPointer(start: match.captures, count: Int(match.capture_count))
            return Capture(rawValue: buffer[Int(index)])
        }
    }
}
