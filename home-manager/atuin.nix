{pkgs, ...}: {
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      sync_address = "";
      auto_sync = false;
      search_mode = "fuzzy";
      filter_mode = "host";
    };
  };
}
