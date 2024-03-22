convert_video_to_gif() {
    local fps=60
    local input_video="$1"
    local output_filename="output_$(date +"%Y%m%d%H%M%S").gif"

    ffmpeg -i "$input_video" -vf "fps=$fps,scale=1920:-1:flags=lanczos" -c:v gif "$output_filename"

    echo "GIF created: $output_filename"
}

extract() {
    params_required "File" "$1" "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"

    case $1 in
    *.tar.bz2) tar xvjf $1 ;;
    *.tar.gz) tar xvzf $1 ;;
    *.tar.xz) tar xvJf $1 ;;
    *.lzma) unlzma $1 ;;
    *.bz2) bunzip2 $1 ;;
    *.rar) unrar x -ad $1 ;;
    *.gz) gunzip $1 ;;
    *.tar) tar xvf $1 ;;
    *.tbz2) tar xvjf $1 ;;
    *.tgz) tar xvzf $1 ;;
    *.zip) unzip $1 ;;
    *.Z) uncompress $1 ;;
    *.7z) 7z x $1 ;;
    *.xz) unxz $1 ;;
    *.exe) cabextract $1 ;;
    *) echo "extract: '$1' - unknown archive method" ;;
    esac
}
