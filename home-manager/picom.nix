# unused for now
{ lib, pkgs, ... }:
{
  services.picom = {
    enable = true;
    # experimentalBackends = true;
    backend = "glx";
    activeOpacity = 1;
    fade = true;
    vSync = false;
    settings = {
       blur = {
         method = "dual_kawase";
         size = 20;
         deviation = 5.0;
       };
    };
    # inactiveOpacity = 0.8;
    opacityRule = [
      "85:class_g = 'kitty'"
      "85:class_g = 'polybar'"
    ];
    # blur = true;
      # "window_type = 'dock'"
    # blurExclude = [
    #   "window_type = 'desktop'"
    # ];
  };
}
