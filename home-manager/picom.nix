# unused for now
{ lib, pkgs, ... }:
{
  services.picom = {
    enable = true;
    # experimentalBackends = true;
    backend = "glx";
    activeOpacity = "1.0";
    fade = true;
   # vSync = false;
   # settings = {
   #    blur = {
   #      method = "dual_kawase";
   #      size = 20;
   #      deviation = 5.0;
   #    };
   #  };
    # inactiveOpacity = 0.8;
    opacityRule = [
      "85:class_g = 'kitty'"
      "85:class_g = 'polybar'"
    ];
    blur = true;
      # "window_type = 'dock'"
    blurExclude = [
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
