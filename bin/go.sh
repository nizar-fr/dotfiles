GO_MAIN_FILE="package main

func main(){

}"

go(){
    if [[ $1 == "extra" ]]; then
        echo "Extra command lists by https://github.com/nizar-fr"
        echo ""
        echo "Basic"
        echo "goi   - go init"
        echo "gont  - New project with nzrtech account"
        echo "gon   - New project with nizar-fr account"
        echo "gor   - Go run main.go"
        echo ""
        echo "With Examples - (This adds Makefile)"
        echo "gone  - New project with Examples (in nzrtech account)"
        echo "goae  - Go add an example. Require Makefile exists"
        echo "gove  - Go validate. Re-initiate project with examples added."
        echo ""
        echo "With Examples and Watch - (Makefile with air as watcher)"
        echo "gonew - New project with Examples (in nzrtech account)"
        echo "goaew - Go add an example. Require Makefile exists"
        echo "govew - Go validate. Re-initiate project with examples added."
        echo "gosw  - Switch from watcher to simple." 
        return 0
    fi
    command go "$@"
}

# Basic Commands
goi(){ # Go init
    go mod init github.com/nizarfr/$1
}
gont(){ # Go new project
  mkdir $1
  cd $1
  go mod init github.com/nzrtech/$1
  touch main.go
  echo "package main

func main(){
  
}
  " > main.go
  vim main.go
}

gon(){ # Go new main account
  mkdir $1
  cd $1
  go mod init github.com/nizar-fr/$1
  touch main.go
  echo "package main

func main(){
  
}
  " > main.go
  vim main.go
}

gor(){ # Go run main.go
  go run main.go "$@"
}
goty(){
    go mod tidy 
}

# Go with Examples (Following rust convention)
_basic_example_makefile() {
    echo "Initiate simple makefile..."
    cat << 'EOF'
EXAMPLES = $(shell ls examples)

.PHONY: all $(EXAMPLES) help

all:
	@echo "Available examples: $(EXAMPLES)"

$(EXAMPLES):
	@echo "==> Running example: $@"
	@go run ./examples/$@/main.go

help:
	@echo "Usage: make <example_name>"
	@echo "Available targets: $(EXAMPLES)"
EOF
}

gone() {
    if [[ -z $1 ]]; then
        echo "Usage: gone <project_name>"
        return 1
    fi

    gont "$1"
    cd "$1"

    mkdir -p "examples/main"
    _basic_example_makefile > Makefile
    
    goae "main"
    echo "Project $1 ready with simple-run examples."
}

goae() { # Go add experiment
    local EX_NAME=$1
    if [[ -z $EX_NAME ]]; then
        echo "Usage: goae <example_name>"
        return 1
    fi

    if [[ ! -f Makefile ]]; then
        echo "Error: Makefile not found."
        return 1
    fi

    mkdir -p "examples/$EX_NAME"
    
    local TARGET="examples/$EX_NAME/main.go"
    if [[ ! -f "$TARGET" ]]; then
        cat <<EOF > "$TARGET"
package main

import "fmt"

func main() {
	fmt.Println("🚀 Executing: $EX_NAME")
}
EOF
    fi

    echo "Example '$EX_NAME' created. Run with: make $EX_NAME"
}

gove() {
    echo "Syncing project structure..."
    [[ ! -d "examples/main" ]] && mkdir -p "examples/main"
    _basic_example_makefile > Makefile
    if [[ ! -f "examples/main/main.go" ]]; then
        goae "main"
    fi
    echo "Done. 'make <tab>' will now show all examples."
}

_watch_example_makefile() {
    echo "Initiate golang Makefile with watcher"
    cat << 'EOF'
EXAMPLES = $(shell ls examples)

.PHONY: all $(EXAMPLES) help

all:
	@echo "Available examples: $(EXAMPLES)"

$(EXAMPLES):
	@echo "==> Running example: $@"
	@go run ./examples/$@/main.go

help:
	@echo "Usage: make <example_name>"
	@echo "Available targets: $(EXAMPLES)"
EOF
}

gonew() {
    if [[ -z $1 ]]; then
        echo "Usage: gone <project_name>"
        return 1
    fi

    # Assuming 'gont' is your custom go-new-template command
    gont $1 
    
    # Initialize directory structure first
    mkdir -p "examples/main"
    
    # Create the dynamic Makefile
    _watch_example_makefile > Makefile
    
    # Create the first example
    goae "main"
    echo "Project $1 initialized with Rust-style examples."
}

goaew() {
    local EX_NAME=$1
    if [[ -z $EX_NAME ]]; then
        echo "Usage: goae <example_name>"
        return 1
    fi

    if [[ ! -f Makefile ]]; then
        echo "Error: Not in a 'gone' project (Makefile missing)."
        return 1
    fi

    mkdir -p "examples/$EX_NAME"
    
    local TARGET="examples/$EX_NAME/main.go"
    if [[ ! -f "$TARGET" ]]; then
        cat <<EOF > "$TARGET"
package main

import "fmt"

func main() {
	fmt.Println("Running example: $EX_NAME")
}
EOF
    fi

    echo "Example '$EX_NAME' ready. Run with: make $EX_NAME"
}

govew() {
    echo "Validating project structure..."
    
    [[ ! -d "examples/main" ]] && mkdir -p "examples/main"
    
    # Refresh Makefile using the central template
    _watch_example_makefile > Makefile
    
    # Ensure at least one example exists
    if [[ ! -f "examples/main/main.go" ]]; then
        goae "main"
    fi

    echo "Validation complete. Makefile synchronized with examples/ directory."
}

gosw() { # Go Switch
    local MODE=$1

    if [[ ! -d "examples" ]]; then
        echo "Error: 'examples' directory not found. Are you in a 'gone' project?"
        return 1
    fi

    case $MODE in
        simple)
            _watch_example_makefile > Makefile
            echo "Switched to SIMPLE mode (direct execution)."
            ;;
        watch)
            _gone_template_watch > Makefile
            echo "Switched to WATCH mode (using air)."
            ;;
        *)
            echo "Usage: gosw [simple|watch]"
            return 1
            ;;
    esac
}

export GOPATH=~/go
export GOMODCACHE=~/go/pkg/mod
export GOCACHE=~/go/cache
export GOBIN="$GOPATH/bin"
export PATH=$PATH:$GOPATH/bin
declare -A go_packages=(

    # System
    [gopsutil]="github.com/shirou/gopsutil/v4"
  
    # Web frameworks
    [echo]="github.com/labstack/echo/v4"
    [gin]="github.com/gin-gonic/gin"
    [fiber]="github.com/gofiber/fiber/v2"
    [chi]="github.com/go-chi/chi/v5"
    [mux]="github.com/gorilla/mux"

    # Database packages
    [gorm]="github.com/jinzhu/gorm"
    [sqlx]="github.com/jmoiron/sqlx"
    [pq]="github.com/lib/pq"
    [mysql]="github.com/go-sql-driver/mysql"
    [pgx]="github.com/jackc/pgx/v4"
    [redis]="github.com/go-redis/redis/v8"
    [sqlite]="github.com/mattn/go-sqlite3"
    [supabase]="github.com/supabase-community/supabase-go"

    # WebSocket
    [websocket]="github.com/gorilla/websocket"
    [nhooyr_websocket]="nhooyr.io/websocket"

    # Containerization
    [docker-client]="github.com/docker/docker/client"
    [docker-types]="github.com/docker/docker/api/types"
    [docker-container]="github.com/docker/docker/api/types/container"
    [docker-network]="github.com/docker/docker/api/types/network"
    [docker-strslice]="github.com/docker/docker/api/types/strslice"

    # Environment & configuration
    [godotenv]="github.com/joho/godotenv"
    [viper]="github.com/spf13/viper"
    [envconfig]="github.com/kelseyhightower/envconfig"

    # UUID generation
    [uuid]="github.com/google/uuid"

    # HTTP clients and servers
    [fasthttp]="github.com/valyala/fasthttp"
    [httpclient]="github.com/ddo/httpclient"
    [resty]="github.com/go-resty/resty/v2"
    [colly]="github.com/gocolly/colly/v2"

    # Logging
    [logrus]="github.com/sirupsen/logrus"
    [zap]="go.uber.org/zap"
    [zerolog]="github.com/rs/zerolog"

    # Testing
    [testify]="github.com/stretchr/testify"
    [gomega]="github.com/onsi/gomega"
    [ginkgo]="github.com/onsi/ginkgo/v2"
    [httpexpect]="github.com/gavv/httpexpect/v2"
    [go-sqlmock]="github.com/DATA-DOG/go-sqlmock"

    # Utilities
    [cobra]="github.com/spf13/cobra"
    [cli]="github.com/urfave/cli/v2"
    [pprof]="github.com/google/pprof"
    [graceful]="github.com/tylerb/graceful"
    [robotgo]="github.com/go-vgo/robotgo"

    # Validation
    [validator]="github.com/go-playground/validator/v10"
    [ozzo-validation]="github.com/go-ozzo/ozzo-validation/v4"

    # JSON manipulation
    [jsoniter]="github.com/json-iterator/go"
    [gojq]="github.com/itchyny/gojq"
    [easyjson]="github.com/mailru/easyjson"

    # JWT handling
    [jwt]="github.com/golang-jwt/jwt/v5"

    # Message queues
    [kafka]="github.com/confluentinc/confluent-kafka-go/kafka"
    [nats]="github.com/nats-io/nats.go"
    [rabbitmq]="github.com/streadway/amqp"

    # Task scheduling
    [cron]="github.com/robfig/cron/v3"
    [go-workers]="github.com/jrallison/go-workers"

    # Miscellaneous utilities
    [gomock]="github.com/golang/mock/gomock"
    [goquery]="github.com/PuerkitoBio/goquery"
    [gopacket]="github.com/google/gopacket"
    [ffjson]="github.com/pquerna/ffjson/ffjson"
    [go-socks5]="github.com/armon/go-socks5"

    # File handling
    [afero]="github.com/spf13/afero"
    [go-fsnotify]="github.com/fsnotify/fsnotify"

    # Data serialization
    [msgpack]="github.com/vmihailenco/msgpack/v5"
    [protobuf]="google.golang.org/protobuf"
    [yaml]="gopkg.in/yaml.v3"

    # Rate limiting & throttling
    [ratelimit]="go.uber.org/ratelimit"
    [go-rate]="github.com/beefsack/go-rate"

    [gofeed]="github.com/mmcdole/gofeed"
)

# Function to handle shorthand names
goget() {
    for pkg in "$@"
    do
        if [[ -n "${go_packages[$pkg]}" ]]; then
            go get -u "${go_packages[$pkg]}"
        else
            echo "Package $pkg not found in the list."
        fi
    done
}

validate() {
    local url=$1
    # Add https:// to the URL
    full_url="https://$url"
    
    # Perform a HEAD request with curl to check if the URL is accessible
    response=$(curl -s --head --request GET "$full_url" | head -n 1)
    if [[ $response == *"HTTP/2 200"* ]]; then
        echo -e "${GREEN}$url: OK${NC}"
    else
        echo -e "${RED}$url: Error $response${NC}"
    fi
}
gopkg(){
# Iterate over the associative array and check each package
  if [[ $1 == "validate" ]]; then
      for key value in "${(@kv)go_packages}"; do
      validate "$value"
    done
  fi
}


gomsvc(){
  dirs=($(ls -d */))
  for dir in dirs; do
    cd $dir
    go mod init $1
  done
}
