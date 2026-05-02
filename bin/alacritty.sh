ala() {
    CONFIG_FILE="$HOME/.config/alacritty/alacritty.toml"

    # If no arguments are provided, just open the config file in nvim
    if [ $# -eq 0 ]; then
        nvim "$CONFIG_FILE"
        return
    fi

    # Adjust opacity if 'o' argument is provided
    if [ "$1" = "o" ]; then
        if [ -z "$2" ]; then
            echo "Please specify an opacity value between 1 and 10"
            return
        fi
        local opacity="0.${2}"
        if [ "$2" = "10" ]; then
            opacity="1"
        fi

        # Using awk to replace the opacity value in the configuration file
        awk -v opacity="$opacity" '
        /^\[window\]/ {print; in_window_section=1; next}
        in_window_section && /^opacity/ {print "opacity = " opacity; in_window_section=0; next}
        {print}
        ' "$CONFIG_FILE" > tmpfile && mv tmpfile "$CONFIG_FILE"

        echo "Alacritty opacity set to $opacity."
        return
    fi

     # Adjust font size if 'fs' argument is provided
    if [ "$1" = "fs" ]; then
        if [ -z "$2" ]; then
            echo "Please specify a font size."
            return
        fi
        local fontsize="$2"

        # Using awk to replace the font size in the configuration file
        awk -v fontsize="$fontsize" '
        /^\[font\]/ {print; in_font_section=1; next}
        in_font_section && /^size/ {print "size = " fontsize; in_font_section=0; next}
        {print}
        ' "$CONFIG_FILE" > tmpfile && mv tmpfile "$CONFIG_FILE"

        echo "Alacritty font size set to $fontsize."
        return
    fi

    echo "Invalid option. Usage: ala [o opacity_value]"
}
