{ lib, config, pkgs, ... }:

let
  mod = "Mod1";
  monitorScript = pkgs.callPackage ./scripts/monitor.nix {};
in {
  imports = [ ./polybar.nix ];

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      modifier = mod;
      fonts = ["Source Code Pro"];
      terminal = "kitty";
      defaultWorkspace = "1";

      # use defaults except specified overrides
      keybindings = lib.mkOptionDefault {
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";
        "${mod}+g" = "split h";

        "${mod}+Tab" = "workspace back_and_forth";
      };
      modes = {
        resize = {
          "h" = "resize shrink width 10 px or 10 ppt";
          "k" = "resize grow height 10 px or 10 ppt";
          "j" = "resize shrink height 10 px or 10 ppt";
          "l" = "resize grow width 10 px or 10 ppt";
          "${mod}+r" = "mode default";
        };
      };
      gaps = {
        outer = 8;
        inner = 15;
      };
      window = {
        border = 0;
        titlebar = false;
      };

      bars = [
        {
          command = " ${monitorScript}/bin/monitor";
        }
      ];

      startup = [
        {
          command = "${pkgs.systemd}/bin/systemctl --user import-environment XAUTHORITY DISPLAY";
          always = true;
          notification = false;
        }
        {
          command = "${pkgs.systemd}/bin/systemctl --user restart polybar";
          always = true;
          notification = false;
        }
        {
          command = "${pkgs.systemd}/bin/systemctl --user restart picom.service";
          always = true;
          notification = false;
        }
        { command = "firefox"; workspace = "1"; }
        { command = "discord"; workspace = "2"; }
      ];
    };
  };
}
