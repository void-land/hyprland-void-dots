playerctl metadata --format '{{ mpris:artUrl }}' -F | while read location; do
    echo $location | cut -c 8-
done
