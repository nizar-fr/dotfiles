# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export QTWEBENGINE_DISABLE_SANDBOX=1
export MSGPACK_PUREPYTHON=1

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quite

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="pixegami-agnoster"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

# All zsh backup put here if used
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme

autoload -Uz compinit
compinit

# Set custom paths
export FLYCTL_INSTALL="/home/nizar/.fly"
export DENO_INSTALL="/home/nizar/.deno"
export PNPM_HOME="/home/nizar/.local/share/pnpm"
export BUN_INSTALL="$HOME/.bun"
export WASMER_DIR="/home/nizar/.wasmer"
export COMPOSER_PATH="/home/nizar/.config/composer/vendor/bin/"


# Append to PATH
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/.local/bin
export PATH="$FLYCTL_INSTALL/bin:$PATH"
export PATH="$(go env GOPATH)/bin:$PATH"
export PATH="$DENO_INSTALL/bin:$PATH"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$PNPM_HOME:$PATH"
export PATH=$BUN_INSTALL/bin:$PATH
export PATH="$WASMER_DIR:$PATH"
export PATH="/home/nizar/.turso:$PATH"
export PATH=$PATH:$COMPOSER_PATH
export PATH="$PATH:/home/nizar/.dotnet/tools"


# Source environment configurations
. "$HOME/.cargo/env"
source /home/nizar/alacritty/extra/completions/alacritty.bash
source ~/.bash_completion/alacritty
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

# Load NVM (Node Version Manager) and its completions
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Interactive shell check
case $- in
    *i*) ;;
    *) return;;
esac

# Terminal multiplexer check
if [ -z "$TMUX" ]; then
    # The TMUX variable is not set, meaning we're not in a tmux session
    # Optionally run neofetch or fastfetch here
fi

# Atuin shell history management
eval "$(atuin init zsh)"

# LS_COLORS is used by GNU ls and Zsh completions. LSCOLORS is used by BSD ls.
export LS_COLORS='fi=00:mi=00:mh=00:ln=01;36:or=01;31:di=01;34:ow=04;01;34:st=34:tw=04;34:'
LS_COLORS+='pi=01;33:so=01;33:do=01;33:bd=01;33:cd=01;33:su=01;35:sg=01;35:ca=01;35:ex=01;32'
export LSCOLORS='ExGxDxDxCxDxDxFxFxexEx'

if (( terminfo[colors] >= 256 )); then
  LS_COLORS+=':no=38;5;248'
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'        # the default is hard to see
else
  LS_COLORS+=':no=1;30'
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=black,bold' # the default is outside of 8-color range
fi

# TREE_COLORS is used by GNU tree. It looks awful with underlined text, so we turn it off.
export TREE_COLORS=${LS_COLORS//04;}

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/home/nizar/.opam/opam-init/init.zsh' ]] || source '/home/nizar/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration


# ln -s /media/nizar/1E064EC0064E9923/Users/Nizar/temp_hd/assets/backup/astro/nvim/ /home/nizar/.config/
export HOMECFG="/home/nizar/.config/"
export HDEX="/media/nizar/HD/"
export HDD="/home/nizar/temp_hd/"
export HDWN="/media/nizar/1E064EC0064E9923/Users/Nizar/temp_hd/"
export HDUSED=~
export HDCODE="$HDUSED/_code"


export CUSTOMBIN=~/dotfiles/bin
local custom_bin_files=($(ls $CUSTOMBIN -p | grep -v /))
for bin_file in ${custom_bin_files}; do
  source $CUSTOMBIN/$bin_file
done

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# bun completions
[ -s "/home/nizar/.bun/_bun" ] && source "/home/nizar/.bun/_bun"
