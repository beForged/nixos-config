#adapted from gvolpe
{pkgs, ...}: let
  xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
in
  pkgs.writeShellScriptBin "monitor" ''
    for m in $(polybar --list-monitors | cut -d":" -f1); do
      MONITOR=$m polybar --reload top-main &
    done

  ''
