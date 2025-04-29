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
  local BRANCH=$(git branch --no-color 2> /dev/null)
  if [[ -n $BRANCH ]]; then
    echo "$BRANCH" | sed -e '/^[^*]/d' -e "s/* \(.*\)/ [\1$(parse_git_dirty)]/"
  fi
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

kst() {
  kubectl get $* --output yaml | yq .status
}

ks() {
  kubectl get secret $* --output yaml | ksd | bat -pl yaml
}

kl() {
  kubectl logs $* --all-containers=true | lnav
}

klever() {
  kubectl --kubeconfig "$LEVER_CONFIG" $*
}

# Set prompt
export PS1='\[\e[7m\]\w$(parse_git_branch)`if [ -n "$(jobs -p)" ]; then echo " (\j)"; fi` \$\[\e[0m\] '

export EDITOR=/usr/local/bin/nvim
export LSCOLORS=Exfxcxdxbxegedabagacad
export HISTCONTROL=ignoreboth
export LEVER_CONFIG="$HOME/.kube/tanzu-build-basic.kubeconfig"
export GH_HOST="github.gwd.broadcom.net"

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

# Bring on the completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export PATH="/usr/local/opt/openjdk@11/bin:$PATH"
export PATH="/usr/local/opt/openssl@3/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

lever_logs() {
  #
  # Show the logs of a Request
  #
  # Usage:
  #
  #   lever_logs myrequest
  #
  local BUILD_ID="$(kubectl --kubeconfig "$LEVER_CONFIG" get request "${1:?}" --template="{{.metadata.uid}}")"
  stern \
    --kubeconfig "$HOME/.kube/lever.kube.config" \
    --since 24h \
    --namespace default \
    --selector lever.cc.build/build-id="$BUILD_ID"
}


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/rszumlakowsk/workspace/gcloud/google-cloud-sdk/path.bash.inc' ]; then . '/Users/rszumlakowsk/workspace/gcloud/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/rszumlakowsk/workspace/gcloud/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/rszumlakowsk/workspace/gcloud/google-cloud-sdk/completion.bash.inc'; fi
