{ pkgs, ... }:
{
  home.sessionVariables = {
    TERMINAL="kitty";
  };
  programs.kitty = {
    enable = true;
    font = {
      name = "Source Code Pro Semibold";
      # bold_font        = "Source Code Pro Bold";
      # italic_font      = "Source Code Pro Italic";
      # bold_italic_font = "Source Code Pro Bold Italic";
      size = 15;
    };
  };
}
