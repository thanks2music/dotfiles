"-------------------------------------------------------------------------------
set nocompatible    " vimですよ
"-------------------------------------------------------------------------------
" 変数定義
let $TODAY = strftime('%Y%m%d')
let $DESKTOP = expand('~/desktop')

if has("win32") || has("win64")
  let $DOTVIM = expand('~/vimfiles')
else
  let $DOTVIM = expand('~/.vim')
endif
"-------------------------------------------------------------------------------
" Vundle
" $ git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
" インストール: .vimrcに追加して、BundleInstall
" アンインストール: .vimrcから削除して、BundleClean
filetype off                   " required!
set rtp+=$DOTVIM/bundle/vundle/
call vundle#rc('$DOTVIM/bundle/')
" Vundle
Bundle 'gmarik/vundle'
" Syntax highlight
Bundle 'jquery'
Bundle 'jelera/vim-javascript-syntax'
Bundle 'kchmck/vim-coffee-script'
Bundle 'othree/html5.vim'
Bundle 'hallison/vim-markdown'
Bundle 'timcharper/textile.vim'
Bundle 'groenewege/vim-less'
Bundle 'wavded/vim-stylus'
Bundle 'hail2u/vim-css3-syntax'
Bundle 'digitaltoad/vim-jade'
Bundle 'dmitry-ilyashevich/vim-typescript'
" Indent
Bundle 'jiangmiao/simple-javascript-indenter'
" Color scheme
Bundle "inkpot"
Bundle 'altercation/vim-colors-solarized'
Bundle 'hail2u/h2u_colorscheme'
Bundle 'tomasr/molokai'
" Plugins
" Bundle 'YankRing.vim'
" Lint
Bundle 'scrooloose/syntastic'
Bundle 'http://github.com/thinca/vim-poslist.git'
Bundle 'Shougo/neocomplcache'
Bundle 'violetyk/neocomplete-php.vim'
Bundle 'matchit.zip'
Bundle 'http://github.com/scrooloose/nerdcommenter.git'
Bundle 'https://github.com/tpope/vim-surround.git'
Bundle 'Shougo/unite.vim'
Bundle 'basyura/jslint.vim'
" Bundle 'rails.vim'
Bundle 'mattn/emmet-vim'
Bundle 'scrooloose/nerdtree'
" Gitを便利に使う
Bundle 'tpope/vim-fugitive'
" コメントON/OFFを手軽に実行
Bundle 'tomtom/tcomment_vim'
" シングルクオートとダブルクオートの入れ替え等
Bundle 'tpope/vim-surround'
" Bundle 'vim-scripts/TabBar'
" " Viewer
" Bundle 'http://github.com/thinca/vim-quickrun.git'
" Bundle 'kannokanno/previm'
" Bundle 'open-browser.vim'

" インデントに色を付けて見やすくする
Bundle 'nathanaelkane/vim-indent-guides'
" インデントに色を付けて見やすくする

filetype plugin indent on      " required!
"-------------------------------------------------------------------------------
" カラースキーマ
syntax enable
set t_Co=256
" autocmd ColorScheme * highlight Comment ctermfg=245 guifg=#999999
" highlight LineNr ctermfg=darkyellow
autocmd ColorScheme * highlight Comment ctermfg=0
" 239
autocmd ColorScheme * highlight LineNr ctermfg=7 ctermbg=239

" hi LineNr ctermfg=white ctermbg=gray
colorscheme h2u_dark

"-------------------------------------------------------------------------------
" ステータスライン
set laststatus=2    " 常にステータスラインを表示
set statusline=%<%F\ %r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%4v(ASCII=%03.3b,HEX=%02.2B)\ %l/%L(%P)%m
"-------------------------------------------------------------------------------
" 基本設定
let mapleader = "," " キーマップリーダー
set scrolloff=5     " スクロール時の余白確保
set nobackup        " バックアップ取らない
set autoread        " 他で書き換えられたら自動で読み直す
set noswapfile      " スワップファイル作らない
set noundofile      " undofileを作らない
set hidden          " 編集中でも他のファイルを開けるようにする
set backspace=indent,eol,start  " バックスペースでなんでも消せるように
set formatoptions=lmoq  " テキスト整形オプション，マルチバイト系を追加
set vb t_vb=        " ビープをならさない
set browsedir=buffer    " Exploreの初期ディレクトリ
set whichwrap=b,s,h,l,<,>,[,]   " カーソルを行頭、行末で止まらないようにする
set showcmd         " コマンドをステータス行に表示
set cmdheight=2   " 画面最下部のメッセージ表示欄の行数
set magic           " 正規表現に使われる記号を有効にする
" set title
"-------------------------------------------------------------------------------
" 表示
set showcmd         " 入力中のコマンドを表示
set number          " 行番号表示
set numberwidth=4   " 行番号の幅
set ruler           " ルーラーの表示
set list            " 不可視文字表示
set listchars=tab:>.,trail:_,extends:>,precedes:<   " 不可視文字の表示形式
set display=uhex    " 印字不可能文字を16進数で表示
" 全角スペースをハイライト
if has("syntax")
  syntax on
  function! ActivateInvisibleIndicator()
    syntax match InvisibleJISX0208Space "　" display containedin=ALL
    highlight InvisibleJISX0208Space term=underline ctermbg=Cyan guibg=Cyan
"    syntax match InvisibleTrailedSpace "[ \t]\+$" display containedin=ALL
"    highlight InvisibleTrailedSpace term=underline ctermbg=Red guibg=Red
"    syntax match InvisibleTab "\t" display containedin=ALL
"    highlight InvisibleTab term=underline ctermbg=DarkCyan guibg=DarkCyan
  endf
  augroup invisible
    autocmd! invisible
    autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
  augroup END
endif
" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END
" カーソルライン
" set cursorcolumn
"-------------------------------------------------------------------------------
" インデント
set autoindent
set smartindent
set cindent
" softtabstopはTabキー押し下げ時の挿入される空白の量，
" 0の場合はtabstopと同じ，BSにも影響する
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
" JavaScript Indenter
"-------------------------------------------------------------------------------
" 補完・履歴
set wildmenu            " コマンド補完を強化
set wildchar=<tab>      " コマンド補完を開始するキー
set wildmode=list:full  " リスト表示，最長マッチ
set history=1000        " コマンド・検索パターンの履歴数
set complete+=k         " 補完に辞書ファイル追加
"-------------------------------------------------------------------------------
" 検索設定
set nowrapscan " 最後まで検索したら先頭へ戻らない
set ignorecase " 大文字小文字無視
set smartcase  " 大文字ではじめたら大文字小文字無視しない
set incsearch  " インクリメンタルサーチ
set hlsearch   " 検索文字をハイライト
set showmatch  " 対応する括弧をハイライト
"選択した文字列を検索
vnoremap <silent> // y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
"選択した文字列を置換
vnoremap /r "xy:%s/<C-R>=escape(@x, '\\/.*$^~[]')<CR>/<C-R>=escape(@x, '\\/.*$^~[]')<CR>/gc<Left><Left><Left>
"-------------------------------------------------------------------------------
" エンコーディング関連
" 改行文字
set ffs=unix,dos,mac
" デフォルトエンコーディング
let $LANG='ja_JP.UTF-8'
set encoding=utf-8
set fileencoding=utf-8
if has('win32') && has('kaoriya')
  set ambiwidth=auto
else
  set ambiwidth=double
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213,euc-jp'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
endif
if has('win32unix')
  set termencoding=utf-8
endif
"-------------------------------------------------------------------------------
" キーバインド関係
" 行単位で移動(1行が長い場合に便利)
nnoremap j gj
nnoremap k gk
" バッファ周り
nmap <silent> <C-Right> :bnext<CR>
nmap <silent> <C-Left> :bprevious<CR>
nmap <silent> <C-c> :bw<CR>
nmap <silent> <C-b> :b#<CR>
"nmap <silent> <C-l> :ls<CR>
" 検索などで飛んだらそこを真ん中に
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz
nmap G Gzz
" その他キーバインド
nmap <C-r> <C-r>
imap <C-r> <C-o><C-r>
vmap <C-r> <Esc><C-r>
"usキーボードで使いやすく
nmap ; :
" 画面分割移動を簡単に
map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l
map <C-TAB> <C-W>w
" Explore
"nmap <silent> <C-e> :Explore<CR>
"-------------------------------------------------------------------------------
" ユーザ定義コマンド
command! Vsp :set columns=176|vsp
command! RW :set columns=88
command! ResetWidth :set columns=88
command! Cd :cd %:h
" エンコード指定してファイルを開く
command! -nargs=1 Reload :call s:Reload(<f-args>)
function! s:Reload(enc)
  e ++enc=a:enc
endfunction
" 改行コードをLF、エンコーディングをutf-8の状態にする
command! SD :call s:SetDefault()
command! SetDefault :call s:SetDefault()
function! s:SetDefault()
  set ff=unix
  set fenc=utf-8
  try
    %s///g
  catch
  endtry
endfunction
" ソース編集中に開いているファイルを実行する
function! s:Exec()
  exe "!" . &ft . " %"
:endfunction
command! Exec call <SID>Exec()
map <silent> <C-F9> :call <SID>Exec()<CR>
" Python実行
if has('python')
  python import vim
  command Py python exec('\n'.join(vim.current.buffer))
endif
"-------------------------------------------------------------------------------
" matchit.vim
" % で対応するフレーズに移動
let b:match_words="{{t:{{/t}}"
"-------------------------------------------------------------------------------
" nerd_commenter.vim
let NERDSpaceDelims = 1
nmap ,, <Plug>NERDCommenterToggle
vmap ,, <Plug>NERDCommenterToggle
nmap ,9 <Plug>NERDCommenterToEOL
vmap ,s <Plug>NERDCommenterSexy
"-------------------------------------------------------------------------------
" neocomplcache.vim
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_auto_completion_start_length = 2
let g:neocomplcache_min_syntax_length = 2
let g:neocomplcache_min_keyword_length = 2
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_underbar_completion = 1

" 前回行われた補完をキャンセルします
inoremap <expr><C-g> neocomplcache#undo_completion()
" 補完候補のなかから、共通する部分を補完します
inoremap <expr><C-l> neocomplcache#complete_common_string()
" 改行で補完ウィンドウを閉じる
inoremap <expr><CR> neocomplcache#smart_close_popup() . "\<CR>"
"tabで補完候補の選択を行う
inoremap <expr><TAB> pumvisible() ? "\<Down>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"
" <C-h>や<BS>を押したときに確実にポップアップを削除します
inoremap <expr><C-h> neocomplcache#smart_close_popup().”\<C-h>”
" 現在選択している候補を確定します
inoremap <expr><C-y> neocomplcache#close_popup()
" 現在選択している候補をキャンセルし、ポップアップを閉じます
inoremap <expr><C-e> neocomplcache#cancel_popup()

" neocomplcache phpの設定
let g:neocomplete_php_locale = 'ja'

" 辞書
let g:neocomplcache_dictionary_filetype_lists = {
  \ 'default' : '',
  \ 'c' : $DOTVIM.'/dict/c-eglibc.dict',
  \ 'objc' : $DOTVIM.'/dict/objectivec.dict',
  \ 'ruby' : $DOTVIM.'/dict/ruby.dict',
  \ 'perl' : $DOTVIM.'/dict/perl.dict',
  \ 'css' : $DOTVIM.'/dict/css.dict',
  \ 'javascript' : $DOTVIM.'/dict/javascript.dict',
  \ 'coffee' : $DOTVIM.'/dict/javascript.dict',
  \ 'actionscript' : $DOTVIM.'/dict/actionscript.dict'
  \ }

autocmd FileType php :set dictionary=~/.vim/dict/vim-dict-wordpress/*.dict
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType coffee setlocal omnifunc=jscomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType cpp set omnifunc=cppcomplete#Complete
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType ruby,eruby setlocal omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif

" let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"------------------------------------------------------------------------------
" ユーティリティ
" 現在開いているファイルのある場所に常にcdする
" au BufEnter * exec ":lcd " . expand("%:p:h")
" 開いたファイル先を自動的にカレントディレクトリに設定
" set autochdir
" ヘルプを翻訳版に変更

set helplang=ja,en
" タグファイル設定
if has("win32") || has("win64")
  set tags=$DOTVIM/mytags_win
else
  set tags=$DOTVIM/mytags
endif
"入力モード時、ステータスラインのカラーを変更
augroup InsertHook
autocmd!
autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END
" Windowsバックスラッシュ対策 Vundleを使っているのでコメントアウト
"set shellslash
" Windowsクリップボードを使用
set clipboard=unnamed

"-------------------------------------------------------------------------------
" unite.vim
let g:unite_enable_start_insert = 1
let g:unite_update_time = 10
" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" カレントディレクトリ一覧
nnoremap <silent> ,ud :<C-u>UniteWithCurrentDir file<CR>
" バッファのディレクトリ一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 再帰的ファイル一覧
nnoremap <silent> ,uu :<C-u>Unite file_rec/async<CR>
" grep
nnoremap ,ug :Unite grep::-iHRn<CR>/*

" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q

"-------------------------------------------------------------------------------
" ZenCoding.vim
let g:user_zen_settings = {
\  'indentation':'  ',
\}

" Closure Linter
" autocmd FileType javascript noremap <buffer> <up> :<C-u>!/usr/local/bin/gjslint %<cr>
" autocmd FileType javascript :compiler gjslint
" autocmd QuickfixCmdPost make copen

" syntastic
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_javascript_checker = 'jshint'

" jQuery Syntax
au BufRead,BufNewFile *.js set ft=javascript syntax=jquery


" quickrun
let g:quickrun_config = {}
let g:quickrun_config.markdown = {
    \ 'outputter' : 'null',
    \ 'command'   : 'open',
    \ 'cmdopt'    : '-a',
    \ 'args'      : 'Marked',
    \ 'exec'      : '%c %o %a %s',
    \ }

" open browser
nmap <Leader>o <Plug>(openbrowser-open)
vmap <Leader>o <Plug>(openbrowser-open)
" Google it
nnoremap <Leader>g :<C-u>OpenBrowserSearch<Space><C-r><C-w><Enter>

" previm
let g:previm_open_cmd = 'open -a Safari'

" 全角記号バグを直す
set ambiwidth=double

" vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup = 1

" Vim CSS3 Fix
augroup VimCSS3Syntax
  autocmd!

  autocmd FileType css setlocal iskeyword+=-
augroup END
