# Added by Kiro CLI
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) export PATH="${PATH:+$PATH:}$HOME/.local/bin" ;; esac
# .bashrcを優先的に読み込ます
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

