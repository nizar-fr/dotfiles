#! /bin/bash

LOCALWP_CONFIG_DIR="/home/nizar/.config/Local/run"
LOCALWP_CONFIG_FILE="$LOCALWP_CONFIG_DIR/projects.json"

current_active_local_wp_project=""
active_localwp_project_socket_path=""

localwp(){
  local command=$1;
  local arg1=$2;

  local config=$(<"$LOCALWP_CONFIG_FILE")
  local projects=$(echo "$config" | jq -c ".project[]")
  local project_names=$(echo "$localwp_content" | jq -r '.project[].name')

  check_active_localwp(){
    project_ids=($(jq -r '.project[].projectId' "$LOCALWP_CONFIG_FILE"))

    for project_id in "${project_ids[@]}"; do
      echo "Checking projectId: $project_id"

      name=$(jq -r --arg id "$project_id" '.project[] | select(.projectId == $id) | .name' "$LOCALWP_CONFIG_FILE")

      socket="/home/nizar/.config/Local/run/${project_id}/mysql/mysqld.sock"

      mysqlcheck -u root --password="root" -S "$socket" local

      if [ $? -eq 0 ]; then
        echo "✔ mysqlcheck succeeded for $project_id. Project is active."
        echo "Project $name with id: $project_id is active"
        echo "ProjectId is assigned"
        
        current_active_local_wp_project=$project_id
        active_localwp_project_socket_path="$LOCALWP_CONFIG_DIR/${project_id}/mysql/mysqld.sock"
        projectpath=$(echo "$config" | jq -r --arg id "$project_id" '.project[] | select(.projectId == $id).path')
        cd $projectpath

        return 0
      else
        echo "✘ mysqlcheck failed for $project_id ($name). Project is inactive."
      fi
      echo "\033[0;31mNone of the projects is active. Please Start Site in the Local desktop app"
      return 1
    done
  }


  if [[ $command = "init" ]]; then
    export PATH="/home/nizar/.config/Local/lightning-services/mysql-8.0.35+2/bin/linux/bin:$PATH"
    echo "WARNING: Using LocalWP mysql"
    check_active_localwp

  elif [[ $command = "cfg" ]]; then
    if [[ $arg1 = "gen" ]]; then
      generate_localwp_config
    fi
    return 0

  elif [[ $command = "list" ]]; then
    echo "Available projects:"
    echo "$config" | jq -r '.project[] | "Name: \(.name), Id: \(.projectId)"'

  elif [[ $command = "" ]]; then
    echo "Not implemented"

  else 
    wp "$@" --socket=$active_localwp_project_socket_path

  fi


}

generate_localwp_config(){
  projects=()

  for dir in "$LOCALWP_CONFIG_DIR"/*/; do
    dirname=$(basename "${dir%/}")

    if [[ "$dirname" == "router" ]]; then
      continue
    fi

    site_conf="$dir/conf/nginx/site.conf"

    if [[ -f "$site_conf" ]]; then
      root_path=$(grep -oP 'root\s+"\K.*?(?=")' "$site_conf")

      project_name=$(echo "$root_path" | sed -E 's|.*/([^/]+)/app/public|\1|')

      if [[ -n "$root_path" ]]; then
        project_json=$(jq -n \
          --arg id "$dirname" \
          --arg name "$project_name" \
          --arg path "$root_path" \
          '{projectId: $id, name: $name, path: $path}')
                  projects+=("$project_json")
      fi
    fi
  done

  projects_joined=$(IFS=,; echo "${projects[*]}")
  final_json=$(jq -n "{project: [$projects_joined]}")

  echo "$final_json" > "$LOCALWP_CONFIG_FILE"

  echo "JSON file created at $LOCALWP_CONFIG_FILE"
}


