#include "compiler/build_tables/parse_item.h"
#include "tree_sitter/compiler.h"

namespace tree_sitter {
    using std::string;
    using std::to_string;
    using std::ostream;

    namespace build_tables {
        ParseItem::ParseItem(const rules::Symbol &lhs,
                             const rules::rule_ptr rule,
                             size_t consumed_symbol_count,
                             const rules::Symbol &lookahead_sym) :
            Item(lhs, rule),
            consumed_symbol_count(consumed_symbol_count),
            lookahead_sym(lookahead_sym) {}

        bool ParseItem::operator==(const ParseItem &other) const {
            return
                (other.lhs == lhs) &&
                (other.consumed_symbol_count == consumed_symbol_count) &&
                (other.lookahead_sym == lookahead_sym) &&
                (other.rule == rule || other.rule->operator==(*rule));
        }

        ostream& operator<<(ostream &stream, const ParseItem &item) {
            return stream <<
            string("#<item ") <<
            item.lhs <<
            string(" ") <<
            *item.rule <<
            string(" ") <<
            to_string(item.consumed_symbol_count) <<
            string(" ") <<
            item.lookahead_sym <<
            string(">");
        }
    }
}
