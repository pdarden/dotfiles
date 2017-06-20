#!/bin/sh

brew tap caskroom/fonts
brew cask install font-source-code-pro-for-powerline
brew install neovim/neovim/neovim
pip3 install neovim
brew install fish

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

brew install git tmux reattach-to-user-namespace ag htop tree ctags hub direnv fzf coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc jq
brew tap Goles/battery
brew install battery
/usr/local/opt/fzf/install
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.3.0
echo 'source ~/.asdf/asdf.fish' >> ~/.config/fish/config.fish
mkdir -p ~/.config/fish/completions; and cp ~/.asdf/completions/asdf.fish ~/.config/fish/completions
asdf plugin-add python https://github.com/tuvistavie/asdf-python.git
asdf install python 3.6.1
asdf global python 3.6.1
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \                                                                                      Mon Jun  5 23:57:47 2017
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p ~/.config/nvim/plugged
omf install bobthefish direnv fzf spark wifi-password
omf reload
nvim -u ~/.config/nvim/init.vim +PluginInstall +qall
