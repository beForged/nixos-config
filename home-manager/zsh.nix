{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    shellAliases = {
      ls = "ls -a --color=auto";

      ll = "ls -al --color=auto";

      ".." = "cd ..";

      "..." = "cd ../../";

      "...." = "cd ../../../";

      "....." = "cd ../../../../";

      grep = "grep --color=auto";

      sourcerc = "exec zsh";

      gs = "git status";
      gd = "git diff";
      gsw = "git switch";
      gswm = "git switch main && git pull --ff";
      gcam = "git commit -am";

      vi = "vim";

      edit = "vim";

      ping = "ping -c 5";

      wallpaper = "wallpaper-switcher";

      restartpipewire = "systemctl --user restart wireplumber pipewire pipewire-pulse";

      rebuild = "sudo nixos-rebuild switch --impure  --flake '/home/scarlet/nixos#scarlet'";
    };
    initContent = ''
      export LV2_PATH=/home/scarlet/.lv2:/home/scarlet/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2

      gcm() { git commit -am "$1" && git push; }
      gcb() { git switch -c "$1"; }

       # ---- Hyprland autostart on TTY1 ----
      if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland
      fi
    '';
  };
}
