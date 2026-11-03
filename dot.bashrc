# Added by Kiro CLI
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) export PATH="${PATH:+$PATH:}$HOME/.local/bin" ;; esac
# asdf
## asdf by Brew
if [ -e $BREW_PREFIX/opt/asdf/libexec/asdf.sh ]; then
  . $BREW_PREFIX/opt/asdf/libexec/asdf.sh
fi

# Node.js
# NOTE: volta の残骸を削除した。コマンド・~/.volta・Brewfile すべて不在で、
#       不在ディレクトリを PATH に無条件 prepend していた（コメント自身も
#       「使っていない、後で消す」と書いていた）。

# VS Code
[[ "$TERM_PROGRAM" == "vscode" ]] && type code > /dev/null 2>&1 && . "$(code --locate-shell-integration-path bash)"

# Aliases
alias ll='ls -la'
alias la='ls -A'
alias g='git'
alias ga='git add -A'
alias gg='git grep'
alias gs='git status'
alias st='git status -s'
alias gl='git log --oneline --graph --decorate'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull --rebase'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'

