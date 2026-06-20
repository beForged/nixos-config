{ pkgs, ... }:

{
  home.packages = with pkgs; [
    eww
    jq
    socat
  ];

  xdg.configFile."eww/eww.yuck".text = ''
    (defpoll time :interval "1s"
      `date '+%A %d %B at %H:%M'`)

    (defpoll cpu :interval "3s"
      `top -bn1 | grep "Cpu(s)" | awk '{print int($2)}'`)

    (defpoll memory :interval "5s"
      `free -m | awk '/Mem:/ {print $3 "MB"}'`)

    (defpoll disk :interval "30s"
      `df -h / | awk 'NR==2 {print $5}'`)

    (defpoll gpu :interval "3s"
      `nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{print int($1)}'`)


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
      (box :class "workspaces" :orientation "h" :spacing 8 :halign "start" :width 100
        (for ws in {workspaces.all}
          (button
            :class {ws == workspaces.active ? "ws-active" : "ws-inactive"}
            :onclick "hyprctl dispatch workspace ''${ws}"
            "''${ws}"))))

    (defwidget metrics []
      (box :class "metrics" :orientation "h" :spacing 16 :halign "end"
        (label :text "Cpu: ''${cpu}%")
        (label :text "|")
        (label :text "''${memory}")
        (label :text "|")
        (label :text "Gpu: ''${gpu}%")
        (label :text "|")
        (label :text "Disk: ''${disk}")))

    (defwidget bar []
      (centerbox :orientation "h"
        (box :orientation "h" :spacing 16 :halign "start"
          (workspaces)
          (label :class "active-window" :text active-window :limit-width 40))
        (label :class "time" :text time)
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

    .active-window {
      color: #aaaaaa;
    }

    .metrics {
      margin-right: 12px;
    }
  '';
}
