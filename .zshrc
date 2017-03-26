# users generic .zshrc file for zsh(1)

## Environment variable configuration
# LANG
export LANG=ja_JP.UTF-8

# 環境変数
PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
export MANPATH=/usr/local/share/man:/usr/local/man:/usr/share/man

# OTHERS
export BUNDLER_EDITOR=emacs

## Default shell configuration
# set prompt
autoload colors; colors

case ${UID} in
 0)
     PROMPT="%B%{${fg[magenta]}%}%/ #%{${reset_color}%}%b "
     PROMPT2="%B%{${fg[magenta]}%}%_ #%{${reset_color}%}%b "
     SPROMPT="%B%{${fg[magenta]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
     [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
         PROMPT="%{${fg[red]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
     ;;
 *)
     PROMPT="%{${fg[cyan]}%}%/ %%%{${reset_color}%} "
     PROMPT2="%{${fg[cyan]}%}%_ %%%{${reset_color}%} "
     SPROMPT="%{${fg[cyan]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
     [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
         PROMPT="%{${fg[red]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
     ;;
esac

# vcs
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats '[%s: %b]'
zstyle ':vcs_info:*' actionformats '[%s: %b|%a]'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

function _update_vcs_info_msg() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg
RPROMPT="%1(v|%F{yellow}%1v%f|)"

# git stash count
# http://qiita.com/Cside_/items/13f85c11d3d0aa35d7ef

# auto change directory
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
setopt auto_pushd

# command correct edition before each completion attempt
setopt correct

# compacked complete list display
setopt list_packed

# no remove postfix slash of command line
setopt noautoremoveslash

# no beep sound when complete list displayed
setopt nolistbeep

## Keybind configuration
bindkey -e

# historical backward/forward search with linehead string binded to ^P/^N
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

bindkey "^[f" emacs-forward-word
bindkey "^[b" emacs-backward-word
export WORDCHARS=""

autoload smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
zstyle :insert-last-word match \
  '*([^[:space:]][[:alpha:]/\\]|[[:alpha:]/\\][^[:space:]])*'
bindkey '^]' insert-last-word

# quote previous word in single or double quote
autoload -U modify-current-argument
_quote-previous-word-in-single() {
    modify-current-argument '${(qq)${(Q)ARG}}'
    zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-single
bindkey '^[s' _quote-previous-word-in-single

_quote-previous-word-in-double() {
    modify-current-argument '${(qqq)${(Q)ARG}}'
    zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-double
bindkey '^[d' _quote-previous-word-in-double

## Command history configuration
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data
setopt EXTENDED_HISTORY

## Completion configuration
fpath=(~/.zsh/functions/Completion ${fpath})
autoload -U compinit; compinit

## zsh editor
autoload zed

## zsh rename
autoload zmv

## Alias configuration
setopt complete_aliases

case "${OSTYPE}" in
freebsd*|darwin*)
    alias ls="ls -G -w"
    ;;
linux*)
    alias ls="ls -a --color"
    ;;
esac

alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"

alias du="du -h"
alias df="df -h"

alias su="su -l"
alias sl="sl -ae"

# Rails
alias r="rails"

# Node.js
alias nb="nodebrew"

# Middleman
alias m="middleman"

# zsh
alias reload='source ~/.zshrc && exec $SHELL'

# vi
alias v='vi'
alias vi='vim'
alias vimrc='vi ~/.vimrc'
alias zshrc='vi ~/.zshrc'
alias tmuxrc='vi ~/.tmux.conf'
alias lv='lv -c'

#git
alias g='git'
alias ga='git add -A'
alias gg='git grep'
alias s='git status -s'
alias d='git diff'
alias gm= 'git co master'
alias gi='git'
alias gp='git pull --rebase'
alias gitrc='vi ~/.gitconfig'

#tmux
alias t='tmux'

#bundler
alias be='bundle exec'
alias b='bundle'

# compass
alias cw='compass watch'
# sass
alias sw='sass --watch scss:css'

#guard
alias mg='bundle exec guard -g ui'

# Composer
alias composerupdate='/usr/local/Cellar/composer/1.0.0-alpha9/libexec/composer.phar self-update'

# PostgreSQL
alias pss='pg_ctl -l /usr/local/var/postgres/server.log start'
alias psd='pg_ctl stop -s -m fast'

# MySQL
## for MAMP
alias mampsql='cd /Applications/MAMP/Library/bin && ./mysql -u root -p'

# returnでlsとgit statusを表示
function do_enter() {
  if [ -n "$BUFFER" ]; then
    zle accept-line
    return 0
  fi
  echo
  ls
  # おすすめ
  # ls_abbrev
  if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
    echo
    echo -e "\e[0;33m--- git status ---\e[0m"
    git status -sb
  fi
  zle reset-prompt
  return 0
}
zle -N do_enter
bindkey '^m' do_enter

# ディレクトリ移動後にもls表示
function chpwd() { ls -1 }

# iTerm2のタブ名を変更する
function title {
  echo -ne "\033]0;"$*"\007"
}

# gitで差分のzipを作る
function git_diff_archive() {
  local diff=""
  local h="HEAD"
  if [ $# -eq 1 ]; then
    if expr "$1" : '[0-9]*$' > /dev/null ; then
      diff="HEAD HEAD~${1}"
    else
      diff="HEAD ${1}"
    fi
  elif [ $# -eq 2 ]; then
    diff="${1} ${2}"
    h=$1
  fi
  if [ "$diff" != "" ]; then
    diff="git diff --diff-filter=D --name-only ${diff}"
  fi
  git archive --format=zip --prefix=root/ $h `eval $diff` -o archive.zip
}

# tmux auto start
# http://d.hatena.ne.jp/tyru/20100828/run_tmux_or_screen_at_shell_startup
is_screen_running() {
    # tscreen also uses this varariable.
    [ ! -z "$WINDOW" ]
}
is_tmux_runnning() {
    [ ! -z "$TMUX" ]
}
is_screen_or_tmux_running() {
    is_screen_running || is_tmux_runnning
}
shell_has_started_interactively() {
    [ ! -z "$PS1" ]
}
resolve_alias() {
    cmd="$1"
    while \
        whence "$cmd" >/dev/null 2>/dev/null \
        && [ "$(whence "$cmd")" != "$cmd" ]
    do
        cmd=$(whence "$cmd")
    done
    echo "$cmd"
}

if ! is_screen_or_tmux_running && shell_has_started_interactively; then
    for cmd in tmux tscreen screen; do
        if whence $cmd >/dev/null 2>/dev/null; then
            $(resolve_alias "$cmd")
            break
        fi
    done
fi

## Kaoriya Vim
# if [ -d $HOME/Applications/MacVim.app ]; then
#   export EDITOR=$HOME/Applications/MacVim.app/Contents/MacOS/Vim
#   alias vi='$EDITOR "$@"'
#   alias vim='$EDITOR "$@"'
#   alias gvim='open -a $HOME/Applications/MacVim.app "$@"'
# fi

# Vim
# export PATH="/usr/local/bin:$PATH"

# Brewfile
export HOMEBREW_BREWFILE=~/dotfiles/.brewfile


# Add RVM to PATH for scripting

# Android SDK
export PATH=/Applications/AndroidSDK/sdk/platform-tools:$PATH

# Export path for nodebrew
if [ -d $HOME/.nodebrew ]; then
  export PATH=$HOME/.nodebrew/current/bin:$PATH
  export NODE_PATH=$HOME/.nodebrew/current/lib/node_modules
fi

# zsh-highlighting
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# Rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# MAMPのpath通してコマンドラインで操作
export PATH=$PATH:/Applications/MAMP/Library/bin

# for WP-CLI
export WP_CLI_PHP=/Applications/MAMP/bin/php/php7.0.0/bin/php
export PATH="$MAMP_PHP:$PATH"

# homebrew-php
# export PATH="$(brew --prefix homebrew/php/php56)/bin:$PATH"

# for Work
export MIRRORZ_PATH=$HOME/work/mirrorz/admin/mirrorz
export JAVA_HOME=`/usr/libexec/java_home`
export CLASSPATH_PREFIX=$HOME/work/mirrorz/app/mirrorz_db_migrations/drivers/mysql-connector-java-5.1.25-bin.jar
# export MYBATIS_BIN=/usr/lib/mysql-connector-java-5.1.25-bin.jar

# PostgreSQL
export PGDATA=/usr/local/var/postgres

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### /usr/local/bin を優先させる
export PATH="/usr/local/bin:$PATH"
# pyenv for python
export PYENV_ROOT=${HOME}/.pyenv
if [ -d "${PYENV_ROOT}" ]; then
    export PATH=${PYENV_ROOT}/bin:$PATH
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi
# export PATH=/usr/local/bin:$PATH
# Powerline
. ${HOME}/.pyenv/versions/3.5.2/lib/python3.5/site-packages/powerline/bindings/zsh/powerline.zsh

# tmux-powerline
# PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'


# PATH の重複を消す
typeset -U path PATH

