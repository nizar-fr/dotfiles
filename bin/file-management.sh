alias rmrf="sudo rm -rf"
dircd(){mkdir "$1" && cd "$1"}

#!/bin/bash

# Function to list files with fzf and preview their content
fzf_preview() {
  find . -type f | fzf --preview 'bat --style=numbers --color=always {} || cat {}' --preview-window=right:70%:wrap
}

# Function to search and open a file with a selected editor
fzf_open() {
  local file
  file=$(find . -type f | fzf --preview 'bat --style=numbers --color=always {} || cat {}')
  if [[ -n "$file" ]]; then
    ${EDITOR:-vim} "$file"
  else
    echo "No file selected."
  fi
}

# Function to search for a directory and cd into it
fzf_cd() {
  local dir
  dir=$(find . -type d | fzf --preview 'ls -la {}')
  if [[ -n "$dir" ]]; then
    cd "$dir" || echo "Failed to cd into $dir"
  else
    echo "No directory selected."
  fi
}

# Function to search and delete a file (use with caution)
fzf_delete() {
  local file
  file=$(find . -type f | fzf --preview 'bat --style=numbers --color=always {} || cat {}')
  if [[ -n "$file" ]]; then
    rm -i "$file"
  else
    echo "No file selected."
  fi
}

# Function to search git files and preview changes (git required)
fzf_git_files() {
  git ls-files | fzf --preview 'git diff --color=always {}' --preview-window=right:70%:wrap
}

# Export functions for usage in current session
# export -f fzf_preview
# export -f fzf_open
# export -f fzf_cd
# export -f fzf_delete
# export -f fzf_git_files

