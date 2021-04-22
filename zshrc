### Put git branch information to PS1
function parse_git_branch() {
    # Speed up opening up a new terminal since HOME can't be a repo anyway
    [ "$PWD" = "$HOME" ] && return

    ref="$(command git symbolic-ref --short HEAD 2> /dev/null)" || return
    echo "[ $ref ]"
}

setopt PROMPT_SUBST
PROMPT='%n:%9c %{%F{green}%}$(parse_git_branch)%{%F{none}%}'$'\n''$ '

### export Homebrew to PATH
export PATH="/usr/local/bin":${PATH}

### export Homebrew's python first
export PATH="/usr/local/opt/python/libexec/bin":${PATH}

### Locale settings
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

### Useful alias
alias gits="git status"
alias search="grep -R --exclude-dir=__pycache__ -in"
alias wtf="ping 8.8.8.8"
alias reconn="networksetup -setairportpower en0 off && networksetup -setairportpower en0 on"
alias robot_clean="find . \( -name log.html -or -name report.html -or -name output.xml -or -name debug.log -or -name \"*-screenshot-*.png\" \) -exec rm -rf {} \;"
alias gitk="git log --graph --abbrev-commit --pretty=oneline --decorate"

### wrapper for virtualenv; either activate environment if such exists, otherwise create
plugins=(virtualenv)
function workon {
  base="$HOME/python-envs"

  if [[ ! -a "$base/$1" ]]; then
    envs=$(ls -1 $base |tr '\n' ';')
    echo "Please give environment name: $envs"
    return
  fi
  source $base/$1/bin/activate
}

### make new shell have a random word as it's title
DISABLE_AUTO_TITLE="true"
WORD=$( shuf -n1 /usr/share/dict/words )
echo -en "\e]2;$WORD\a"
echo -ne "\033]0;"$WORD"\007" # sets iterm

### add Skim's command-line utilities to PATH
export PATH=${PATH}:"/Applications/Skim.app/Contents/SharedSupport/"

### add own installed stuff to PATH
export PATH=${PATH}:"$HOME/bin"

### Rebind CTRL+w so it only deletes to last word separator instead of the whole word
autoload -U select-word-style
select-word-style bash

export WORDCHARS='.-'

### Make Fn+ ← / → go beginning and end of line
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

### Add RVM to PATH for scripting
export PATH=${PATH}:"$HOME/.rvm/bin"

### Uses fswatch ( https://github.com/emcrisostomo/fswatch ) to check on files
function watch {
  fswatch=$(which fswatch)
  cmd="$1"
  shift
  target="$@"
  echo "Watching recursively: $target"
  echo
  $fswatch -or $target |xargs -n1 -I% sh -c "echo RUNNING COMMAND: $cmd; echo; $cmd"
}

### Add Sublime Text 3's `subl` command to PATH:
export PATH=${PATH}:"/Applications/Sublime Text.app/Contents/SharedSupport/bin"

### Add handy-dandy notifier that uses terminal-notifier ( https://github.com/alloy/terminal-notifier/downloads ) 
export PATH=${PATH}:"/Applications/terminal-notifier.app/Contents/MacOS"

function when-done {
  cmd="$@"
  eval ${cmd}
  terminal-notifier -message "DONE: $?"
}

### Git autocomplete 
autoload -Uz compinit && compinit

### Mechanism to have project-specific bashrc stuff without polluting this one
export PROJECTSPECIFIC=""

if [ -n "$PROJECTSPECIFIC" ]; then
  source "$PROJECTSPECIFIC"
fi

# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle :compinstall filename '/Users/tkairi/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
setopt noautomenu

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/tkairi/.sdkman"
[[ -s "/Users/tkairi/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/tkairi/.sdkman/bin/sdkman-init.sh"
