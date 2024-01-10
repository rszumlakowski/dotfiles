alias ls='ls -G'
alias gll='git log --oneline --graph --decorate'
alias gss='git status -s'
alias e='exa --icons --long --git'
alias k='kubectl'
 
export PATH=~/bin:$PATH

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working tree clean" ]] && echo "*"
}

function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
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

# Set prompt
export PS1='\[\e[7m\]\w $(parse_git_branch) \$\[\e[0m\] '

export EDITOR=/usr/local/bin/nvim
export LSCOLORS=Exfxcxdxbxegedabagacad
export VIFM="$HOME/.config/vifm"
export HISTCONTROL=ignoreboth

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell"
export BASE16_DEFAULT_THEME=decaf
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
       source "$BASE16_SHELL/profile_helper.sh"

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

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$HOME/.local/bin:$PATH:${HOME}/.krew/bin"

# Use `bat` as the pager for `man`
export BAT_THEME="Dracula"
export MANPAGER="sh -c 'col -bx | bat -pl man'"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/rob/workspace/gcloud/google-cloud-sdk/path.bash.inc' ]; then . '/Users/rob/workspace/gcloud/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/rob/workspace/gcloud/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/rob/workspace/gcloud/google-cloud-sdk/completion.bash.inc'; fi

# Bring on the completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export PATH="/usr/local/opt/openjdk@11/bin:$PATH"
export PATH="/usr/local/opt/openssl@3/bin:$PATH"

# broot as a shell function
source "$HOME/.config/broot/launcher/bash/br"
