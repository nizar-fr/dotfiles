# Rustc
alias rsce="rustc --explain "

# Cargo
## Watch
alias crgwr="cargo watch -x run"
alias crgwb="cargo watch -x build"

## Test
alias crgr="cargo run"
alias crgt="cargo test"
# alias crgte="cargo test -- --exact"
alias crgcl="cargo clean"
alias crgfmt="cargo fmt"
alias crgdoc="cargo doc --open"
alias crgrl="cargo release"
alias crga="cargo add"
alias crgrm="cargo remove"
alias crgu="cargo upgrade"
crgn(){
  cargo new $1
  cd $1
  vim src/main.rs
}

crgne() {
  # Check arguments FIRST
  if [ -z "$1" ]; then
    echo "Usage: crgne <project-name>"
    return 1
  fi

  # Create the cargo project
  cargo new "$1"
  cd "$1" || return 1

  # Create the examples directory
  mkdir -p examples

  # Create the example file
  cat > examples/main.rs << EOF
fn main() {
    println!("Running example: $1");
    println!("Example '$1' completed successfully!");
}
EOF

  # Open vim in the project directory
  vim .
}

crgae() {
  if [ -z "$1" ]; then
    echo "Usage: crgae <example-name>"
    return 1
  fi
  
  # Create directory if it doesn't exist
  mkdir -p "examples/$1"
  
  cat > "examples/$1/main.rs" << EOF
fn main() {
    println!("Example for $1");
}
EOF
}

crgre() {
  if [ -z "$1" ]; then
    echo "Usage: crgre <example-name>"
    return 1
  fi
  
  cargo run --example="$1"
}

crgte() {
  if [ -z "$1" ]; then
    echo "Usage: crgte <example-name>"
    return 1
  fi
  
  cargo test --example="$1"
}

crgtpe() {
  if [ -z "$1" ]; then
    echo "Usage: crgtpe <example-name>"
    return 1
  fi
  
  cargo test --example="$1" -- --nocapture
}

alias crgbd="cargo build"
alias crgbb="cargo build && cargo build --release"
alias crgbr="cargo build --release"
