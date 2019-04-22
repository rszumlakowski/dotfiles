alias ls='ls -G'
alias gll='git log --oneline --graph --decorate'
alias gss='git status -s'
alias lprs='lpass login --trust rszumlakowski@pivotal.io'
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

export PATH=~/bin:/usr/local/git/bin:/usr/local/mysql/bin:$PATH

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working tree clean" ]] && echo "*"
}

function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

# Set prompt
export PS1='\[\e[7m\]\u@\h \w $(parse_git_branch) $\[\e[0m\] '

export EDITOR=/usr/bin/nvim
export LSCOLORS=Exfxcxdxbxegedabagacad

export BASE16_THEME=base16-gruvbox-dark-hard.sh
source "${HOME}/.base16_theme"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/rob/work/google-cloud-sdk/path.bash.inc' ]; then source '/Users/rob/work/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/rob/work/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/rob/work/google-cloud-sdk/completion.bash.inc'; fi

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

# Set up fasd tool
eval "$(fasd --init auto)"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
