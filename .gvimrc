﻿" フォント設定:
if has("win32") || has("win64")
  set guifont=VL_Gothic:h13
elseif has("macunix")
  set guifont=源ノ角ゴシック\ Code\ JP\ Light:h13
else
  set guifont=VL\ ゴシック\ 12
endif

" 色テーマ
colorscheme hybrid " (GUI使用時)

" Windows用キーマップを有効にする
"source $VIMRUNTIME/mswin.vim

" ビジュアル選択(D&D他)を自動的にクリップボードへ (:help guioptions_a)
"set guioptions+=a

" ウインドウの幅
set columns=88

" ウインドウの高さ
set lines=34

" 半透明にする
set transparency=20
