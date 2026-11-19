alias ls='ls -G'
alias gll='git log --oneline --graph --decorate'
alias gss='git status -s'
alias k='kubectl'
 
export PATH=~/bin:~/workspace/mongodb-database-tools/bin:$PATH

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

export EDITOR=/opt/homebrew/bin/nvim
export LSCOLORS=Exfxcxdxbxegedabagacad
export HISTCONTROL=ignoreboth

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        source "$BASE16_SHELL/profile_helper.sh"
        
base16_gruvbox-dark-medium

# Set prompt
setopt PROMPT_SUBST
export PS1='%S%~$(parse_git_branch) %#% %s '
#export PS1='\[\e[7m\]\w $(parse_git_branch) \$\[\e[0m\] '

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

# Use `bat` as the pager for `man`
export BAT_THEME="Dracula"
export MANPAGER="sh -c 'col -bx | bat -pl man'"

setopt interactivecomments

bindkey -e # Force emacs keybindings

# Enable shell completion for commands installed by brew
autoload -Uz compinit
compinit

# Enable syntax highlighting for the shell
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# NOTE update this if installing a new OpenJDK
export JAVA_HOME=/Users/rob/Library/Java/JavaVirtualMachines/openjdk-21.0.2/Contents/Home

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
