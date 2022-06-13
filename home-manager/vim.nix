{ pkgs, ... }:
{
    programs.vim = {
        enable = true;
        settings = {
            ignorecase = true;
            shiftwidth = 4;
            tabstop = 4;
            expandtab = true;
            number = true;
        };
        extraConfig = ''
            syntax enable
            colorscheme elflord

            set softtabstop=4

            set showcmd

            set cursorline

            filetype indent plugin on

            set wildmenu
            set showmatch

            set hlsearch
            set incsearch
            set smartcase

            set autowrite
            set autoread
        '';
    };
}
