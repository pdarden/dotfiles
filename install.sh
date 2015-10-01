#!/bin/sh

brew tap neovim/neovim
brew install --HEAD neovim

for name in *; do
  target="$HOME/.$name"
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      echo "WARNING: $target exists but is not a symlink."
    fi
  else
    if [ "$name" != 'install.sh' ] && [ "$name" != 'README.md' ]; then
      echo "Creating $target"
      ln -s "$PWD/$name" "$target"
    fi
  fi
done

brew install git tmux reattach-to-user-namespace ack the_silver_searcher htop tree imagemagick node ctags hub redis mongodb chruby ruby-build gdbm libffi libyaml
brew install postgresql --no-python
brew tap Goles/battery
brew install battery
git clone https://github.com/VundleVim/Vundle.vim.git ~/.nvim/bundle/Vundle.vim
nvim -u ~/.nvimrc.bundles +PluginInstall +qall
mkdir ~/.rubies
ruby-build 2.2.3 ~/.rubies/2.2.3
