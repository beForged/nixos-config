{ pkgs, ... }: 
{
    programs.zsh = {
        enable = true;
        enableSyntaxHighlighting = true;
        enableCompletion = true;
        enableAutosuggestions = true;
        shellAliases = {
            ls="ls -a --color=auto";

            ll="ls -al --color=auto";

            ".."="cd ..";

            "..."="cd ../../";

            "...."="cd ../../../";

            "....."="cd ../../../../";

            grep="grep --color=auto";

            vi="vim";

            edit="vim";

            ping="ping -c 5";

            vgaright="xrandr --output DP-1 --auto --right-of eDP-1";
            vgaleft="xrandr --output DP-1 --auto --left-of eDP-1";
            hdmileft="xrandr --output DP-2 --auto --left-of eDP-1";
            hdmiright="xrandr --output DP-2 --auto --right-of eDP-1";

            wallpaper="feh --bg-fill --randomize ~/pictures/*";
        };
        initExtra = ''
            export LV2_PATH=/home/scarlet/.lv2:/home/scarlet/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2
            autoload -U colors && colors
            PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "
            if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
                exec startx
            fi
        '';
    };
}
