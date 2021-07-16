# lc-shell for Nix

This repository contains the Nix version of my Vim/ZSH/Tmux configuration called [lc-shell](https://github.com/lightcode/lc-shell). This configuration is a module for [home-manager](https://github.com/nix-community/home-manager).


## Usage

### Include the module

**Using niv** (you need to install and initialize it before):

```shell
niv add lightcode/lc-shell-nix -v v1.0.0
```

Then, you can import the module like this:

```nix
{
  imports = let
    sources = import ./nix/sources.nix {};
  in [
    sources.lc-shell-nix.outPath
  ];

  # ...
}
```

**Or by fetching manually the tarball**:

```nix
{
  imports = [
    (fetchTarball "https://github.com/lightcode/lc-shell-nix/archive/v1.0.0.tar.gz")
  ];
}
```

### Enable the module

In your home-manager configuration, you need to enable the features you need:

```nix
{

  lc-shell = {
    vim.enable = true;
    tmux.enable = true;
    zsh.enable = true;
  };

}
```
