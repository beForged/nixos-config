SINK=$(pactl get-default-sink)
REGEX='*CODEC*'

if [[ $SINK == $REGEX ]]; then
    echo "Speaker"
else
    echo "Headset"
fi
