# SQLite schema inspection aliases
alias sqlite-tables='sqlite3 .tables'
alias sqlite-schema='sqlite3 .schema'
alias sqlite-full-schema='sqlite3 ".schema"'

# Table-specific schema
alias sqlite-table-schema='f(){ sqlite3 ".schema $1"; unset -f f; }; f'

# Detailed table info
alias sqlite-table-info='f(){ sqlite3 "PRAGMA table_info($1)"; unset -f f; }; f'
alias sqlite-table-structure='f(){ sqlite3 ".mode column; PRAGMA table_info($1)"; unset -f f; }; f'

# Index info
alias sqlite-indexes='f(){ sqlite3 "PRAGMA index_list($1)"; unset -f f; }; f'
alias sqlite-index-info='f(){ sqlite3 "PRAGMA index_info($1)"; unset -f f; }; f'

# Complete database overview
alias sqlite-db-info='sqlite3 ".tables; .schema"'

# Formatted schema with line numbers
alias sqlite-pretty-schema='sqlite3 ".schema" | cat -n'

# List all tables with row counts
alias sqlite-table-sizes='f(){ 
    sqlite3 "$1" "SELECT name FROM sqlite_master WHERE type='table';" | while read table; do
        count=$(sqlite3 "$1" "SELECT COUNT(*) FROM \\\"$table\\\";")
        echo "$table: $count rows"
    done
    unset -f f
}; f'

# Export schema to file
alias sqlite-export-schema='f(){ sqlite3 "$1" ".schema" > "${1%.db}_schema.sql"; echo "Schema exported to ${1%.db}_schema.sql"; unset -f f; }; f'

# Ultra-short aliases for power users
alias st='sqlite3 .tables'
alias ss='sqlite3 .schema'
alias si='f(){ sqlite3 "PRAGMA table_info($1)"; unset -f f; }; f'

# alias sq='sqlite3'
