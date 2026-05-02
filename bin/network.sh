# PING
pc(){
  ping 8.8.8.8 | while read -r line; do
    # Extract ping time using grep and sed
    ping_time=$(echo "$line" | grep -oE 'time=[0-9.]+' | sed 's/time=//')
    
    if [[ -n "$ping_time" && $(echo "$ping_time > 50" | bc -l) -eq 1 ]]; then
      # Red color for high ping (>50ms)
      echo -e "\e[31m$line \e[32m$(date +%F)\e[0m \e[34m$(date +%T)\e[0m"
    else
      # Cyan color for normal ping (≤50ms)
      echo -e "\e[36m$line \e[32m$(date +%F)\e[0m \e[34m$(date +%T)\e[0m"
    fi
  done
}

# Curl
## HTTP Methods
alias curlget='curl -X GET'
alias curlpost='curl -X POST'
alias curlput='curl -X PUT -H "Content-Type: application/json" -d'
alias curldel='curl -X DELETE'
alias curlpatch='curl -X PATCH'
alias curlhead='curl -X HEAD'
alias curloptions='curl -X OPTIONS'

## Commonly Used Options
alias curls='curl -s'
alias curlinc='curl -i'
alias curlheadersonly='curl -I'
alias curlv='curl -v'
alias curlf='curl -L'
alias curlheader='curl -H "Header-Name: Header-Value"'
alias curljson='curl -H "Content-Type: application/json"'
alias curlxml='curl -H "Content-Type: application/xml"'
alias curlauth='curl -H "Authorization: Bearer TOKEN_HERE"'
alias curlagent='curl -A "User-Agent-Name"'

## HTTP Authentication
alias curlbasic='curl -u username:password'
alias curltoken='curl -H "Authorization: Bearer TOKEN_HERE"'
alias curldigest='curl --digest -u username:password'

## Data Transfer
alias curlform='curl -F "field=value"'
alias curlmultipart='curl -F "file=@/path/to/file"'
alias curlpostjson='curl -X POST -H "Content-Type: application/json" -d'
alias curlputjson='curl -X PUT -H "Content-Type: application/json" -d'
alias curlupload='curl --upload-file'
alias curldown='curl -O'
alias curldownquiet='curl -sO'
alias curlresume='curl -C - -O'

## Rate Limiting and Timeouts
alias curllimit='curl --limit-rate 100K'
alias curlmaxtime='curl --max-time 30'

## Proxy Support
alias curlproxy='curl -x http://proxy.example.com:8080'
alias curlsocks='curl --socks5-hostname socks.example.com:1080'

alias curlcookie='curl -b cookie_file.txt'
# Cookies
alias curlsavecookie='curl -c cookie_file.txt'

# Debugging and Testing
alias curltrace='curl --trace-ascii /dev/stdout'
alias curlhexdump='curl --trace /dev/stdout'

# HTTP/2 and HTTP/3 Support
alias curlhttp2='curl --http2'
alias curlhttp3='curl --http3'

# Custom Ports and Methods
alias curlport='curl -X GET http://example.com:8080'
alias curloptionsport='curl -X OPTIONS http://example.com:8080'

# Compression
alias curlcompress='curl --compressed'

# FTP/SFTP
alias curlftp='curl ftp://ftp.example.com/file.txt'
alias curlftpupload='curl -T /path/to/localfile ftp://ftp.example.com/remote/path/'
alias curlsftp='curl -u username:password sftp://sftp.example.com/path/to/file'

# Advanced: Custom Aliases
alias curlgraphql='curl -X POST -H "Content-Type: application/json" -d'
alias curlpostjsonf='curl -X POST -H "Content-Type: application/json" -L --max-time 30 -d'


alias pdc="ping google.com"
# WARP-CLI
alias wrp="warp-cli status"
alias wrpc="warp-cli connect"
alias wrpdc="warp-cli disconnect"
