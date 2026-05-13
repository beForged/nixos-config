{
  config,
  pkgs,
  ...
}: let
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  hyprland =
    (import flake-compat {
      src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
    })
    .defaultNix;
in {
  imports = [
    hyprland.homeManagerModules.default
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      monitor = ",preferred,auto,1";

      input = {
        kb_layout = "us";
        follow_mouse = 1;
      };

      general = {
        gaps_in = 15;
        gaps_out = 8;
        border_size = 0;
      };

      decoration = {
        rounding = 0;
        blur = {
          enabled = false;
        };
      };

      bind = [
      # movement (like i3 hjkl)
      "SUPER, h, movefocus, l"
      "SUPER, j, movefocus, d"
      "SUPER, k, movefocus, u"
      "SUPER, l, movefocus, r"

      # move windows
      "SUPER SHIFT, h, movewindow, l"
      "SUPER SHIFT, j, movewindow, d"
      "SUPER SHIFT, k, movewindow, u"
      "SUPER SHIFT, l, movewindow, r"

      # terminal
      "SUPER, Return, exec, kitty"

      # workspace switching
      "SUPER, 1, workspace, 1"
      "SUPER, 2, workspace, 2"
      "SUPER, Tab, workspace, previous"
      ];
    };
  };
}
