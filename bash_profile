alias ls='ls -G'
alias gll='git log --oneline --graph --decorate'
alias gss='git status -s'
alias lprs='lpass login --trust rszumlakowski@pivotal.io'
alias e='exa --icons --long --git'
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias i='fasd -f i'      # file with interactive selection
alias j='fasd_cd -d'     # cd, same functionality as j in autojump
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection
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

# Set prompt
export PS1='\[\e[7m\]\w $(parse_git_branch) \$\[\e[0m\] '

export EDITOR=/usr/local/bin/nvim
export LSCOLORS=Exfxcxdxbxegedabagacad
export VIFM="$HOME/.config/vifm"
export HISTCONTROL=ignoreboth

export BASE16_THEME=base16-gruvbox-dark-hard.sh
source "${HOME}/.base16_theme"

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
export PATH="$HOME/workspace/vsphere_kubectl:$GOBIN:$HOME/.local/bin:$PATH:${HOME}/.krew/bin"

# Use `bat` as the pager for `man`
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/rob/workspace/gcloud/google-cloud-sdk/path.bash.inc' ]; then . '/Users/rob/workspace/gcloud/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/rob/workspace/gcloud/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/rob/workspace/gcloud/google-cloud-sdk/completion.bash.inc'; fi

# Bring on the completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export PATH="/usr/local/opt/openjdk@11/bin:$PATH"
export PATH="/usr/local/opt/openssl@3/bin:$PATH"


