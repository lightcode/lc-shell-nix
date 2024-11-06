# lc-shell for Nix

This repository contains a Nix module to configure Vim, ZSH and tmux. This module is meant to be used with [home-manager](https://github.com/nix-community/home-manager).


## Installation

### Prerequisites

You need to have Nix and home-manager installed.

### Include the module

**Using niv** (you need to install and initialize it before):

```shell
niv add lightcode/lc-shell-nix -v v1.0.0
```

You can import it by adding these lines to your `home.nix`:

```nix
{
  imports = let
    sources = import ./nix/sources.nix {};
  in [
    sources.lc-shell-nix.outPath
  ];
}
```

**Or by fetching manually the tarball**:

If you don't want to use `niv`, you can add these lines to your `home.nix`:

```nix
{
  imports = [
    (fetchTarball "https://github.com/lightcode/lc-shell-nix/archive/v1.0.0.tar.gz")
  ];
}
```

### Enable the module

Once the module is added to your configuration, you need to enable the features you need:

```nix
{
  lc-shell = {
    vim.enable = true;
    tmux.enable = true;
    zsh.enable = true;
  };
}
```


## What lc-shell-nix can do?

### Vim

* <kbd>CTRL</kbd> + <kbd>k</kbd> and <kbd>CTRL</kbd> + <kbd>p</kbd>: enable/disable paste mode and hide/show line number
* <kbd>,</kbd> + <kbd>w</kbd>: write
* <kbd>,</kbd> + <kbd>q</kbd>: quit buffer
* <kbd>CTRL</kbd> + <kbd>p</kbd>: open ctrlp, an extension that allows to open files
* <kbd>,</kbd> + <kbd>Left</kbd>/<kbd>Right</kbd>: change buffer
* <kbd>,</kbd> + <kbd>s</kbd>: strip trailing whitespace (remove white space at the end of lines)

**Note**: in this context, buffers are used like tabs.


### Tmux

* <kbd>ALT</kbd> + <kbd>Up</kbd>/<kbd>Down</kbd>/<kbd>Left</kbd>/<kbd>Right</kbd>: move between panels
* <kbd>ALT</kbd> + <kbd>PageUp</kbd>/<kbd>PageDown</kbd>: change window
* <kbd>ALT</kbd> + <kbd>Space</kbd>: zoom a panel
* <kbd>CTRL</kbd> + <kbd>b</kbd>, <kbd>PageUp</kbd>: scroll the panel up. Next you can move with <kbd>PageUP</kbd>,
  <kbd>PageDown</kbd> and the arrows. This mode is the copy mode.


### ZSH

Functions:

* `reloadzsh`: reload `.zshrc`, `.zshenv` and run `rehash` (that permit to recreate hash table that contains all functions in PATH. This is useful for completion)

Useful aliases:

* `gc`: `git commit`
* `gl`: `git log`
* `gws`: `git status --short`


### ZSH customizations

To customize ZSH, you can add ZSH files in the `~/.zshrc.d` directory. You can still use the features provided by home-manager and Nix to override some parameters or add plugins.
