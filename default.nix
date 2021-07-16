{ config, pkgs, ... }:

{
  imports = [
    ./tmux
    ./vim
    ./zsh
  ];
}
