{pkgs, ...}: {
  home.packages = with pkgs; [
    eww
    jq
    socat
    curl
  ];

  xdg.configFile."eww/eww.yuck".text = ''
    (defpoll time :interval "1s"
      `date '+%A %d %B at %H:%M'`)

    (defpoll weather :interval "3600s"
      `${pkgs.writeShellScript "get-weather" ''
      DATA=$(${pkgs.curl}/bin/curl -sf "https://api.open-meteo.com/v1/forecast?latitude=40.71&longitude=-74.01&current=temperature_2m,weather_code&temperature_unit=celsius")
      if [ -n "$DATA" ]; then
        TEMP=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current.temperature_2m | round')
        CODE=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current.weather_code')
        case $CODE in
          0) DESC="Clear" ;;
          1|2|3) DESC="Cloudy" ;;
          45|48) DESC="Fog" ;;
          51|53|55|56|57) DESC="Drizzle" ;;
          61|63|65|66|67) DESC="Rain" ;;
          71|73|75|77) DESC="Snow" ;;
          80|81|82) DESC="Showers" ;;
          85|86) DESC="Snow" ;;
          95|96|99) DESC="Storm" ;;
          *) DESC="" ;;
        esac
        echo "''${TEMP}°C $DESC"
      else
        echo ""
      fi
    ''}`)

    (defpoll caffeine :interval "5s"
      `systemctl --user is-active hypridle.service >/dev/null 2>&1 && echo "off" || echo "on"`)

    (defpoll cpu :interval "3s"
      `top -bn1 | grep "Cpu(s)" | awk '{print int($2)}'`)

    (defpoll memory :interval "5s"
      `free -m | awk '/Mem:/ {print $3 "MB"}'`)

    (defpoll disk :interval "30s"
      `df -h / | awk 'NR==2 {print $5}'`)

    (defpoll gpu :interval "3s"
      `nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{print int($1)}'`)

    (defpoll now-playing :interval "1s"
      `playerctl -p firefox metadata --format '{{artist}} - {{title}}'`)

    (defpoll playing-status :interval "1s"
      `playerctl -p firefox status`)


    (deflisten workspaces :initial "[]"
      `${pkgs.writeShellScript "get-workspaces" ''
      spaces() {
        SESSION=$(${pkgs.hyprland}/bin/hyprctl workspaces -j | ${pkgs.jq}/bin/jq -c '[.[] | .id] | sort')
        ACTIVE=$(${pkgs.hyprland}/bin/hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq '.id')
        echo "{\"all\": $SESSION, \"active\": $ACTIVE}"
      }
      spaces
      ${pkgs.socat}/bin/socat -u UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | while read -r line; do
        spaces
      done
    ''}`)

    (deflisten active-window :initial ""
      `${pkgs.writeShellScript "get-active-window" ''
      ${pkgs.hyprland}/bin/hyprctl activewindow -j | ${pkgs.jq}/bin/jq -r '.title // ""'
      ${pkgs.socat}/bin/socat -u UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | while read -r line; do
        ${pkgs.hyprland}/bin/hyprctl activewindow -j | ${pkgs.jq}/bin/jq -r '.title // ""'
      done
    ''}`)

    (defwidget workspaces []
      (box :class "workspaces" :orientation "h" :spacing 4 :halign "start"
        (for ws in {workspaces.all}
          (button
            :class {ws == workspaces.active ? "ws-active" : "ws-inactive"}
            :onclick "hyprctl dispatch workspace ''${ws}"
            "''${ws}"))))

    (defwidget caffeine-toggle []
      (button
        :class {caffeine == "on" ? "caffeine-active" : "caffeine-inactive"}
        :onclick {caffeine == "on" ? "systemctl --user start hypridle.service" : "systemctl --user stop hypridle.service"}
        {caffeine == "on" ? "Caf: on" : "Caf: off"}))

    (defwidget music-widget []
      (eventbox :onclick "playerctl -p firefox play-pause"
        (box :class "music" :space-evenly false :spacing 4 :halign "end"
          (label :text {playing-status == "Playing" ? "▶" : "⏸"})
          (label :text " Now Playing: ''${now-playing}" :limit-width 40 ))))

    (defwidget metrics []
      (box :class "metrics" :orientation "h" :spacing 8 :halign "end" :space-evenly false
        (music-widget)
        (label :text "|")
        (label :text "Cpu: ''${cpu}%")
        (label :text "|")
        (label :text "''${memory}")
        (label :text "|")
        (label :text "Gpu: ''${gpu}%")
        (label :text "|")
        (label :text "Disk: ''${disk}")
        (label :text "|")
        (caffeine-toggle)))

    (defwidget bar []
      (centerbox :orientation "h"
        (box :orientation "h" :space-evenly false :spacing 16 :halign "start"
          (workspaces)
          (label :class "active-window" :text active-window :limit-width 40))
        (box :orientation "h" :space-evenly false :spacing 8 :halign "center"
          (label :class "time" :text time)
          (label :class "weather" :text weather))
        (metrics)))

    (defwindow bar
      :monitor 0
      :geometry (geometry :x "0%" :y "0%" :width "100%" :height "28px" :anchor "top center")
      :stacking "fg"
      :exclusive true
      (bar))

    (defwindow bar1
      :monitor 1
      :geometry (geometry :x "0%" :y "0%" :width "100%" :height "28px" :anchor "top center")
      :stacking "fg"
      :exclusive true
      (bar))
  '';

  xdg.configFile."eww/eww.scss".text = ''
    * {
      all: unset;
      font-family: "Source Code Pro";
      font-size: 12px;
    }

    window {
      background-color: rgba(0, 0, 0, 0.85);
      color: #ffffff;
    }

    .workspaces {
      margin-left: 12px;
    }

    .ws-active, .ws-inactive {
      min-width: 20px;
    }

    .ws-active {
      color: #ffffff;
      font-weight: bold;
      text-decoration: underline;
    }

    .ws-inactive {
      color: #888888;
    }

    .time {
      font-weight: bold;
    }

    .weather {
      color: #aaaaaa;
    }

    .active-window {
      color: #aaaaaa;
    }

    .metrics {
      margin-right: 12px;
    }

    .music {
    }

    .caffeine-active {
      color: #ffcc00;
    }

    .caffeine-inactive {
      color: #888888;
    }
  '';
}
