# unused for now
{ lib, pkgs, ... }:
{
  services.picom = {
    enable = true;
    # experimentalBackends = true;
    package = pkgs.picom-next;
    backend = "glx";
    activeOpacity = 1;
    inactiveOpacity = 0.85;
    fade = true;
    fadeDelta = 5;
    vSync = false;
    settings = {
       blur = {
         method = "dual_kawase";
         strength = 5;
       };
       corner-radius = 10;
       rounded-corners-exclude = [
         "class_g = 'Bar'"
         "class_i = 'polybar'"
       ];
    };
    opacityRules = [
      #"85:class_g = 'kitty'"
      "100:class_i = 'Toolkit' && class_g = 'firefox'"
      "85:class_g = 'kitty' && focused"
      "75:class_g = 'kitty' && !focused"
      "85:class_i = 'polybar'"
    ];
  };
}
