export PS1='\u:\w \[\033[00;32m\]`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/[\ \\\\\1\ ]\ /`\[\033[37m\]$\[\033[00m\] '
### export Homebrew to PATH
export PATH=/usr/local/bin:$PATH

### Locale settings
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

### Useful alias

proxy="https_proxy=10.144.1.10:8080 http_proxy=10.144.1.10:8080"

alias gits="git status"
alias gitn="$proxy git"
alias hgn="$proxy hg"
alias search="grep -irn"
alias ls="ls -p"
alias wtf="ping 8.8.8.8"
alias reconn="networksetup -setairportpower en0 off && networksetup -setairportpower en0 on"
alias robot_clean="find . \( -name log.html -or -name report.html -or -name output.xml -or -name debug.log -or -name \"*-screenshot-*.png\" \) -exec rm -rf {} \;"

### needed for RVM

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*


### wrapper for virtualenv; either activate environment if such exists, otherwise create
function virtualize {
  path="$HOME/python-envs"

  if [[ -z "$1" ]]; then
    envs=`ls $path |/usr/bin/grep -v virtualenv* |tr '\n' ';'`
    echo "Please give environment name: $envs"
    return
  fi
  source $path/$1/bin/activate
}


### Overwrite `cd`. It does two things:
# - do RVM's magic (copied from the RVM source)
# - force Python interpreter to 32-bit for RIDE; undo that if not in RIDE's folder

function cd {

  # This is the slightly modified RVM override of cd function. Returns have been removed.
  # To re-enable "normal" overridden `cd`, delete this.
  if builtin cd "$@"; then
    [[ -n "${rvm_current_rvmrc:-}" && "$*" == "." ]] && rvm_current_rvmrc="" || true;
    __rvm_do_with_env_before;
    __rvm_project_rvmrc;
    __rvm_after_cd;
    __rvm_do_with_env_after;
   fi

  if [[ "`pwd`" = /Users/tkairi/Coding/RIDE** ]]; then
    export VERSIONER_PYTHON_PREFER_32_BIT=yes
    alias python="arch -i386 python"
    alias paver="arch -i386 paver"
  else
    export VERSIONER_PYTHON_PREFER_32_BIT=
    if [[ "`alias | grep python`" ]]; then
      unalias python 2>/dev/null
      unalias paver 2>/dev/null
    fi
  fi
}

### add Heroku tools to PATH
PATH="/usr/local/heroku/bin:$PATH"

### add default Nethack options
# "%?/=+!$
export NETHACKOPTIONS='color,autodig,character:Wizard,fruit:mango,lit_corridor,male,name:Tattoo,pettype:none,pickup_types:"%?/=+!$,pushweapon,race:elf,showexp,showscore,standout,time'


### add Jython to PATH
#export JYTHON_HOME='/Users/tkairi/jython2.7b1'
#export PATH=/Users/tkairi/jython2.7b1:/Users/tkairi/jython2.7b1/bin:$PATH
export JYTHON_HOME=/Users/tkairi/jython2.5.3
export PATH=/Users/tkairi/jython2.5.3:/Users/tkairi/jython2.5.3/bin:$PATH


### make new shell have a random word as it's title
WORD=`perl -MList::Util -e 'print List::Util::shuffle <>' /usr/share/dict/words |head -n1`
export PROMPT_COMMAND='echo -ne "\033]0;${WORD}\007"'

### add Skim's command-line utilities to PATH
export PATH=$PATH:/Applications/Skim.app/Contents/SharedSupport/

### add own installed stuff to PATH
export PATH=$PATH:$HOME/bin

### Rebind CTRL+w so it only deletes to last word separator instead of the whole word
stty werase undef
bind '\C-w:unix-filename-rubout'

### Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"


### Uses fswatch ( https://github.com/emcrisostomo/fswatch ) to check on files
function watch {
  fswatch="`which fswatch`"
  path="$1"
  shift
  cmd="$@"
  echo "Watching recursively: $path"
  echo
  $fswatch -or $path |xargs -n1 -I% sh -c "echo RUNNING COMMAND: $cmd; echo; $cmd"
}


### Add Sublime Text 3's `subl` command to PATH:
export PATH=$PATH:/Applications/Sublime\ Text.app/Contents/SharedSupport/bin

### Add handy-dandy notifier that uses terminal-notifier ( https://github.com/alloy/terminal-notifier/downloads ) 

function when-done {
  cmd="$@"
  $cmd
  terminal-notifier -message "DONE: $?"
}



### Git autocomplete ( http://code-worrier.com/blog/autocomplete-git/ )
if [ -f $HOME/confs/dotbashrc/git-completion.bash ]; then
  . $HOME/confs/dotbashrc/git-completion.bash
fi
