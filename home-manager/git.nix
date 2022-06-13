{ pkgs, ... }:
{
    programs.git = {
        enable = true;
        userName = "Richard Yu";
        userEmail = "richardyu042@gmail.com";
        extraConfig = {
            init.defaultBranch = "main";
            core.editor = "vim";
        };
    };
}

