# Tokyo Night — less/man colors

# Begin blinking text mode → bold purple
export LESS_TERMCAP_mb=$'\e[1;38;2;187;154;247m'

# Begin bold text mode → bold blue
export LESS_TERMCAP_md=$'\e[1;38;2;122;162;247m'

# End all special formatting
export LESS_TERMCAP_me=$'\e[0m'

# End standout mode
export LESS_TERMCAP_se=$'\e[0m'

# Begin standout mode → search results: dark bg + cyan fg
export LESS_TERMCAP_so=$'\e[1;38;2;125;207;255m\e[48;2;41;45;62m'

# End underline mode
export LESS_TERMCAP_ue=$'\e[0m'

# Begin underline mode → underline + teal
export LESS_TERMCAP_us=$'\e[4;1;38;2;115;218;202m'

# Begin reverse-video mode
export LESS_TERMCAP_mr=$'\e[7m'

# Begin dim/half-bright mode
export LESS_TERMCAP_mh=$'\e[2m'

# Sub/superscript (probably unsupported)
export LESS_TERMCAP_ZN=$'\e[74m'
export LESS_TERMCAP_ZV=$'\e[75m'
export LESS_TERMCAP_ZO=$'\e[73m'
export LESS_TERMCAP_ZW=$'\e[75m'

# Wire man to use less
export MANPAGER='less'
