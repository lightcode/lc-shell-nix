{ lib, pkgs, config, ... }:

with lib;

let cfg = config.lc-shell.vim;
in {
  options.lc-shell.vim = {
    enable = mkEnableOption "vim configuration";
  };

  config = mkIf cfg.enable {
    programs.neovim = let
      pastemode-vim = pkgs.vimUtils.buildVimPlugin {
        name = "pastemode-vim";
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
          plugin = ale;
          config = ''
            let g:ale_fixers = {
            \  '*': ['remove_trailing_lines', 'trim_whitespace'],
            \  'nix': ['nixfmt'],
            \  'python': ['ruff_format'],
            \  'typescript': ['prettier'],
            \}
            let g:ale_sh_shellcheck_options = '-x'
            let g:ale_sh_shellcheck_change_directory = 0
          '';
        }
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
            let g:airline_extensions = ['tabline', 'ctrlp', 'ale']
            let g:airline#extensions#tabline#enabled = 1
            let g:airline#extensions#tabline#left_sep = ""
            let g:airline#extensions#tabline#left_alt_sep = ""
            let g:airline#extensions#tabline#right_sep = ""
            let g:airline#extensions#tabline#right_alt_sep = ""
            let g:airline#extensions#tabline#formatter = 'default'
          '';
        }
      ];
      extraConfig = builtins.readFile ./vimrc;
    };
  };
}
