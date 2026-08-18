{pkgs, ...}: {
  home.packages = with pkgs; [
    fortune
    cowsay
    lolcat
  ];

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

      rebuild = "sudo nixos-rebuild switch --flake '/home/scarlet/nixos#scarlet'";
      rebuild-gw = "nixos-rebuild switch --flake '/home/scarlet/nixos#gateway' --target-host scarlet@gwvnic --sudo";
    };
    initContent = ''
      export LV2_PATH=/home/scarlet/.lv2:/home/scarlet/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2

      gcm() { git commit -am "$1" && git push; }
      gcb() { git switch -c "$1"; }

      if [[ $- == *i* ]]; then
        if (( RANDOM % 2 )); then
          fortune -s | cowsay -f ~/.config/cowsay/goose.cow | lolcat -S 6
        else
          fortune -s | cowsay -f ~/.config/cowsay/duck2.cow | lolcat -S 6
        fi
      fi

       # ---- Hyprland autostart on TTY1 ----
      if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland
      fi
    '';
  };
}
