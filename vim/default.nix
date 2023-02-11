{ lib, pkgs, config, ... }:

with lib;

let cfg = config.lc-shell.vim;
in {
  options.lc-shell.vim = {
    enable = mkEnableOption "vim configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.yamllint
    ];

    xdg.configFile."yamllint/config".text = ''
      extends: relaxed

      rules:
        line-length: disable
    '';

    programs.neovim = let
      pastemode-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = "pastemode-vim";
        version = "2019-11-13";
        src = pkgs.fetchFromGitHub {
          owner = "lightcode";
          repo = "PasteMode.vim";
          rev = "1046b1efc0a85ee18a0f8cdbcb3d14a1743c1a1b";
          sha256 = "0bp4rwhj08mjafcpn0f27im21gvndaa5yqfv9apar0lzqk3wwgnv";
        };
        meta.homepage = "https://github.com/lightcode/PasteMode.vim";
      };
    in {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        gruvbox
        pastemode-vim
        supertab
        vim-airline-themes
        vim-cue
        vim-gitgutter
        vim-graphql
        vim-nix

        {
          plugin = vim-terraform;
          config = ''
            let g:terraform_fmt_on_save = 1
          '';
        }
        {
          plugin = vim-markdown;
          config = ''
            let g:vim_markdown_folding_disabled = 1
          '';
        }
        {
          plugin = vim-go;
          config = ''
            if executable('goimports')
              let g:go_fmt_command = 'goimports'
            endif
          '';
        }
        {
          plugin = vim-pencil;
          config = ''
            let g:pencil#autoformat = 0
            let g:pencil#conceallevel = 0
            let g:pencil#wrapModeDefault = 'soft'
          '';
        }
        {
          plugin = syntastic;
          config = ''
            let g:syntastic_always_populate_loc_list = 1
            let g:syntastic_auto_loc_list = 2
            let g:syntastic_check_on_open = 1
            let g:syntastic_check_on_wq = 1

            " Here we can make check active or passive.
            " I made `rst` checking passive because it doesn't
            " handle Sphinx well.
            let g:syntastic_mode_map = {
                \ 'mode': 'active',
                \ 'active_filetypes': [],
                \ 'passive_filetypes': ['rst'] }

            let g:syntastic_error_symbol = '✗'
            let g:syntastic_warning_symbol = '⚠'

            let g:syntastic_python_checkers = ['flake8']
            let g:syntastic_go_checkers = ['go', 'golint', 'govet']
            let g:syntastic_javascript_checkers = ['jshint']
            let g:syntastic_yaml_checkers = ['yamllint']
            let g:syntastic_ansible_checkers = ['yaml/yamllint']

            let g:syntastic_sh_shellcheck_args = "-x"
          '';
        }
        {
          plugin = ctrlp-vim;
          config = ''
            let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:12,results:12'
            let g:ctrlp_custom_ignore = {
              \ 'dir':  '\v[\/](\.(git|hg|svn))$',
              \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$' }
            if executable('ag')
              set grepprg=ag\ --nogroup\ --nocolor
              let g:ctrlp_user_command = 'ag %s -l --hidden --ignore .git --nocolor -g ""'
            endif
          '';
        }
        {
          plugin = vim-airline;
          config = ''
            set noshowmode

            let g:airline_theme = 'bubblegum'
            let g:airline_skip_empty_sections = 1
            let g:airline_extensions = ['tabline', 'ctrlp', 'syntastic', 'whitespace']
            let g:airline#extensions#tabline#enabled = 1
            let g:airline#extensions#tabline#fnamemod = ':t'
            let g:airline#extensions#tabline#left_sep = ""
            let g:airline#extensions#tabline#left_alt_sep = ""
            let g:airline#extensions#tabline#right_sep = ""
            let g:airline#extensions#tabline#right_alt_sep = ""
          '';
        }
      ];
      extraConfig = builtins.readFile ./vimrc;
    };
  };
}
