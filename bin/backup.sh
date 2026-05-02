zshconvert(){
  cd $BASHD
  local foldername="zshver"
  mkdir -p "$foldername"
  ls *.sh | while read -r file; do
    # echo "$file"
    cp "$file" "$foldername/${file%.sh}.zsh"
  done
}

zshmove(){
  cd $BASHD/zshver
  cp -r * ~/.oh-my-zsh/custom/
}

dotbck(){
  
  push(){
    local path_to_backup="$1"
    cd $path_to_backup
    if [[ ! -d ".git" ]]; then
      echo "The directory is not a git repository"
      return 1;
    fi
    git add *
    git commit -m "Update"
    git push origin main
    git push origin master
  }
 
  push "$HDWN/assets/backup/astro/config_nvim/"
  push "$HDWN/assets/backup/.bash.d"
}
