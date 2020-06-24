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

### add Skim's command-line utilities to PATH
export PATH=${PATH}:"/Applications/Skim.app/Contents/SharedSupport/"

### add own installed stuff to PATH
export PATH=${PATH}:"$HOME/bin"

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
