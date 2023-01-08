{config, pkgs, lib, ...}:

let
  monitorScript = pkgs.callPackage ./scripts/monitor.nix {};
in
{
  services.polybar = {
    # home.packages = with pkgs; [ ethtool ];
    enable = true;
    package = pkgs.polybar.override {
      i3GapsSupport = true;
      pulseSupport = true;
    };
    config = {
      "settings" = { screenchange-reload = "true"; };

      "bar/top-main" = {
        monitor = "\${env:MONITOR:DP-2}";
        width = "100%";
        height = "20";

        fixed-center = false;
        line-size = "1";

        font-0 = "Source Code Pro:size=11;1";

        padding-left = "1";
        padding-right = "1";
        module-margin-left = "1";
        module-margin-right = "1";

        modules-left = "i3";
        modules-center = "date";
        modules-right = "speaker cpu memory"; #disk, network ?

        tray-position = "right";
        tray-detached = "false"; 

        wm-restack = "i3";
        cursor-click = "pointer";
      };
      "bar/top-secondary" = {
        monitor = "\${env:MONITOR:DP-4}";
        width = "100%";
        height = "20";

        fixed-center = false;
        line-size = "1";

        padding-left = "1";
        padding-right = "1";
        module-margin-left = "1";
        module-margin-right = "1";

        modules-left = "i3";
        modules-center = "date";
        modules-right = "speaker";

        wm-restack = "i3";
        cursor-click = "pointer";
      };

      "module/i3" = {
        type = "internal/i3";
        index-sort = "true";
        wrapping-scroll = "false";
        format = "<label-state> <label-mode>";
        label-mode = "%mode%";
        label-focused = "%index%";
        label-focused-padding = "2";
        label-focused-underline = "#FFF";
        label-unfocused = "%index%";
        label-unfocused-padding = "2";
        label-visible = "%index%";
        label-visible-padding = "2";
        label-urgent = "%index%";
        label-urgent-background = "#C37561";
        label-urgent-padding = "2";
        label-active-font = "1";
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = "3";
        format = "<label>";
        label = "%percentage%%";
        label-active-font = "1";
      };

      "module/sep" = {
        type = "custom/text";
        content = " | ";
        label-active-font = "1";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = "5";

        format = "<label>";
        label = "%mb_used% | %mb_swap_used%";
        label-active-font = "1";
      };

      "module/date" = {
        type = "internal/date";
        interval = "1";
        date = "%A %d %B";
        time = "at %H:%M";
        label = "%date% %time%";
        format-prefix-foreground = "#AB71FD";
        label-active-font = "1";
      };

    };
    extraConfig =  ''
      [module/speaker] 
      type = custom/script
      interval = 2
      exec = /home/scarlet/speaker.sh
      click-left = /home/scarlet/switch-audio.sh
      label-active-font = 1
    '';

    script = ''
      export MONITOR=$(${monitorScript}/bin/monitor)
      echo "Running polybar on $MONITOR"
      polybar top-main & disown
      polybar top-secondary & disown
      '';
  };
}
