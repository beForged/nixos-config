{pkgs, ...}: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "Richard Yu";
      user.email = "richardyu042@gmail.com";
      init.defaultBranch = "main";
      core.editor = "vim";
    };
  };
}
