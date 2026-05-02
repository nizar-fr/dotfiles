#!/bin/bash
# Directory and File Aliases
## Edit Config aliases
alias s="vim $HOME/.bashrc"
alias sc="code $HOME/.bashrc"
alias vs="vim $HOME/.vimrc"
alias sld="cd /etc/apt/sources.list.d"
alias src="cd $BASHD && ls"
alias zs="vim $HOME/.zshrc"

export VSH_BACKUP_PATH="$HDWN/assets/backup/.bash.d/"

vsh(){
    if [ "$1" = "install" ]; then
        if [ -z "$2" ]; then
            echo "please provide script name to install to"
            return
        else
            cd $BASHD/install/
            chmod +x ./"$2.sh"
            ./"$2.sh" "${@:3}"
            return
        fi
    fi

    if [[ -z  "$1" ]]; then
        cd "$VSH_BACKUP_PATH" && nvim .
        # cp -r . $BASHD
        # echo "Copied configuration from $VSH_BACKUP_PATH to $BASHD" 
        # vim $BASHD
    else
        # cd $BASHD && vim $BASHD/$1.sh
    fi
}

alias vsha="cd $BASHD && vim aliases.sh"
alias vsho="cd $BASHD && vim obsidian.sh"

## Path Aliases
alias cdhd="cd $HDD"
alias cdhdwn="cd $HDWN"
alias music="cd $/Entertainment/Music"


alias mem="du -sh ."
