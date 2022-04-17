#!/bin/sh
brew tap Goles/battery
brew tap homebrew/cask-fonts && brew install --cask font-source-code-pro && brew install --cask font-hack-nerd-font
brew tap heroku/brew
brew tap gigalixir/brew

brew install fish git tmux reattach-to-user-namespace asdf svn ag htop tree ctags hub direnv fzf coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc jq pyenv zlib gpg gawk spark battery heroku gigalixir


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

echo -e "\nsource "(brew --prefix asdf)"/libexec/asdf.fish" >> ~/.config/fish/config.fish

/usr/local/opt/fzf/install
export LDFLAGS="-L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include"
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf install erlang 24.3.3
asdf global erlang 24.3.3
asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf install elixir 1.13.4
asdf global elixir 1.13.4
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby latest
asdf global ruby latest
asdf plugin-add python
asdf install python latest
pip3 install --user pynvim
brew install neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
mkdir -p ~/.config/nvim/plugged
omf install bobthefish direnv fzf wifi-password
omf reload
nvim -u ~/.config/nvim/init.vim +PlugInstall +qall
nvim -u ~/.config/nvim/init.vim +UpdateRemotePlugins +qall
