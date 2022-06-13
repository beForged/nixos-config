{ config, pkgs, ... }:

{

  imports = [
    ./zsh.nix
    ./git.nix
    ./vim.nix
  ];

  home.packages = [

  ];

  home.file.".xinitrc".source = ./files/xinitrc;

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
