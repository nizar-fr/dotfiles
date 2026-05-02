alias gobuster="docker run --rm ghcr.io/oj/gobuster:latest"

dockertotal(){
  docker images
  docker images --format "{{.Size}}" | sed 's/MB//' | awk '{sum += $1} END {print "Total size: " sum " MB"}'
}


