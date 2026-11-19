
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working tree clean" ]] && echo "*"
}

function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ [\1$(parse_git_dirty)]/"
}

tman() {
    tmux split-window -h -p 40 'exec man '$1''
}

thelp() {
    tmux split-window -h -p 40 "$* --help | bat --plain --language man --paging always"
}

kv() {
  kubectl get $* --output yaml | nvim - "+set ft=yaml"
}

ks() {
  kubectl get secret $* --output yaml | ksd | bat -pl yaml
}

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        source "$BASE16_SHELL/profile_helper.sh"
        
base16_gruvbox-dark-medium

source $HOME/workspace/dotfiles/aliases

# Set prompt
setopt PROMPT_SUBST
export PS1='%S%~$(parse_git_branch) %#% %s '

fix_ssh() {
  export MY_SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock.local
  if [[ -L $MY_SSH_AUTH_SOCK ]]; then
    rm -f $MY_SSH_AUTH_SOCK
  fi
  eval $(ssh-agent)
  echo "SSH_AUTH_SOCK is '$SSH_AUTH_SOCK'."
  if [[ -S $SSH_AUTH_SOCK ]]; then
    ln -s $SSH_AUTH_SOCK $MY_SSH_AUTH_SOCK
    echo "Linked '$MY_SSH_AUTH_SOCK' to '$SSH_AUTH_SOCK'."
  fi
}

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

setopt interactivecomments

bindkey -e # Force emacs keybindings

# Enable shell completion for commands installed by brew
autoload -Uz compinit
compinit

setopt AUTO_PUSHD        # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS # Do not store duplicates in the stack.
setopt PUSHD_SILENT      # Do not print the directory stack after pushd or popd.

# Enable syntax highlighting for the shell
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/rob/.docker/completions $fpath)
autoload -Uz compinit
(( ${+_comps[docker]} )) || compinit
# End of Docker CLI completions

fpath[1,0]=$HOME/.zsh/completion

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "/Users/rob"/.zsh/cache
. /Users/rob/.asdf/asdf.sh
. /Users/rob/.asdf/plugins/java/set-java-home.zsh
