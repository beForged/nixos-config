{pkgs, ...}: let
  wallpaper-switcher = pkgs.writeShellScriptBin "wallpaper-switcher" ''
    WALLPAPER_DIR="$HOME/pictures"
    MONITORS=$(${pkgs.niri}/bin/niri msg --json outputs | ${pkgs.jq}/bin/jq -r 'keys[]')

    IMAGES=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | shuf -n 2)

    i=0
    for monitor in $MONITORS; do
      WALL=$(echo "$IMAGES" | sed -n "$((i+1))p")
      [ -z "$WALL" ] && WALL=$(echo "$IMAGES" | head -1)
      ${pkgs.noctalia}/bin/noctalia msg wallpaper-set "$monitor" "$WALL"
      i=$((i+1))
    done
  '';
in {
  home.packages = [
    wallpaper-switcher
    pkgs.xwayland-satellite
  ];

  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "us"
            }
        }

        mouse {
            accel-profile "flat"
        }

        focus-follows-mouse max-scroll-amount="0%"

        mod-key "Alt"
        mod-key-nested "Super"
    }

    output "DP-1" {
        mode "2560x1440"
        scale 1
        position x=0 y=0
    }

    output "DP-2" {
        mode "1920x1080"
        scale 1
        position x=2560 y=0
    }

    cursor {
        xcursor-theme "Posy_Cursor_Black"
        xcursor-size 24
    }

    layout {
        gaps 12
        struts {
            left -4
            right -4
            top -4
            bottom -4
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            off
        }

        border {
            off
        }
    }

    blur {
        passes 2
        offset 5.0
    }

    prefer-no-csd

    spawn-at-startup "fcitx5" "-d"
    spawn-sh-at-startup "sleep 2 && wallpaper-switcher"

    window-rule {
        geometry-corner-radius 10
        clip-to-geometry true

        background-effect {
            blur true
        }
    }

    window-rule {
        match is-active=false
        opacity 0.9
    }

    window-rule {
        match app-id="^kitty$"
        opacity 0.85
    }

    window-rule {
        match app-id="^kitty$" is-active=false
        opacity 0.75
    }

    window-rule {
        match app-id="^firefox$"
        opacity 1.0
    }

    window-rule {
        match title="^Picture-in-Picture$"
        open-floating true
    }

    binds {
        Mod+H { focus-column-left; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+L { focus-column-right; }

        Mod+Shift+H { move-column-left; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+L { move-column-right; }

        Mod+F { fullscreen-window; }
        Mod+Space { toggle-window-floating; }
        Mod+G { consume-or-expel-window-left; }

        Mod+Comma { move-window-to-monitor-left; }
        Mod+Period { move-window-to-monitor-right; }
        Mod+Shift+Comma { move-workspace-to-monitor-left; }
        Mod+Shift+Period { move-workspace-to-monitor-right; }

        Mod+Return { spawn "kitty"; }

        Mod+D { spawn-sh "noctalia msg panel-toggle launcher"; }
        Mod+Shift+S { spawn-sh r#"grim -g "$(slurp)" - | wl-copy"#; }

        Mod+Shift+Q repeat=false { close-window; }

        XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "noctalia msg volume-up"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn-sh "noctalia msg volume-down"; }
        XF86AudioMute allow-when-locked=true { spawn-sh "noctalia msg volume-mute"; }
        XF86AudioPlay allow-when-locked=true { spawn-sh "noctalia msg media toggle"; }
        XF86AudioPause allow-when-locked=true { spawn-sh "noctalia msg media toggle"; }
        XF86AudioStop allow-when-locked=true { spawn-sh "noctalia msg media stop"; }
        XF86AudioNext allow-when-locked=true { spawn-sh "noctalia msg media next"; }
        XF86AudioPrev allow-when-locked=true { spawn-sh "noctalia msg media previous"; }

        Mod+O repeat=false { toggle-overview; }
        Mod+Shift+Slash { show-hotkey-overlay; }
        Mod+Shift+E { quit; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        Mod+Shift+1 { move-window-to-workspace 1; }
        Mod+Shift+2 { move-window-to-workspace 2; }
        Mod+Shift+3 { move-window-to-workspace 3; }
        Mod+Shift+4 { move-window-to-workspace 4; }
        Mod+Shift+5 { move-window-to-workspace 5; }
        Mod+Shift+6 { move-window-to-workspace 6; }
        Mod+Shift+7 { move-window-to-workspace 7; }
        Mod+Shift+8 { move-window-to-workspace 8; }
        Mod+Shift+9 { move-window-to-workspace 9; }

        Mod+Ctrl+H { set-column-width "-20"; }
        Mod+Ctrl+J { set-window-height "+20"; }
        Mod+Ctrl+K { set-window-height "-20"; }
        Mod+Ctrl+L { set-column-width "+20"; }
    }
  '';
}
