# unused for now
{ lib, pkgs, ... }:
{
  services.picom = {
    enable = true;
    backend = "glx";
    activeOpacity = "1.0";
    experimentalBackends = true;
    opacityRule = [
      "85:class_g = 'kitty'"
    ];
    blur = true;
    blurExclude = [
      "window_type = 'dock'"
      "window_type = 'desktop'"
    ];
    extraOptions = ''

      blur-background = true;
      blur-background-frame = true;
      blur-background-fixed = false;
      blur-kern = "3x3box";
      blur-method = "box";
      blur-strength = 10;
      '';
  };
}
