{ lib, pkgs, config, ... }:

with lib;

let cfg = config.lc-shell.tmux;
in {
  options.lc-shell.tmux = {
    enable = mkEnableOption "tmux configuration";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      escapeTime = 5;
      historyLimit = 50000;
      keyMode = "vi";
      terminal = "screen-256color";
      extraConfig = builtins.readFile ./tmux.conf;
    };
  };
}
