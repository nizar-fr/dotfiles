# echo " TODO"
# echo " ------"
# echo " Tech Blog - Svelte, Astro"
# echo " Codem - Rust, SQLx, Git2"
# echo " Elegrant - Wordpress"
# echo " The Wire API"
# echo ""

echo ""
echo " TODO"
echo -e "\033[31m"  # red
echo -e " Codem"
echo -e " - Finish 31 October"
echo -e "\033[0m"   # red end
echo -e "\033[33m" # yellow
echo -e " November"
echo -e " - Finish Tech Blog. Be confident with typescript and frontend ecosystems"
echo -e " - Elegrant"
echo -e " - Finish preparing Portfolio for Upwork and other freelance platforms"
echo -e "\033[0m"  # yellow end
echo -e "\033[32m" # green
echo -e " If no job, continue with :"
echo -e " - The Wire API"
echo -e " - Nextstore"
echo -e " - Gruu"
echo -e " MDN"
echo -e "\033[0m" # green end
echo ""

# # Convert markdown above into echo like at the top
# echo "Learning Path"
# echo " Top Priority"
# echo " ------------"
# echo " HTML, CSS, Javascript"
# echo " Git"
# echo " SQL"
# echo " OOP - Design Patterns - System Design"
# echo " Operating System (Linux)"
# echo " Laravel, NestJS, C#."
# echo " AI Prompting and stuff."
# echo ""
# echo " Medium Priority"
# echo " ---------------"
# echo " IT Business"
# echo " Network Programming with Rust."
# echo " Cyber Security."
# echo " Documentation."
# echo " Design"
# echo ""
# echo " Low Priority"
# echo " ------------"
# echo " Math Descrete"
# echo " Computer specs."
# echo " OpenCV"
# echo " Mobile"
# echo ""
# echo " Non IT"
# echo " ------"
# echo " Siapin CV."
# echo " Take Law DEGREE"
# echo " IELTS"
# echo ""

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

