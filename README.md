# Rob Szumlakowski's dotfiles configuration

Clone into your some directory.  Use the `install.sh` script to hook
up the contents of this repository as symbolic links.

Other things to hook up:

    git clone git@github.com:rszumlakowski/vimfiles ~/.vim
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ln -s ~/.vim/init.vim ~/.config/nvim/init.vim
    brew install fasd

Other steps:

1. If using iTerm and want the custom characters from `exa` and other similar
   tools to render correctly in your terminal then follow the following steps:

 - install the patched font:

    brew tap homebrew/cask-fonts
    brew install --cask font-hack-nerd-font

 - in your iTerm settings, change Profiles -> Text -> Non-ASCII Font to
   "Hack Nerd Font"

1. Other iTerm settings to change:

 - iTerm -> Preferences -> General -> Selection -> check Applications May
   Access System Clipboard.

## TODO

- Add instructions for installing colour scheme
- Add old Vim configuration settings to Neovim's configuration.
- See if you can reconcile both Neovim and Vim configuration files into one.
- Find some more files to add like:
  + ssh configuration (but not key)
  + .git config
- List more secondary programs installed with `brew`.
- Remove gcloud specific settings from `.bash_profile`
- Is there a settting to hide the git status in the directory if it's this
  dotfiles vim?
- Remove `list` setting from Neovim config
