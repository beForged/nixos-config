{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mainMod" = "ALT";

      monitor = ",preferred,auto,1";

      exec-once = [
        "fcitx5 -d"
      ];
      # "systemctl --user restart waybar"

      input = {
        kb_layout = "us";
        follow_mouse = 1;
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

      windowrulev2 = [
        "workspace 1,class:^(discord)$"
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

        "$mainMod,Q,killactive"

        "$mainMod,1,workspace,1"
        "$mainMod,2,workspace,2"
        "$mainMod,3,workspace,3"

        "$mainMod SHIFT,1,movetoworkspace,1"
        "$mainMod SHIFT,2,movetoworkspace,2"
        "$mainMod SHIFT,3,movetoworkspace,3"
      ];
    };
  };
}
