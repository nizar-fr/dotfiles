html() {

  if [ -z $1 ] && [ -z $2 ]; then
    echo "Usage 'html <Template Name> <Folder Name>' "
    return 1
  fi

  local template_name=$1
  local folder_name=$2
  local full_path=$BASHD/templates/webdev/vanilla/${template_name}
  
  local html_full_path="${full_path}/index.html"
  local css_full_path="${full_path}/style.css"
  local js_full_path="${full_path}/script.js"

  if [[ ! -f "${html_full_path}" || ! -f "${css_full_path}" || ! -f "${js_full_path}" ]]; then
    echo "Template files for '${template_name}' not found in ${full_path}."
    echo "Available template : "
    echo "$(cd $BASHD/templates/webdev/vanilla/ && ls)"
    return 1
  fi

  mkdir "$folder_name" && mkdir "$folder_name/styles" && mkdir "$folder_name/src"
  cp "${html_full_path}" "${folder_name}/index.html"
  cp "${css_full_path}" "${folder_name}/styles/style.css"
  cp "${js_full_path}" "${folder_name}/src/script.js"

  cd "$folder_name" && vim index.html
}
