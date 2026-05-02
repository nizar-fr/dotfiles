
update(){
  sudo apt update
}

alias upgrade="sudo apt upgrade -y"
alias upgrate="sudo apt update && sudo apt upgrade -y"
alias e="nemo ."

# SCREEN ROTATION
declare -A scrn_rot=( [xa]="left" [xw]="normal" [xd]="right" [xs]="inverted" )

for key val in ${(@kv)scrn_rot}; do
  alias $key="xrandr --output eDP-1-1 --rotate ${val}"
done

alias fs="wmctrl -r ':ACTIVE:' -b toggle,fullscreen"
alias envo="env -0 | sort -z | tr '\0' '\n'"
alias nport="sudo lsof -i -P -n | grep LISTEN"
alias ll="ls -l"
exe(){
  chmod -x $1
}

# CSV
csvview(){ 
  column -s, -t < $1 | less -#2 -N -S
}

# Copy to Clipboard
xcp(){
  output=$(cat)  
  echo "$output" | xclip -selection clipboard
  echo "$output value copied to the clipboard"
}

# DISK
logdisk(){
  local folder=$1
  local log_root="$HOME/logdisk"
  local current_date="$(date +'%Y-%m-%d')"
  local date_dir="$log_root/$current_date"
  
if [[ ! -d $date_dir ]]; then
    mkdir -p "$target_dir"
    echo "folder is created"
  fi

  if [[ ! -d $folder ]]; then
    echo "Folder doesn't exists. Aborted"
    return 1
  fi
  echo "Logging disk usage for $folder..."
  cd $folder
  local fullpath_folder_name="$(pwd | sed 's/^\///; s/\//-/g')"
  local target_log="$date_dir/$fullpath_folder_name.csv"
  du -sk * | sort -n | awk '{print $2 "," $1" KB"}'
  du -sk * | sort -n | awk '{print $2 "," $1}' > "$target_log"
  local total=$(du -sk | awk '{print "total," $1" KB"}')
  echo "total,$total"
  echo "total,$total" >> "$target_log"
  echo "Disk usage log created at $target_log"
}

# Directory
cs(){
  cd $1 && ls
}

mkcd(){
  mkdir $1 && cd $1
}

mkfile() { 
  mkdir -p $( dirname "$1") && touch "$1" 
}
alias b="cd .. && ls"

# Swap utility
swpf(){
  sudo swapoff -a
}
swpn(){
  sudo swapon -a
}

r1920(){
  gtf 1920 1080 60
  xrandr --newmode "1920x1080_60.00"  172.80  1920 2040 2248 2576  1080 1081 1084 1118  -HSync +Vsync
  xrandr --addmode DP-1-1 "1920x1080_60.00"
  xrandr --output DP-1-1 --mode "1920x1080_60.00"
}

# Move 
mvb() {
    local src="$1"
    local dest="$2"
    local backup_root="${3:-$HOME/mvbackup}"

    # 1. Validate source
    if [[ ! -e "$src" ]]; then
        echo "Error: Source '$src' does not exist."
        return 1
    fi

    # 2. Get the absolute path and remove the leading /
    # This allows us to join it to the backup_root safely
    local full_path=$(realpath "$src")
    local relative_path="${full_path#/}"
    local backup_path="${backup_root%/}/${relative_path}"

    # 3. Create the parent directory structure in backup_root
    mkdir -p "$(dirname "$backup_path")"

    echo "Mirroring path to backup: $backup_path"

    # 4. Copy to backup, then move to destination
    if cp -a "$src" "$backup_path"; then
        echo "Moving to: $dest"
        # Ensure destination parent exists
        mkdir -p "$(dirname "$dest")"
        mv "$src" "$dest"
    else
        echo "Backup failed. Operation aborted."
        return 1
    fi
}
