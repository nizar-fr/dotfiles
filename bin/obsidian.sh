pubobd(){
  git clone https://github.com/jackyzha0/quartz.git "$1"
  cd "$1"
  npm i
  npx quartz create
}

HD_PATH=$HDWN

# export NOTEDIR="/media/nizar/HD/Knowledge/computer_science/"
export NOTEDIR="$HD_PATH/note/"
TODODIR="$HD_PATH/personal/todo/"
DAILYDIR="$HD_PATH/personal/daily/"
TOLEARNDIR="$HD_PATH/personal/research/tolearn/"
RESEARCHDIR="$HD_PATH/personal/research/"
BOOKDIR="$NOTEDIR/_book/"
export NVIM_CONFIG_PATH="$HOME/.config/nvim/lua/plugins/obsidian.lua"
export NVIM_CONFIG_PATH="$HD_PATH/assets/backup/astro/config_nvim/lua/plugins/obsidian.lua"

me(){cd "$HD_PATH/personal/" && vim }
wire(){cd "$HD_PATH/personal/Writing/the-wire" && vim}
alias notes="cd $NOTEDIR && ls"
todo(){cd $TODODIR && vim "todo.md"}

today() {
  cd "$DAILYDIR" || { echo "Failed to change directory to $DAILYDIR"; return 1; }
  
  local current_date="$(date +'%Y-%m-%d')"
  local note_file="${current_date}.md"

  if [[ -e "$note_file" ]]; then
    echo "Today's note already exists. Opening..."
  else
    echo "Today's note created."
    touch "$note_file"
  fi

  vim "$note_file"
}

# job(){cd $TODODIR/_job && vim }
# learn(){cd $TOLEARNDIR && vim }
rsch(){cd $RESEARCHDIR && vim }
story(){cd $HD_PATH/projects/story/ && vim }
book(){cd $BOOKDIR && vim }

declare -A tags=(
  [todo/example]=""
  [reread]=""
  [urgent]=""
)

declare -A vaults=(
# [me]="_Me"
[gpt]="_gpt"
[cs]="computer-science"
[cpp]="cpp"
[csh]="csharp"
[dsgn]="design"
[mrkt]="marketing"
[go]="go"
[erlang]="erlang"
[elixir]="elixir"
[js]="ecmascript"
[java]="java"
[jsdoc]="ecma-docs"
[lgl]="legal"
[lua]="lua"
[php]="php"
[py]="python"
[rs]="rust"
[wasm]="web-assembly"
[zig]="zig"
)

declare -A awesome=(
  [android]="https://raw.githubusercontent.com/JStumpp/awesome-android/master/readme.md"
  [angular]="https://raw.githubusercontent.com/PatrickJS/awesome-angular/gh-pages/README.md"
  [blender-python]="https://raw.githubusercontent.com/agmmnn/awesome-blender/master/README.md"
  [cpp]="https://raw.githubusercontent.com/fffaraz/awesome-cpp/master/README.md"
  [csharp]="https://raw.githubusercontent.com/quozd/awesome-dotnet/master/README.md"
  [css]="https://raw.githubusercontent.com/uhub/awesome-css/master/README.md"
  [data-visualization]="https://raw.githubusercontent.com/hal9ai/awesome-dataviz/main/README.md"
  [devops]="https://raw.githubusercontent.com/wmariuss/awesome-devops/main/README.md"
  [docker]="https://raw.githubusercontent.com/veggiemonk/awesome-docker/master/README.md"
  [docker/compose]="https://raw.githubusercontent.com/docker/awesome-compose/master/README.md"
  [go]="https://raw.githubusercontent.com/avelino/awesome-go/main/README.md"
  [html]="https://raw.githubusercontent.com/diegocard/awesome-html5/master/README.md"
  [ecmascript]="https://raw.githubusercontent.com/sorrycc/awesome-javascript/master/README.md"
  [ecmascript/typescript]="https://raw.githubusercontent.com/dzharii/awesome-typescript/master/README.md"
  [jstech/build-tools/vite]="https://raw.githubusercontent.com/vitejs/awesome-vite/refs/heads/master/README.md"
  [kubernetes]="https://raw.githubusercontent.com/tomhuang12/awesome-k8s-resources/main/readme.md"
  [laravel]="https://raw.githubusercontent.com/chiraggude/awesome-laravel/refs/heads/master/README.md"
  [linux]="https://raw.githubusercontent.com/luong-komorebi/Awesome-Linux-Software/master/README.md"
  [security/malware]="https://raw.githubusercontent.com/rshipp/awesome-malware-analysis/refs/heads/main/README.md"
  [network/tunneling]="https://raw.githubusercontent.com/anderspitman/awesome-tunneling/master/README.md"
  [nextjs]="https://raw.githubusercontent.com/unicodeveloper/awesome-nextjs/master/README.md"
  [intelligence]="https://raw.githubusercontent.com/ARPSyndicate/awesome-intelligence/refs/heads/main/README.md"
  [intelligence/osint]="https://raw.githubusercontent.com/jivoi/awesome-osint/refs/heads/master/README.md"
  [php]="https://raw.githubusercontent.com/ziadoz/awesome-php/master/README.md"
  [postgres]="https://raw.githubusercontent.com/dhamaniasad/awesome-postgres/master/README.md"
  [reactjs]="https://raw.githubusercontent.com/enaqx/awesome-react/master/README.md"
  [rust]="https://raw.githubusercontent.com/rust-unofficial/awesome-rust/main/README.md"
  [python]="https://raw.githubusercontent.com/vinta/awesome-python/master/README.md"
  [sec]="https://raw.githubusercontent.com/sbilly/awesome-security/refs/heads/master/README.md"
  [sec/cryptography]="https://raw.githubusercontent.com/sobolevn/awesome-cryptography/refs/heads/master/README.md"
  [sqlite]="https://raw.githubusercontent.com/planetopendata/awesome-sqlite/refs/heads/master/README.md"
  [unity]="https://raw.githubusercontent.com/insthync/awesome-unity3d/master/README.md"
  [zig]="https://raw.githubusercontent.com/zigcc/awesome-zig/main/README.md"
  ["."]="https://raw.githubusercontent.com/sindresorhus/awesome/main/readme.md"
  ["vim"]="https://raw.githubusercontent.com/rockerBOO/awesome-neovim/main/README.md"
)

declare -A tolearns=(
    [tech]="tech"
    [eco]="economy"
    [crime]="criminology"
)

# Making sure all the vaults/folders are created 
for key val in ${(@kv)vaults}; do
  full_path="$NOTEDIR/$val"
  if [ ! -d $full_path ]; then
    mkdir $full_path
  fi
done

obd() {
  local vault="${vaults[$1]}"
  if [[ -n $vault ]]; then
    obs open "$vault" -v "$vault"
    exit
  else
    echo "Vault not found."
    obs
  fi
}
mdn() {
  LVIM_CONFIG_PATH="$HOME/.config/nvim/lua/plugins/obsidian.lua"
  if [[ $1 == "ls" ]]; then
    local max_length=0
    for key value in "${(@kv)vaults}"; do
      echo "$key : $value"
    done | sort -t: -k2,2 
    return 0
  fi

  if [[ $1 == "update" ]]; then
    local lua_config='
local hdd_dir = "'$HD_PATH'"
-- local me_dir = "/_Me/"
local obd_dir = "'$NOTEDIR'"
local todo_dir = "'$TODODIR'"
local book_dir = "'$BOOKDIR'"
-- local tolearn_dir = me_dir .. "/tolearn/"
local research_dir = "'$RESEARCHDIR'"
-- local meet_dir = me_dir .. "/meet/"
local daily_dir = "'$DAILYDIR'"

return {
  "epwalsh/obsidian.nvim",
  version = "*",  
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      { name = "daily" , path= daily_dir },
      -- { name = "meet", path= meet_dir},
      { name = "todo" , path= todo_dir },
      { name = "book" , path= book_dir },
      { name = "research" , path= research_dir },
      -- { name = "tolearn" , path= tolearn_dir },'
      for key val in ${(@kv)vaults}; do
        lua_config+="
      { name = \"$key\",  path = obd_dir .. \"$val\", },"
      done
      lua_config=${lua_config%,}
      lua_config+='
    },
    -- daily_notes = {
    --   folder = me_dir .. "/daily",
    --   date_format = "%Y-%m-%d",
    --   alias_format = "%B %-d, %Y",
    --   -- Optional, default tags to add to each new daily note created.
    --   default_tags = { "daily-notes" },
    --   -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
    -- },
    --   template = nil
    mappings = {
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },
    ui = {
      enable = true,  -- set to false to disable all additional syntax features
      update_debounce = 200,  -- update delay after a text change (in milliseconds)
      max_file_length = 5000,  -- disable UI features for files with more than this many lines
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
      },
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },
    note_frontmatter_func = function(note)
      -- Add the title of the note as an alias.
      if note.title then
        note:add_alias(note.title)
      end
      
      local time_now = os.date("%Y-%m-%dT%H:%M", os.time())
      local out = { 
        id = note.id, 
        title = note.title,
        author = "Nizarudin Fahmi",
        aliases = note.aliases, 
        category = "",
        tags = note.tags, 
        date = time_now, 
        lastmod = "" , 
        references = "",
        type = "note",
        status = "draft",
        model = "",
        summary = "",
        todo = ""
      }
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
            
      out.lastmod = time_now
      return out
    end,

    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      -- vim.fn.jobstart({"open", url})  -- Mac OS
      vim.fn.jobstart({"xdg-open", url})  -- linux
    end,
  },
}'

    # Write the lua configuration to obsidian.lua
    # echo "$lua_config" > obsidian.lua
    echo "$lua_config" > $NVIM_CONFIG_PATH
    echo "Update Success"
  return 0
  fi

  if [[ $1 == "watch" ]]; then
    echo "Starting mdn watch..."
    inotifywait -m -r -e create -e modify -e move -e delete --exclude 'log_mdn.txt' --format '%e %w%f' "$NOTEDIR/" | while read event
    do
        EVENT_TYPE=$(echo $event | awk '{print $1}')
        FILE_PATH=$(echo $event | awk '{print $2}')

        case $EVENT_TYPE in
            CREATE,ISDIR) log_event "CREATE_DIR" "$FILE_PATH" ;;
            CREATE) log_event "CREATE" "$FILE_PATH" ;;
            MODIFY) log_event "MODIFY" "$FILE_PATH" ;;
            MOVED_TO) log_event "MOVED_TO" "$FILE_PATH" ;;
            MOVED_FROM) log_event "MOVED_FROM" "$FILE_PATH" ;;
            DELETE,ISDIR) log_event "DELETE_DIR" "$FILE_PATH" ;;
            DELETE) log_event "DELETE" "$FILE_PATH" ;;
        esac
    done
    return 0
  fi

  if [[ $1 == "backup" ]]; then
    cd $NOTEDIR
    if [[ ! -d ".unused" ]]; then
      mkdir ".unused"
    fi
  fi

  if [[ $1 == "log" ]]; then
    vim "$NOTEDIR/.log/"
  fi

  if [[ $1 == "find" ]]; then
    find $NOTEDIR -name $2
  fi

  if [[ $1 == "open" ]]; then
    return 0
  fi

  if [[ $1 == "dir" ]]; then
    return 0
  fi

  if [[ $1 == "awsm" ]]; then
    for key value in "${(@kv)awesome}"; do
      cd $NOTEDIR/$key
      echo "Fetching $key..."
      curl -o "awesome.md" $value
      cd ..
      echo "Fetching $key completed"
      echo ""
    done
    echo "Update awesome done"
  fi

  if [[ $1 == "tag" ]]; then    
    local max_length=0
    for key value in "${(@kv)tags}"; do
      echo "$key : $value"
    done | sort -t: -k2,2 
    return 0
  fi

  local vault_dir="${vaults[$1]}"
  if [[ -n $vault_dir ]]; then
    cd "$NOTEDIR/$vault_dir" 
    if [[ -e "todo.md" ]]; then
      touch "todo.md"
    fi
    mdn_tree .
    nvim "todo.md" "tree.md" 
    return 0
  else
    cd "$NOTEDIR"
    echo "Vault not found. Goes to directory instead"
    return 1
  fi
}

mdn_tree(){
  if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
  fi

  TARGET_DIR="$1"
  OUTPUT_FILE="tree.md"

  generate_tree() {
    local DIR=$1
    local PREFIX=$2
    local ITEMS
    ITEMS=($(ls -A "$DIR" | grep -v "^\." | sort))
    for ITEM in ${ITEMS[@]}; do
      local FULL_PATH="$DIR/$ITEM"
      if [ -f "$FULL_PATH" ]; then
        # local BASENAME
        # BASENAME=$(basename "$ITEM")
        # echo "${PREFIX}- [[${BASENAME%.*}]]" >> "$OUTPUT_FILE"
          echo "${PREFIX}- $ITEM" >> "$OUTPUT_FILE"  # Just prints the full filename
      fi
      # echo "$FULL_PATH"
    done
    for ITEM in ${ITEMS[@]}; do
      local FULL_PATH="$DIR/$ITEM"
      if [ -d "$FULL_PATH" ]; then
        echo "${PREFIX}- $ITEM" >> "$OUTPUT_FILE"
        generate_tree "$FULL_PATH" "$PREFIX  "
      fi
      # echo "$FULL_PATH"
    done
  }

  echo "# Folder Tree" > "$OUTPUT_FILE"
  # echo >> "$OUTPUT_FILE"

  generate_tree "$TARGET_DIR" ""

  echo "Tree saved to $OUTPUT_FILE"
}

# alias me="mdn $HD_PATH/_Me"


awsm(){
  local vault="${vaults[$1]}"

  if [[ $1 == "update" ]]; then
    for key value in "${(@kv)awesome}"; do
      cd $NOTEDIR/$key
      echo "Fetching $key..."
      curl -o "awesome.md" $value
      cd ..
      echo "Fetching $key completed"
      echo ""
    done
    echo "Update awesome done"
  fi

  if [[ "$1" == "ls" ]]; then
    echo "Available AWESOME Vaults : "
    local max_char=0
    local space=" "
    for awsm_key in "${(@k)awesome}"; do
      if (( ${#${awsm_key}} > max_char )); then
        max_char=${#${awsm_key}}
      fi
    done
    echo "DIRECTORY       COMMAND"
    for awsm_key in "${(@k)awesome}"; do
      for vault_key vault_value in "${(@kv)vaults}"; do
        if [[ $awsm_key == $vault_value ]]; then
          local space_req=$(expr $max_char - ${#${awsm_key}})
          local spaces=""
          for ((i=1; i<=space_req; i++)); do spaces="$spaces " ; done
          echo "$awsm_key $spaces  as    $vault_key"
        fi
      done 
    done
  elif [[ -f "$NOTEDIR/$vault/awesome.md" ]]; then
    cd $NOTEDIR/$vault && vim "awesome.md" 
    echo "Opening Awesome \"${vault}\" "
  else
    echo "Awesome for $vault this mdn is not available"
    return 1
  fi
}

LAST_DATE=""
LAST_TOPIC=""
LAST_EVENT=""
# Used in mdn watch
log_event() {
    local EVENT_TYPE=$1; 
    local FILE_PATH="$2";                             echo "FILE_PATH : $FILE_PATH"
    local DATE=$(date +"%Y_%m_%d_%A"); 
    local DATE_TIME=$(date +"%Y-%m-%d-%A at %H:%M");  echo "DATE : $DATE"
    local REL_PATH=${FILE_PATH#$NOTEDIR/};            echo "REL_PATH: $REL_PATH"
    local TOPIC=$(echo $REL_PATH | cut -d'/' -f1);    echo "TOPIC: $TOPIC"
    local SUB_PATH=$(dirname "$REL_PATH");            echo "SUB_PATH: $SUB_PATH"
    local FILE_NAME=$(basename "$FILE_PATH");         echo "FILE_NAME : $FILE_NAME"
    echo ""

    case $EVENT_TYPE in
        CREATE) EVENT_MSG="CREATED : \"$FILE_NAME\" file in \"$REL_PATH\"." ;;
        MODIFY) EVENT_MSG="MODIFIED : \"$FILE_NAME\" file in \"$REL_PATH\"." ;;
        MOVED_TO) EVENT_MSG="PASTED : \"$FILE_NAME\" file in \"$REL_PATH\"." ;;
        MOVED_FROM) EVENT_MSG="CUT : \"$FILE_NAME\" file in \"$REL_PATH\"." ;;
        DELETE) EVENT_MSG="DELETED : \"$FILE_NAME\" file in \"$REL_PATH\"." ;;
        CREATE_DIR) EVENT_MSG="ADDED : \"$FILE_NAME\" directory in \"$REL_PATH\"." ;;
        DELETE_DIR) EVENT_MSG="DELETED : \"$FILE_NAME\" directory in \"$REL_PATH\"." ;;
        *) return ;;
    esac

    local LOG_FILE="${NOTEDIR}/.log/log_mdn_${DATE}.txt"
    touch $LOG_FILE
    
    # Check for duplicate events
    if [[ "$DATE_TIME" == "$LAST_DATE" && "$TOPIC" == "$LAST_TOPIC" && "$EVENT_MSG" == "$LAST_EVENT" ]]; then
      # empty
    else
        if [[ $TOPIC == ".log" ]]; then
          #empty :
        else
          echo "${DATE_TIME} - ${TOPIC} - ${EVENT_MSG}" >> $LOG_FILE
          LAST_DATE=$DATE_TIME
          LAST_TOPIC=$TOPIC
          LAST_EVENT=$EVENT_MSG
        fi
    fi
}

coba(){

  local DIR=$1
  local PREFIX=$2

  local FILE_PATH="tree.md"

  generate(){
    for item in $(ls); do
      if [ -d "$item" ]; then
        echo " $item"

      fi
    done
    for item in $(ls); do
      if [ -f "$item" ]; then
        echo "FILE: $item"
      fi
    done
  }
}
