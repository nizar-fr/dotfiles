# Customize LS_COLORS
# export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"
export LS_COLORS=":ow=1;34:tw=1;34:"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}# LS_COLORS is used by GNU ls and Zsh completions. LSCOLORS is used by BSD ls.

# export LS_COLORS='fi=00:mi=00:mh=00:ln=01;36:or=01;31:di=01;34:ow=04;01;34:st=34:tw=04;34:'
# LS_COLORS+='pi=01;33:so=01;33:do=01;33:bd=01;33:cd=01;33:su=01;35:sg=01;35:ca=01;35:ex=01;32'
# export LSCOLORS='ExGxDxDxCxDxDxFxFxexEx'
#
# if (( terminfo[colors] >= 256 )); then
#   LS_COLORS+=':no=38;5;248'
#   ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'        # the default is hard to see
# else
#   LS_COLORS+=':no=1;30'
#   ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=black,bold' # the default is outside of 8-color range
# fi
#
# # TREE_COLORS is used by GNU tree. It looks awful with underlined text, so we turn it off.
# export TREE_COLORS=${LS_COLORS//04;}

# TokyoNight Color Palette
# Background
# Background and Foreground
typeset -g POWERLEVEL9K_BACKGROUND=53
typeset -g POWERLEVEL9K_FOREGROUND=231

# Time
typeset -g POWERLEVEL9K_TIME_FOREGROUND=15 # light sky blue

# Directory
typeset -g POWERLEVEL9K_DIR_FOREGROUND=15  # sky blue
typeset -g POWERLEVEL9K_DIR_WRITABLE_FOREGROUND=15
typeset -g POWERLEVEL9K_DIR_HOME_FOREGROUND=15
typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=15
typeset -g POWERLEVEL9K_DIR_ETC_FOREGROUND=15
typeset -g POWERLEVEL9K_DIR_DEFAULT_FOREGROUND=15

# User
typeset -g POWERLEVEL9K_USER_FOREGROUND=114 # pale green
typeset -g POWERLEVEL9K_USER_ROOT_FOREGROUND=160 # red

# VCS (Git)
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=0 # pale green
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=0 # light goldenrod
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=0
typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND=0 # red

# Command Execution Time
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=208 # dark orange

# Status
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=114 # pale green
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=15 red

# Host
typeset -g POWERLEVEL9K_HOST_FOREGROUND=75  # sky blue
typeset -g POWERLEVEL9K_HOST_REMOTE_FOREGROUND=75

# Background Colors for Segments
typeset -g POWERLEVEL9K_TIME_BACKGROUND=61
typeset -g POWERLEVEL9K_DIR_BACKGROUND=93
typeset -g POWERLEVEL9K_USER_BACKGROUND=0
typeset -g POWERLEVEL9K_VCS_BACKGROUND=15
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=0
typeset -g POWERLEVEL9K_STATUS_BACKGROUND=0
typeset -g POWERLEVEL9K_HOST_BACKGROUND=0

# Define color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
