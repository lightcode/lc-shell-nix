{ lib, pkgs, config, ... }:

with lib;

let cfg = config.lc-shell.zsh;
in {
  options.lc-shell.zsh = {
    enable = mkEnableOption "zsh configuration";
  };

  config = mkIf cfg.enable {

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.autojump = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      initExtra = ''
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

        for script ($HOME/.zshrc.d/*(N)); source "$script"
        unset script
      '';
      history = {
        save = 10000;
        size = 10000;
      };
      localVariables = {
        WORDCHARS = "*?_-.[]~&;!#$%^(){}<>";
      };
      envExtra = builtins.readFile ./files/zshenv;
      profileExtra = ''
      # Make sure that zshenv is loaded and anything won't be
      # override by the /etc/zprofile provided by the distro.
      if [[ -f "''${HOME}/.zshenv" ]]; then
        source "''${HOME}/.zshenv"
      fi
      '';
      plugins = [
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.7.1";
            sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
          };
        }
        {
          name = "zsh-history-substring-search";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-history-substring-search";
            rev = "v1.0.2";
            sha256 = "0y8va5kc2ram38hbk2cibkk64ffrabfv1sh4xm7pjspsba9n5p1y";
          };
        }
        {
          name = "zsh-lc-shell-config";
          src = ./files/plugin;
        }
      ];
    };

  };
}
