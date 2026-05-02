BACKUP_JSON_FILE_PATH="$:/"
GIT_CLONE_LOG_FILE="$HDCODE/_open/clone_data.csv"

# Local Code Repositories
declare -A code_directory=(
[bk]="/_book"
[m]="/"
[o]="/_open"
[exp]="_experiment"
[tmpt]="_template"
)
declare -A lang_aliases=(
[sh]="bash"
[js]="js"
[react]="react"
[go]="go"
[lua]="lua"
[html]="html"
[rs]="rust"
[py]="py"
[php]="php"
[asm]="assembly"
[lrv]="laravel"
[wp]="wordpress"
[cpp]="cpp"
[csh]="csharp"
[css]="css"
[db]="database"
[angular]="angular"
[game]="game"
[sec]="security"
[unity]="unity"
[_]="other"
)

languages=(
"python" "python3" "perl" "ruby" "node" "php" "java" "javac" "gcc" "g++"
"go" "rustc" "swift" "racket" "ocaml" "ghc" "lua" "julia" "elixir"
"scalac" "fsharp" "clojure" "dart" "kotlin" "nim" "groovy" "haxe" 
"v" "zig" "dmd" "sbcl" "csc" "r" "fortran" "tclsh" "bash" "sh" 
"zsh" "fish" "powershell" "cmd" "awk" "sed" "prolog" "erlang" 
"mlton" "ada" "sml" "scheme" "common-lisp" "coq" "lean" "elm"
"idris" "agda" "crystal" "purescript" "nim" "rexx" "pike"
)

for code_key code_val in ${(@kv)code_directory}; do
  for lang_key lang_val in ${(@kv)lang_aliases}; do
    key_command="${code_key}${lang_key}"
    directory="${HDCODE}/${code_val}/${lang_val}"
    if [ ! -d "$directory" ]; then
      mkdir $directory
    fi
    eval "${key_command}() {
      cd '${directory}' || return
      if [[ -z \$1 ]]; then
        ls
      else
        cd \"\$1\" && vim .
      fi
    }"
    # alias $key_command="cd ${directory} && ls"
  done
done

function show_available_lang(){
  echo "Available language category : "
  for key val in ${(@kv)lang_aliases}; do
    echo "$key as in $val"
  done
}

function show_installed_lang(){
  for lang in "${languages[@]}"; do
    if command -v $lang &> /dev/null; then
      echo "$lang"
    fi
  done
}

alias vscode="/usr/bin/code"

code(){
  local command=$1

  if [[ $1 == "pull" ]]; then
    find "$HDCODE/_open/" -name ".git" -type d | while read gitdir; do
    repo_dir=$(dirname "$gitdir")
    echo "Updating $repo_dir"
    cd "$repo_dir"
    git pull
  done    
  fi

  function check_duplicate_line(){
  }

  if [[ $command == "csv" ]]; then
    # echo "Repository cloned and recorded in $GIT_CLONE_LOG_FILE."
    
    return 0
  fi

  # Please update here gpt.
  if [[ $command == "clone" ]]; then

    local url=""
    if [[ -z $2 ]]; then
      echo "Please provide url"
      echo "Format : code clone <Url> <Category> <Folder Name(optional)> "
      return 1
    else
      url=$2
    fi

    local category=""
    if [[ -z $3 ]]; then
      echo "Please provide category"
      echo "Format : code clone <Url> <Category> <Folder Name(optional)> "
      show_available_lang()
      return 1
    else
      category=$3
    fi

    local folder_name=""
    if [[ -z $4 ]]; then
      folder_name=$(echo "$url" | awk -F'/' '{print $NF}')
      echo "Folder name is not provided. Using the default repository name as the folder name"
    else
      folder_name=$4
      echo "Repository cloned as $folder_name"
    fi

    local path_to_go="$HDCODE/_open/${lang_aliases[$category]}"
    if cd "$path_to_go" 2>/dev/null; then
      echo "Cloning '$url' into '$path_to_go' as '$folder_name'..."
      if git clone "$url" "$path_to_go/$folder_name"; then
        echo "$url,$category,$folder_name" >> "$GIT_CLONE_LOG_FILE"
        echo "Repository cloned and recorded in $GIT_CLONE_LOG_FILE."
      else
        echo "Failed to clone repository. No changes made to $GIT_CLONE_LOG_FILE."
      fi
    else
      echo "Category folder not found: '$path_to_go'."
      echo "Please provide a valid category as listed below:"
      show_available_lang
      return 1
    fi
    return 0
  fi

  if [[ $1 == "ls" ]]; then
    show_available_lang()
    return 0
  fi

  if [[ $1 == "lsi" ]]; then
    show_installed_lang()
    return 0
  fi

  if [[ $1 == "new" ]]; then
    local path_to_go=""
    case $2 in
      "open"|"my"|"exp"|"book")
        local category="$2"
        echo "$2"
        if [[ $category == "my" ]]; then
          category=""
        elif [[ $category == "exp" ]]; then
          category="experiment"
        fi
        path_to_go="$HDCODE/_$category/"
        ;;
      "")
        echo "Please provide a path."
        echo "Available paths: open, my, exp, book."
        return 1
        ;;
      *)
        echo "Path not found."
        echo "Available paths: open, my, exp, book."
        return 1
        ;;
    esac

    if [[ -z $3 ]]; then
      echo "Specify the language. See 'code ls'"
      return 1
    fi 

    if [[ -z $4 ]]; then
      echo "Specify the project name. Example : 'code new exp go crud-golang-app'"
    fi

    cd $path_to_go/$lang_aliases[$3]

    if [[ $3 == "rs" && -n $4 ]]; then
      crgn $4
      return 0
    fi
    if [[ $3 == "go" && -n $4 ]]; then
      gonewt $4
      return 0
    fi
  else
    echo "Available path is : 'open', 'my', 'exp', 'book'"
    echo "Usage: code new path language projectname"
    echo "Example: code new exp rs crud_application_with_rust"
    echo "See available language with 'code ls'"
    return 0
  fi

  if [[ $1 == "open" ]]; then
    if [[ $2 == "open" ||  $2 == "my"  ||  $2 == "exp"  ||  $2 == "book" ]]; then
      local category="$2"
      if [[ $category == "my" ]]; then
        category=""
      elif [[ $category == "exp" ]]; then
        category="experiment"
      fi
      local path_to_go="$HDCODE/_$category/"

      if [[ -z $3 ]]; then
        cd $path_to_go && ls
      else
        local language=$3
        if [[ -z $4 ]]; then
          cd $path_to_go/$lang_aliases[$language] && ls
        else
          cd $path_to_go/$lang_aliases[$language]/$3 && vim .
        fi
      fi
    else
      echo "Category is not found"
      return 0
    fi
  fi

  echo "Please provide any argument"
  echo "Available subcommands"
  echo "csv "
  echo "open"
  echo "new : F"
  echo "ls : Show available programming languages category"
  echo "list : Show installed programming languages"
  return 1
}

hackerrank(){
  cd $HDWN/_code/rust/hackerrank/ && nvim .
}
