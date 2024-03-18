convert_video_to_gif() {
    local fps=60
    local input_video="$1"
    local output_filename="output_$(date +"%Y%m%d%H%M%S").gif"

    ffmpeg -i "$input_video" -vf "fps=$fps,scale=1920:-1:flags=lanczos" -c:v gif "$output_filename"

    echo "GIF created: $output_filename"
}
