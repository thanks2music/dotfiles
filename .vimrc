"-------------------------------------
" That's so Vim!
set nocompatible
"-------------------------------------

" Vars
let $TODAY = strftime('%Y%m%d')
let $DESKTOP = expand('~/desktop')

if has("win32") || has("win64")
  let $DOTVIM = expand('~/vimfiles')
else
  let $DOTVIM = expand('~/.vim')
endif

"-------------------------------------
" NeoBundle
" Plugin 追加: .vimrc に追加して、:NeoBundleInstall
" Plugin 削除: .vimrc から削除して、:NeoBundleClean
" Plugin 更新: :NeoBundleUpdate
filetype plugin indent off

" Required:
if has('vim_starting')
  set runtimepath+=~/dotfiles/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/dotfiles/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles:
"" Color scheme
NeoBundle "inkpot"
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'hail2u/h2u_colorscheme'
NeoBundle 'tomasr/molokai'
NeoBundle 'itchyny/landscape.vim'

"" Syntax
NeoBundle 'jquery'
NeoBundleLazy 'jelera/vim-javascript-syntax', {'autoload':{'filetypes':['javascript']}}
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'othree/html5.vim'
NeoBundle 'hallison/vim-markdown'
NeoBundle 'timcharper/textile.vim'
NeoBundle 'groenewege/vim-less'
NeoBundle 'wavded/vim-stylus'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'digitaltoad/vim-jade'
NeoBundle 'dmitry-ilyashevich/vim-typescript'

"" UI
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Sixeight/unite-grep'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vimshell.vim'
NeoBundle 'thinca/vim-qfreplace'
NeoBundle 'Shougo/vimproc', {
\ 'build' : {
\     'windows' : 'make -f make_mingw32.mak',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make -f make_mac.mak',
\     'unix' : 'make -f make_unix.mak',
\    },
\ }

"" Essential
NeoBundle 'mattn/webapi-vim'
"" Gist
NeoBundle 'mattn/gist-vim'
"" Indent
NeoBundle 'jiangmiao/simple-javascript-indenter'
NeoBundle 'nathanaelkane/vim-indent-guides'
"" Zen
NeoBundle 'mattn/emmet-vim'
"" Lint
NeoBundle 'scrooloose/syntastic'
"" Code
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'matchit.zip'
NeoBundle 'http://github.com/thinca/vim-poslist.git'
NeoBundle 'Townk/vim-autoclose'
"" Replace single and double quote
" NeoBundle 'tpope/vim-surround'
"" Operator
NeoBundle 'kana/vim-operator-user'
NeoBundle 'rhysd/vim-operator-surround'
"" Replace Zenkaku Hankaku

call neobundle#end()

filetype plugin indent on

" 未インストールプラグインが無いかチェック
"" Reload: :source $HOME/_vimrc
NeoBundleCheck

"-------------------------------------------------------------------------------
" カラースキーマ
syntax enable
set t_Co=256
autocmd ColorScheme * highlight LineNr ctermfg=7 ctermbg=239
autocmd ColorScheme * highlight Comment ctermfg=8
autocmd ColorScheme * highlight Visual ctermfg=54 ctermbg=129

colorscheme h2u_dark

if !has('gui_running')
  let g:solarized_termcolors=256
  let g:solarized_termtrans = 1
  let g:solarized_contrast = 'high'
  let g:solarized_visibility = 'high'
endif

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
nmap <Leader>, <Plug>NERDCommenterToggle
vmap <Leader>, <Plug>NERDCommenterToggle
"-------------------------------------------------------------------------------
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

" syntastic
"" :Errors エラー一覧表示
let g:syntastic_enable_signs = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_mode_map = { 'mode': 'active',
  \ 'active_filetypes': [],
  \ 'passive_filetypes': ['html'] }
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_coffee_coffeelint_args = '-f ~/.vim/coffeelint.json'
"" for objective-c
let g:syntastic_objc_check_header = 1
let g:syntastic_objc_auto_refresh_includes = 1
"" for TypeScript
let g:syntastic_typescript_checkers = ['tslint']
"" jQuery Syntax
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

" Gist
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_post_private = 1

" Vim Operator Surround
"" Operator Mapping
vmap <silent>sa <Plug>(operator-surround-append)
vmap <silent>sd <Plug>(operator-surround-delete)
vmap <silent>sr <Plug>(operator-surround-replace)

"------------------------------------------------------------------------------
" Neocomplete
"" TODO neocompleteが動かない...!?
if neobundle#is_installed('neocomplete')
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_camel_case_completion = 1
  let g:neocomplete#enable_underbar_completion = 1
  let g:neocomplete#enable_smart_case = 1
  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 3
  let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

  " Define dictionary.
  let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions',
    \ 'c' : $DOTVIM.'/dict/c-eglibc.dict',
    \ 'css' : $DOTVIM.'/dict/css.dict',
    \ 'scss' : $DOTVIM.'/dict/css.dict',
    \ 'objc' : $DOTVIM.'/dict/objectivec.dict',
    \ 'ruby' : $DOTVIM.'/dict/ruby.dict',
    \ 'perl' : $DOTVIM.'/dict/perl.dict',
    \ 'php' : $DOTVIM.'/dict/php.dict',
    \ 'javascript' : $DOTVIM.'/dict/javascript.dict',
    \ 'coffee' : $DOTVIM.'/dict/javascript.dict',
    \ 'actionscript' : $DOTVIM.'/dict/actionscript.dict'
    \ }

  " Define keyword.
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'

  " Plugin key-mappings.
  inoremap <expr><C-g> neocomplete#undo_completion()
  inoremap <expr><C-l> neocomplete#complete_common_string()

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return neocomplete#smart_close_popup() . "\<CR>"
    " For no inserting <CR> key.
    "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ neocomplete#start_manual_complete()
  function! s:check_back_space() "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction"}}}
  " dot: completion.
  " inoremap <expr> . pumvisible() ? neocomplete#smart_close_popup().".\<C-X>\<C-O>\<C-P>" : ".\<C-X>\<C-O>\<C-P>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y> neocomplete#close_popup()
  inoremap <expr><C-e> neocomplete#cancel_popup()
  " Close popup by <Space>.
  inoremap <expr><Space> pumvisible() ? neocomplete#close_popup()."\<Space>" : "\<Space>"
endif

" Emmet
"" スニペット定義
let g:user_emmet_settings = { 
\    'lang' : 'ja',
\    'javascript' : { 
\        'snippets'   : { 
\            'jq' : "\\$(function() {\n\t${cursor}${child}\n});"
\        }   
\    }   
\}

" Neosnippet
"" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

"" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory=$DOTVIM.'/snippets'

"" Plugin key-mappings.
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

imap <expr><CR> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: "\<CR>"
smap <expr><CR> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: "\<CR>"

"" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
