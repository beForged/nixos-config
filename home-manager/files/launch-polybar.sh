killall -q polybar
echo "killed polybar" 
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload top-main &
done
