{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./zsh.nix
    ./git.nix
    ./vim.nix
    ./kitty.nix
    #./i3.nix
    #./picom.nix
    ./hyprland.nix
    ./eww.nix
  ];

  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 24;
    gtk.enable = true;
  };

  home.packages = with pkgs; [
    rofi
    swww
    grim
    slurp
    wl-clipboard
    mako
    xdg-desktop-portal-hyprland
    kdePackages.polkit-kde-agent-1
  ];

  home.file = {
    # ".xinitrc".source = ./files/.xinitrc;
    # ".config/picom.conf".source = ./files/picom.conf;
  };



  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";

    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";

    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "scarlet";
  home.homeDirectory = "/home/scarlet";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
