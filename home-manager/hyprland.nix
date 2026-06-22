{ pkgs, ... }:

let
  wallpaper-switcher = pkgs.writeShellScriptBin "wallpaper-switcher" ''
    WALLPAPER_DIR="$HOME/pictures"
    MONITORS=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[].name')

    IMAGES=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | shuf -n 2)

    i=0
    for monitor in $MONITORS; do
      WALL=$(echo "$IMAGES" | sed -n "$((i+1))p")
      [ -z "$WALL" ] && WALL=$(echo "$IMAGES" | head -1)
      ${pkgs.awww}/bin/awww img -o "$monitor" --transition-type grow --transition-duration 2 "$WALL"
      i=$((i+1))
    done
  '';
in
{
  home.packages = [ wallpaper-switcher ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mainMod" = "ALT";

      env = [
        "XCURSOR_THEME,Posy_Cursor_Black"
        "XCURSOR_SIZE,24"
      ];

      monitor = [
        "DP-1,2560x1440@75,0x0,1"
        "DP-2,1920x1080@144,2560x0,1"
      ];

      exec-once = [
        "fcitx5 -d"
        "sleep 1 && ${pkgs.eww}/bin/eww open bar && ${pkgs.eww}/bin/eww open bar1"
        "awww-daemon && ${wallpaper-switcher}/bin/wallpaper-switcher"
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

      bind = [
        "$mainMod,h,movefocus,l"
        "$mainMod,j,movefocus,d"
        "$mainMod,k,movefocus,u"
        "$mainMod,l,movefocus,r"

        "$mainMod SHIFT,h,movewindow,l"
        "$mainMod SHIFT,j,movewindow,d"
        "$mainMod SHIFT,k,movewindow,u"
        "$mainMod SHIFT,l,movewindow,r"

        "$mainMod,F,fullscreen"
        "$mainMod,SPACE,togglefloating"
        "$mainMod,P,pin"
        "$mainMod,G,togglesplit"

        "$mainMod,comma,movewindow,mon:-1"
        "$mainMod,period,movewindow,mon:+1"
        "$mainMod SHIFT,comma,movecurrentworkspacetomonitor,mon:-1"
        "$mainMod SHIFT,period,movecurrentworkspacetomonitor,mon:+1"

        "$mainMod,TAB,workspace,previous"

        "$mainMod,RETURN,exec,kitty"

        "$mainMod,D,exec,rofi -show drun -show-icons"
        "$mainMod SHIFT,S,exec,grim -g \"$(slurp)\" - | wl-copy"

        "$mainMod SHIFT,Q,killactive"

        "$mainMod,1,workspace,1"
        "$mainMod,2,workspace,2"
        "$mainMod,3,workspace,3"
        "$mainMod,4,workspace,4"
        "$mainMod,5,workspace,5"
        "$mainMod,6,workspace,6"
        "$mainMod,7,workspace,7"
        "$mainMod,8,workspace,8"
        "$mainMod,9,workspace,9"

        "$mainMod SHIFT,1,movetoworkspace,1"
        "$mainMod SHIFT,2,movetoworkspace,2"
        "$mainMod SHIFT,3,movetoworkspace,3"
        "$mainMod SHIFT,4,movetoworkspace,4"
        "$mainMod SHIFT,5,movetoworkspace,5"
        "$mainMod SHIFT,6,movetoworkspace,6"
        "$mainMod SHIFT,7,movetoworkspace,7"
        "$mainMod SHIFT,8,movetoworkspace,8"
        "$mainMod SHIFT,9,movetoworkspace,9"
      ];

      bindm = [
        "$mainMod,mouse:272,movewindow"
        "$mainMod,mouse:273,resizewindow"
      ];

      binde = [
        "$mainMod CTRL,h,resizeactive,-20 0"
        "$mainMod CTRL,j,resizeactive,0 20"
        "$mainMod CTRL,k,resizeactive,0 -20"
        "$mainMod CTRL,l,resizeactive,20 0"
      ];
    };

    extraConfig = ''
      windowrule = opacity 0.85 override 0.75 override, match:class kitty
      windowrule = opacity 1.0 override 1.0 override, match:class firefox
      windowrule = float 1, match:title Picture-in-Picture
    '';
  };
}
