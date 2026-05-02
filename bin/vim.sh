export BACKUP_PATH="$HDWN/assets/backup"

vcf(){

  nvim_open(){
    local dist=$(jq -r '.currentDistribution' $BASHD/config/vim.json) 
    cd "$BACKUP_PATH/$dist/config_nvim" && nvim .
    # cp -r . ~/.config/nvim/
    # echo "Copied to ~/.config/nvim"
  }

  lvim_open(){
    local dist=jq -r '.currentDistribution' $BASHD/config/vim.json  
    cd $HOMECFG/nvim && nvim .
  }

  local config=~/.config/nvim
  local share=~/.local/share/nvim
  local state=~/.local/state/nvim
  local cache=~/.cache/nvim

  if [[ -z $1 ]]; then
    nvim_open
  fi

  if [[ $1 == "open" ]];then
    if [[ -n $2 ]]; then
      cd "$BACKUP_PATH/$2/config_nvim/" && nvim .
    fi
  fi

  if [[ $1 == "clean" ]]; then
    sudo rm -rf $config
    sudo rm -rf $share
    sudo rm -rf $state
    sudo rm -rf $cache
  fi

  if [[ $1 == "backup" ]]; then
    if [[ ! -z $2 ]]; then
      local dist_path="${BACKUP_PATH}/$2"
      cp $config $dist_path/config_nvim
      cp $share $dist_path/share_nvim
      cp $state $dist_path/state_nvim
      cp $cache $dist_path/cache_nvim
    else
      echo "Please provide the distribution name"
    fi                   
  fi

  if [[ $1 == "switch" ]]; then
    
  fi

  if [[ $1 == "copy" ]]; then
    if [[ -n $2  ]]; then
      local dist_path="${BACKUP_PATH}/$2"
      echo $2
      cp $dist_path/config_nvim $config && "Copying config_nvim to $config ..."
      cp $dist_path/share_nvim  $share  && "Copying $2 to $config ..."
      cp $dist_path/state_nvim  $state  && "Copying $2 to $config ..."
      cp $dist_path/cache_nvim  $cache  && "Copying $2 to $config ..."
    else
      echo "Please provide the distribution name"
    fi                   
  fi
}

markview(){
  cd $BACKUP_PATH/astro/config_nvim/
  nvim $BACKUP_PATH/astro/config_nvim/lua/plugins/markview.lua
  cp -r . ~/.config/nvim/
  echo "Copied to ~/.config/nvim"
}

alias lvcf="lvim $HOMECFG/lvim"
vim() {

  if [[ $1 == "log" ]]; then
    nvim ~/.local/state/nvim/
  elif [ -z "$1" ]; then
    echo "Open inside the current directory"
    nvim .
  elif [ -f "$1" ]; then
    echo "Argument is a file, not a directory. Opening file $1"
    nvim "$1"
  else
    echo "Open inside the directory '$1'"
    cd "$1" && nvim .
    # echo "File doesn't exist"
    # return
    # if [ ! -d "$1" ]; then
    #     echo "Directory $1 doesn't exist."
    #     if confirm "Do you want to create the directory '$1'?"; then
    #         mkdir -p "$1"
    #     elif confirm "Cancel operation?"; then
    #         echo "Operation cancelled."
    #         return 1
    #     else
    #         echo "Directory creation aborted."
    #         return 1
    #     fi
    # fi
    # echo "Open inside the directory '$1'"
    # cd "$1" && nvim .
  fi
}



lv(){ 
  if [ -z "$1" ]; then
    echo "Open inside the current directory"
    lvim .
  elif [ -f "$1" ]; then
    echo "Argument is a file, not a directory. Opening file $1"
    lvim "$1"
  else
    echo "Open inside the directory '$1'"
    cd "$1" && lvim .
  fi
}

