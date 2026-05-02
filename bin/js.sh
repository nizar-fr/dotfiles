# Runtime and package manager
## Bun
### bun completion
[ -s "/home/nizar/.bun/_bun" ] && source "/home/nizar/.bun/_bun"
bunvite(){
  bun create vite $1 && cd $1 && bun install 
  if [[ $1 == "run" ]]; then
    bun run dev 
  fi
  vim
}
alias nodemxx="sudo rm -rf node_modules"
alias npmg="npm root -g"
alias pnpmu="pnpm add -g pnpm"
alias pnpmstoreset="pnpm config set store-dir $HDD/.pnpm-store"

# deno
denoinit(){
  if [[ ! -z $1 ]]; then
    local folder_name="$1"
    local template_path="$BASHD/templates/typescript/default/index.ts"
    mkdir $folder_name
    cd $folder_name
    cp "${template_path}" "${$(pwd)/index.ts}"
    nvim index.ts
  else 
    echo "Provide the folder name"
    return 1
  fi
}


# Front End
## Remix
remix(){
  if [[ $1 == "i" ]]; then
    npx create-remix@latest
  fi
}
alias remixn="npx create-remix@latest"

## Angular
### Load Angular CLI autocompletion.
source <(ng completion script)

## Shadcn
alias shadcn="pnpm dlx shadcn@latest"
shadcn-add-all(){
local components
components=($(curl -s "https://ui.shadcn.com/docs/components/accordion" | \
  pup 'div.grid.grid-flow-row.auto-rows-max.gap-0\.5.text-sm a text{}' | \
  sed -n '/Accordion/,/Tooltip/p' | \
  tr '[:upper:]' '[:lower:]' | \
  sed 's/ /-/g' | \
  grep -v -e '^toast$' -e '^combobox$' -e '^data-table$' -e '^date-picker$' ))

pnpm dlx shadcn@latest add "${components[@]}"
}


# Backend
nest_g(){
  local command = $1
  local $args = $2

  if [[ $command = "b" ]]; then
    
  fi
}
