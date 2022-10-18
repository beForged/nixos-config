{ lib, config, pkgs, ... }:

let
  mod = "Mod1";
in {
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      modifier = mod;
      fonts = ["Source Code Pro"];
      terminal = "kitty";

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
          position = "top";
          statusCommand = "i3status";
          fonts = [ "Source Code Pro" ];
        }
      ];
    };
  };
  programs.i3status = {
    enable = true;
    general = {
      output_format = "i3bar";
      colors = true;
      interval = 5;
      separator = " ";
    };
    modules = {

      "wireless _first_" = {
        enable = false;
      };
      "ethernet _first_" = {
        enable = false;
      };

      "ethernet enp24s0" =  {
        enable = true;
        position = 0;
        settings = {
          format_up = "E: %ip (%speed)";
          format_down = "E: down";
        };
      };

       "wireless wlp4s0" = {
         enable = false;
         position = 0;
         settings = {
           format_up = "W:(%quality %essid, %bitrate) %ip";
           format_down = "W: down";
         };
       };

      ipv6 = {
        enable = false;
      };

      "battery all" = {
        enable = false;
        position = 1;
        settings = {
          format = "%status %percentage %remaining ";
          format_down = "No battery";
          status_chr = "CHARGING";
          status_bat = "DISCHARGING";
          status_unk = "UNKNOWN";
          status_full = "FULL";
          path = "/sys/class/power_supply/BAT1/uevent";
          low_threshold = 30;
        };
      };

      "tztime local" =  {
        enable = true;
        position = 4;
        settings = {
          format = "%Y-%m-%d %H:%M";
        };
      };

      "cpu_temperature 0" = {
        enable = false;
        settings = {
          format = "T: %degrees°C";
          path = "/sys/class/thermal/thermal_zone2/temp";
        };
      };

      "disk /" = {
        enable = true;
        position = 1;
        settings = {
          format = "/ %avail";
        };
      };

      load = {
        enable = true;
        position = 3;
        settings = {
          format = "Load %1min";
        };
      };

      "volume master" = {
        settings = {
          device = "default";
          format = "(%devicename): %volume";
        };
        position = 2;
      };

      "memory" = {
        enable = true;
        position = 2;
        settings = {
          format = "Free: %available";
        };
      };
    };

  };
}
