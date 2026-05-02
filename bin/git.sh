alias clone="git clone"
alias add="git add"
alias commit="git commit"
alias pull="git pull"

gh() {
    local command=$1
    local args1=$2
    if [[ "$1" == "change" ]]; then
        CONFIG_FILE="$HOME/.config/gh/hosts.yml"
        if [[ -z "$2" ]]; then
            echo "You need to provide the account. List is here:"
            grep -oP '^\s+[\w-]+:' "$CONFIG_FILE" | sed 's/://g' | grep -vE '^(users|user)$'
            return 1
        fi

        ACCOUNT="$2"
        if grep -qP "^\s+$ACCOUNT:" "$CONFIG_FILE"; then
            # Use sed to replace the 'user: <account>' field
            sed -i "s/^\s*user:.*/    user: $ACCOUNT/" "$CONFIG_FILE"
            echo "Switched to account: $ACCOUNT"
        else
            echo "Account '$ACCOUNT' not found in the list. Check the accounts listed below:"
            grep -oP '^\s+[\w-]+:' "$CONFIG_FILE" | sed 's/://g' | grep -vE '^(users|user)$'
            return 1
        fi

    elif [[ $command = "size" ]];then
        curl -sS $args1 | jq '.size'
    else
        command gh "$@"
    fi
}

pass_backup(){
    pass git add .
    pass git commit -m "new"
    pass git push origin main
}

gacp(){
    if [[ -z "$1" ]]; then
        echo "Please provide a commit message."
        return 1
    fi
    git add . 
    git commit -m $1
    git push origin main
}
