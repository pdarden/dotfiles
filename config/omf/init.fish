set -x PATH /usr/local/bin /usr/bin /bin /usr/sbin /sbin $PATH
set -x EDITOR "nvim -f"
set -x VISUAL "nvim -f"
set -x GIT_EDITOR "nvim -f"
set -x CUCUMBER_FORMAT pretty
set -g theme_display_ruby no
set -g theme_powerline_fonts no
set -g theme_nerd_fonts yes

# Shortcuts

### git ############
function cl
  clear
end

function gst
  git status
end

function ga
  git add $argv
end

function gc
  git commit $argv
end

function gb
  git branch $argv
end

function gd
  git diff $argv
end

function gco
  git checkout $argv
end

function gh
  git hist
end

function gpoh
  git push origin HEAD
end
function gpfoh
  git push -f origin HEAD
end

function gpr
  git pull --rebase
end

function gproh
  git pull --rebase origin HEAD
end

function gprom
  git pull --rebase origin main
end
### end git ########

function tk
  tmux kill-session
end

function browse
  hub browse
end

function vi
  nvim $argv
end

function dc
  docker-compose $argv
end

function refresh_ssh
  eval (ssh-agent -c)
end

fzf_key_bindings


# direnv
eval (direnv hook fish)
