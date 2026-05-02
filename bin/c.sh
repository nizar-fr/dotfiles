gccrun() {
    if [ -z "$1" ]; then
        echo "Usage: gccrun <filename without extension>"
        return 1
    fi
    
    local src_file="$1.c"
    local out_file="$1.o"
    
    # Check if source file exists
    if [ ! -f "$src_file" ]; then
        echo "Error: $src_file not found"
        return 1
    fi
    
    # Compile with common warnings enabled
    if gcc -Wall -Wextra -std=c11 "$src_file" -o "$out_file"; then
        echo "Running $out_file:"
        ./"$out_file" "$@"
    else
        echo "Compilation failed"
        return 1
    fi
}

gpprun() {
    if [ -z "$1" ]; then
        echo "Usage: gpprun <filename without extension>"
        return 1
    fi
    
    local src_file="$1.cpp"
    local out_file="$1.o"
    
    if [ ! -f "$src_file" ]; then
        echo "Error: $src_file not found"
        return 1
    fi
    
    # Compile with C++17 standard and common warnings
    if g++ -Wall -Wextra -std=c++17 "$src_file" -o "$out_file"; then
        echo "Running $out_file:"
        ./"$out_file" "$@" 
    else
        echo "Compilation failed"
        return 1
    fi
}
