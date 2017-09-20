#!/bin/sh

brew tap caskroom/fonts
brew cask install font-source-code-pro-for-powerline
brew install fish git tmux reattach-to-user-namespace ag htop tree ctags hub direnv fzf coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc jq pyenv zlib
brew tap Goles/battery
brew install battery

sudo echo '/usr/local/bin/fish' >> /etc/shells
chsh -s `which fish`

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

/usr/local/opt/fzf/install
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.3.0
echo 'source ~/.asdf/asdf.fish' >> ~/.config/fish/config.fish
mkdir -p ~/.config/fish/completions; and cp ~/.asdf/completions/asdf.fish ~/.config/fish/completions
export LDFLAGS="-L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include"
asdf plugin-add python https://github.com/tuvistavie/asdf-python.git
asdf install python 3.7.3
asdf global python 3.7.3
pip3 install --user pynvim
brew install neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p ~/.config/nvim/plugged
omf install bobthefish direnv fzf spark wifi-password
mkdir -p ~/.fzf/shell/
ln -s ~/.config/fish/functions/fzf_key_bindings.fish ~/.fzf/shell/key-bindings.fish
omf reload
nvim -u ~/.config/nvim/init.vim +PluginInstall +qall
nvim -u ~/.config/nvim/init.vim +UpdateRemotePlugins +qall
