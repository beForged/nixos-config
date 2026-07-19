setup for home desktop nixos files

to switch between x11 and wayland, go to home.nix
- comment out hyprland and hypridle and eww.nix
- uncomment i3 and picom
- comment out the cursor (maybe not needed)
- comment out wayland packages like awww, wl clipboard, mako, xdg portal, polkit agent
- comment out some of the session vars

new todo / nice to have list:
- figure out how to use neovim as an ide with an lsp
- figure out how to package vpn homepage without leaking api keys
- add weather (update once per hour?) to topbar
    - likely can use pirate weather or openweather api
- fix window gaps spacing? 
- update zsh aliases to use wayland instead of x commands (like wallpaper)
- implement
`
if status is-interactive
    fortune 5% computers 5% linuxcookie 2% startrek 88% wisdom | cowsay -f ~/.dotfiles/apps/goose.cow | lolcat -S 6
end
`
