#!/bin/zsh

BASE_DIR="/media/nizar/1E064EC0064E9923/Users/Nizar/Documents/Untitled Folder/reon/ai/"

#!/bin/zsh

BASE_DIR="."

# Check if a folder contains png or jpg files
has_images() {
    local dir="$1"
    setopt null_glob
    local imgs=($dir/*.(png|jpg|PNG|JPG|JPEG))
    unsetopt null_glob
    (( ${#imgs} > 0 ))
}

compress_anime() {
    local folder="$1"
    local quality="$2"
    local converted_flag="$folder/converted.txt"
    local compressed_flag="$folder/compressed.txt"

    # Skip folder with no image
    if ! has_images "$folder"; then
        return
    fi

    echo "Processing folder: $folder"

    # PNG → JPG conversion
    if [[ ! -f "$converted_flag" ]]; then
        setopt null_glob
        local pngs=($folder/*.(png|PNG))
        if (( ${#pngs} > 0 )); then
            for img in $pngs; do
                local jpg="${img%.png}.jpg"
                echo "Converting: $img → $jpg"
                convert "$img" -background white -flatten "$jpg" && rm "$img"
            done
            echo "done" > "$converted_flag"
        fi
        unsetopt null_glob
    else
        echo "Already converted: $folder"
    fi

    # JPG compression
    if [[ ! -f "$compressed_flag" ]]; then
        setopt null_glob
        local jpgs=($folder/*.jpg)
        if (( ${#jpgs} > 0 )); then
            for img in $jpgs; do
                local tmp="${img%.jpg}_compressed.jpg"
                echo "Compressing: $img"
                convert "$img" -strip -quality "$quality" "$tmp" && mv "$tmp" "$img"
            done
            echo "done" > "$compressed_flag"
        fi
        unsetopt null_glob
    else
        echo "Already compressed: $folder"
    fi
}

# # Recursively find all directories and process them
# for dir in $(find "$BASE_DIR" -type d); do
#     process_folder "$dir"
# done


# # Traverse artist/*/project/
# for project in **/*(/N); do
#     if [[ $(basename $(dirname "$project")) != $(basename "$BASE_DIR") ]]; then
#         process_project "$project"
#     fi
# done
#

compress_anime_all(){
  all_artist=$(ls -d */)
  for artist in $all_artist; do
    echo $artist
  done

}

compress_anime_by_artist(){
  # local all_chara=(*(/N))
  # for chara in $all_chara; do
  #   echo $chara
  #   cd $chara
  #   (compress_anime . 95)
  #   cd ..
  # done

  # for dir in $(find "." -type d); do
  #   compress_anime "$dir" 95
  # done

  find "." -type d -print0 | while IFS= read -r -d '' dir; do
    compress_anime "$dir" 95
  done
}

