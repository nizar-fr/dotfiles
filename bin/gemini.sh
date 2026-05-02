declare -A gemini_api=(
  [design]="AIzaSyBCCgSWKytIFol6290o9dfKwsfhTjOWKms"
  [design-2]="AIzaSyDf1Ddy9pnxm35eggn5qZgItRYMMQzh46c"
  [tech]="AIzaSyAmPwFyypmfNcJu24PJT4Lrs3-0a7ICg3Y"
  [tech-old]="AIzaSyA9_B_bDaHCzgocqTK92nWGxEATDcZdCCA"
  [tech-2]="AIzaSyBKdFtC-Q5MAOTO4xBFTgvAtM87HSP4bxQ"
  [tech-3]="AIzaSyAu8cWLma1rEGLd8L04nzCa_-yjUham4dw"
  [tech-4]="AIzaSyAGUaYd8SwwdxkkBd6RUZfweHdRzpr074g"
  [tech-5]="AIzaSyCrTut-GGAPpj10GQADzgBA1GTaEUle7v0"
  [tech-new]="AIzaSyA-2lk54LGXarYEIJlydQiQ1ZOG4_9XZ58"
)

gem(){
  local command=$1
  local subcommand=$2
  local config_file="$HOME/.config/gemini/gemini-api"
  
  # Create config directory if it doesn't exist
  mkdir -p "$(dirname "$config_file")"
  
  # LIST command
  if [[ $command = "list" ]]; then
    local max_key_length=0
    # Find the maximum key length for formatting
    for key in "${(@k)gemini_api}"; do
      if (( ${#key} > max_key_length )); then
        max_key_length=${#key}
      fi
    done
    
    printf "%-${max_key_length}s : %s\n" "KEY" "API KEY"
    for key in "${(@k)gemini_api}"; do
      printf "%-${max_key_length}s : %s\n" "$key" "${gemini_api[$key]}"
    done | sort
    return 0

  # USE command
  elif [[ $command = "use" ]]; then
    local key_name=$2
    if [[ -z $key_name ]]; then
      echo "Please specify a key to use. Available keys: ${(kj:, :)gemini_api}"
      return 1
    fi

    if [[ -n "${gemini_api[$key_name]}" ]]; then
      # Write to config file
      echo "export GEMINI_API_KEY=${gemini_api[$key_name]}" > "$config_file"
      source "$config_file"
      echo "Persistent GEMINI_API_KEY set to '$key_name' key"
    else
      echo "Invalid key '$key_name'. Available keys: ${(kj:, :)gemini_api}"
      return 1
    fi

  # TEST command
  elif [[ $command = "test" ]]; then
    local api_key=""
    local test_key=""
    
    # Determine which key to test
    if [[ $subcommand = "all" ]]; then
      for key in "${(@k)gemini_api}"; do
        echo "=== Testing $key ==="
        gem test "$key"
        echo ""
      done
      return 0
    elif [[ -n "$subcommand" ]]; then
      # Test specific key
      if [[ -n "${gemini_api[$subcommand]}" ]]; then
        api_key="${gemini_api[$subcommand]}"
        test_key="$subcommand"
      else
        echo "Invalid key '$subcommand'. Available keys: ${(kj:, :)gemini_api}"
        return 1
      fi
    else
      # Test current key
      if [[ -n "$GEMINI_API_KEY" ]]; then
        api_key="$GEMINI_API_KEY"
        test_key="current"
      else
        echo "No API key set. Use 'gemini use <key>' first or specify a key: 'gemini test <key>'"
        return 1
      fi
    fi

    echo "Testing $test_key API key..."
    
    local response=$(curl -s -w "%{http_code}" "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent" \
      -H 'Content-Type: application/json' \
      -H "X-goog-api-key: $api_key" \
      -X POST \
      -d '{
        "contents": [
          {
            "parts": [
              {
                "text": "Say hello in one word"
              }
            ]
          }
        ]
      }' 2>/dev/null)
    
    # Separate HTTP status code from response body
    local http_code="${response: -3}"
    local response_body="${response:0:-3}"
    
    if [[ $http_code -eq 429 ]] || [[ $response_body == *"RESOURCE_EXHAUSTED"* ]]; then
      echo -e "\033[0;31mAPI Quota Exhausted\033[0m"
      echo "You've exceeded your daily free quota (200 requests)."
      echo "Details: https://ai.google.dev/gemini-api/docs/rate-limits"
      return 1
    elif [[ $http_code -eq 200 ]] && [[ $response_body == *"candidates"* ]]; then
      echo -e "\033[0;32mAPI Working Normally\033[0m"
      # Extract and display the response text if jq is available
      if command -v jq &>/dev/null; then
        local answer=$(echo "$response_body" | jq -r '.candidates[0].content.parts[0].text' 2>/dev/null)
        if [[ -n "$answer" ]]; then
          echo "Response: $answer"
        fi
      fi
      return 0
    elif [[ $http_code -eq 400 ]] && [[ $response_body == *"API key not valid"* ]]; then
      echo -e "\033[0;31mInvalid API Key\033[0m"
      return 1
    elif [[ $http_code -eq 403 ]]; then
      echo -e "\033[0;31mPermission Denied\033[0m"
      echo "The API key may be restricted or invalid."
      return 1
    else
      echo -e "\033[0;31mUnknown API Error (HTTP $http_code)\033[0m"
      echo "Response: $response_body"
      return 1
    fi

  # HELP command or invalid command
  else
    echo "Usage:"
    echo "  gemini use <key>      - Set active API key"
    echo "  gemini list           - List all available API keys"
    echo "  gemini test           - Test API with current key"
    echo "  gemini test <key>     - Test API with specified key"
    echo "  gemini test all       - Test all available API keys"
    return 1
  fi
}

# Load API key from config file at shell startup
config_file="$HOME/.config/gemini/gemini-api"
if [[ -f "$config_file" ]]; then
  source "$config_file"
fi
