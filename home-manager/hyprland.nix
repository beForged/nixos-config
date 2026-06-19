{ pkgs, ... }:

let
  wallpaper-switcher = pkgs.writeShellScript "wallpaper-switcher" ''
    WALLPAPER_DIR="$HOME/pictures"
    MONITORS=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[].name')

    IMAGES=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | shuf -n 2)

    i=0
    for monitor in $MONITORS; do
      WALL=$(echo "$IMAGES" | sed -n "$((i+1))p")
      [ -z "$WALL" ] && WALL=$(echo "$IMAGES" | head -1)
      ${pkgs.swww}/bin/swww img -o "$monitor" --transition-type grow --transition-duration 2 "$WALL"
      i=$((i+1))
    done
  '';
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mainMod" = "ALT";

      monitor = ",preferred,auto,1";

      exec-once = [
        "fcitx5 -d"
        "${pkgs.eww}/bin/eww open bar"
        "swww-daemon && ${wallpaper-switcher}"
        "mako"
        "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
      ];

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        accel_profile = "flat";
      };

      cursor = {
        no_hardware_cursors = true;
      };

      general = {
        gaps_in = 15;
        gaps_out = 8;

        border_size = 0;

        layout = "dwindle";
      };

      decoration = {
        rounding = 10;

        blur = {
          enabled = true;
          size = 5;
          passes = 2;
        };

        active_opacity = 1.0;
        inactive_opacity = 0.9;
      };

      animations.enabled = true;

      dwindle = {
        preserve_split = true;
      };

      workspace = [
        "1"
        "2"
        "3"
      ];

      bind = [
        "$mainMod,h,movefocus,l"
        "$mainMod,j,movefocus,d"
        "$mainMod,k,movefocus,u"
        "$mainMod,l,movefocus,r"

        "$mainMod SHIFT,h,movewindow,l"
        "$mainMod SHIFT,j,movewindow,d"
        "$mainMod SHIFT,k,movewindow,u"
        "$mainMod SHIFT,l,movewindow,r"

        "$mainMod,TAB,workspace,previous"

        "$mainMod,RETURN,exec,kitty"

        "$mainMod,D,exec,rofi -show drun -show-icons"
        "$mainMod SHIFT,S,exec,grim -g \"$(slurp)\" - | wl-copy"

        "$mainMod,Q,killactive"

        "$mainMod,1,workspace,1"
        "$mainMod,2,workspace,2"
        "$mainMod,3,workspace,3"

        "$mainMod SHIFT,1,movetoworkspace,1"
        "$mainMod SHIFT,2,movetoworkspace,2"
        "$mainMod SHIFT,3,movetoworkspace,3"
      ];
    };

    extraConfig = ''
      windowrule = workspace 1, class:discord
      windowrule = opacity 0.85 0.75, class:kitty
      windowrule = opacity 1.0 1.0, class:firefox
    '';
  };
}
