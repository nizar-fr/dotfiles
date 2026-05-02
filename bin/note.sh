
notes (){
  local vault="${vaults[$1]}"
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

