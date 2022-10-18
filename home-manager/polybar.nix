{config, pkgs, lib, ...}:

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
        modules-right = "speaker cpu memory"; #disk, network ?

        tray-position = "right";
        tray-detached = "false"; 

        wm-restack = "i3";
        cursor-click = "pointer";
      };
#      "bar/top-secondary" = {
#        width = "100%";
#        height = "20";
#
#        fixed-center = false;
#        line-size = "1";
#
#        padding-left = "1";
#        padding-right = "1";
#        module-margin-left = "1";
#        module-margin-right = "1";
#
#        modules-left = "i3";
#        modules-center = "date";
#        modules-right = "speaker";
#
#        wm-restack = "i3";
#        cursor-click = "pointer";
#      };

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
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = "3";
        format = "<label>";
        label = "%percentage%%";
      };

      "module/sep" = {
        type = "custom/text";
        content = " | ";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = "5";

        format = "<label>";
        label = "%mb_used% | %mb_swap_used%";
      };

      "module/date" = {
        type = "internal/date";
        interval = "1";
        date = "%A %d %B";
        time = "at %H:%M";
        label = "%date% %time%";
        format-prefix-foreground = "#AB71FD";
      };

    };
    extraConfig =  ''
      [module/speaker] 
      type = custom/script
      interval = 2
      exec = /home/scarlet/speaker.sh
      click-left = /home/scarlet/switch-audio.sh
    '';

    script = "";
  };
}
