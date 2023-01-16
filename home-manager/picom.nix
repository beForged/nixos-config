# unused for now
{ lib, pkgs, ... }:
{
  services.picom = {
    enable = true;
    # experimentalBackends = true;
    package = pkgs.picom;
    backend = "glx";
    activeOpacity = 1;
    inactiveOpacity = 0.85;
    fade = true;
    fadeDelta = 3;
    vSync = false;
    settings = {
       blur = {
         method = "dual_kawase";
         strength = 5;
       };
    };
    opacityRules = [
      #"85:class_g = 'kitty'"
      "85:class_g = 'kitty' && focused"
      "75:class_g = 'kitty' && !focused"
      "85:class_g = 'polybar'"
    ];
  };
}
