{pkgs, ...}: {
  programs.starship = {
    enable = true;
    settings = {
      format = "$time$directory$git_branch$git_status$cmd_duration$line_break$character";

      add_newline = true;

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bright-purple";
      };

      git_branch = {
        symbol = "";
        style = "green";
        format = "[$symbol $branch]($style) ";
      };

      git_status = {
        style = "yellow";
        format = "[$all_status]($style) ";
        conflicted = "⚔️ ";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "🟡 \${count}";
        modified = "±\${count}";
        staged = "+\${count}";
        renamed = "🔄 \${count}";
        deleted = "❌ \${count}";
      };

      cmd_duration = {
        min_time = 2000;
        format = "took [$duration]($style) ";
        style = "yellow";
      };

      time = {
        disabled = false;
        format = "[$time]($style) ";
        time_format = "%Y-%m-%d %H:%M";
        style = "dimmed white";
      };

      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[✗](red)";
        vicmd_symbol = "[❮](yellow)";
      };

    };
  };
}
