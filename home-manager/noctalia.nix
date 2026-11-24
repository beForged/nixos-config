{...}: {
  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      shell = {
        polkit_agent = true;
        launch_apps_as_systemd_services = true;
        setup_wizard_enabled = false;
      };

      theme = {
        mode = "dark";
        pure_black_dark = true;
      };

      location = {
        auto_locate = false;
        latitude = 40.71;
        longitude = -74.01;
      };

      weather = {
        enabled = true;
        refresh_minutes = 60;
        unit = "metric";
      };

      wallpaper = {
        enabled = true;
        directory = "~/pictures";
        fill_mode = "crop";
        transition = ["disc"];
        transition_duration = 2000;
      };

      idle = {
        pre_action_fade_seconds = 0;
        behavior.screen-off = {
          timeout = 1800;
          action = "screen_off";
          enabled = true;
        };
      };

      bar = {
        order = ["main"];
        main = {
          position = "top";
          thickness = 28;
          background_opacity = 0.85;
          radius = 0;
          margin_ends = 0;
          margin_edge = 0;
          shadow = false;
          capsule = false;

          start = ["workspaces" "active_window"];
          center = ["clock" "weather"];
          end = ["tray" "volume" "cpu" "ram" "gpu" "disk" "caffeine"];
        };
      };

      widget = {
        clock.format = "%A %d %B at %H:%M";

        cpu = {
          type = "sysmon";
          stat = "cpu_usage";
        };
        ram = {
          type = "sysmon";
          stat = "ram_used";
        };
        gpu = {
          type = "sysmon";
          stat = "gpu_usage";
        };
        disk = {
          type = "sysmon";
          stat = "disk_used_pct";
          path = "/";
        };
      };
    };
  };
}
