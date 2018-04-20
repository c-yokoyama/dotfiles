"--------------------
"" Basic Setting
"--------------------

" -----文字コード-----
set encoding=utf-8
scriptencoding utf-8
" 保存時の文字コード
set fileencoding=utf-8 
" 読み込み時の文字コードの自動判別. 左側が優先される
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
" 改行コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac 
"  □や○文字が崩れる問題を解決
set ambiwidth=double 

" -----Tab-----
" タブ入力を複数の空白入力に置き換える
set expandtab
" 画面上でタブ文字が占める幅
set tabstop=4 
" 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set softtabstop=4
" 改行時に前の行のインデントを継続する 
set autoindent 
" 改行時に前の行の構文をチェックし次の行のインデントを増減する
set smartindent 
 " smartindentで増減する幅
set shiftwidth=4 

"バックアップファイルのディレクトリを指定する
set backupdir=$HOME/.vimbackup
"スワップファイル用のディレクトリを指定する
set directory=$HOME/.vimbackup

" -----Search-----
set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch " 検索結果をハイライト
" ESCキー2度押しでハイライトの切り替え
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>

"クリップボードをWindowsと連携する
set clipboard=unnamed
"vi互換をオフする
set nocompatible
"変更中のファイルでも、保存しないで他のファイルを表示する
set hidden

"行番号を表示する
set number
set cursorline " カーソルラインをハイライト

"閉括弧が入力された時、対応する括弧を強調する
set showmatch

" grep検索を設定する
set grepformat=%f:%l:%m,%f:%l%m,%f\ \ %l%m,%f
set grepprg=grep\ -nh

" vimgrepやgrep した際に、cwindowしてしまう
autocmd QuickFixCmdPost *grep* cwindow

set wildmenu " コマンドモードの補完
set history=5000 " 保存するコマンド履歴の数

" 全角スペースの表示
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkGray gui=reverse guifg=DarkGray
endfunction
if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        "ZenkakuSpace をカラーファイルで設定するなら、
        "次の行をコメントアウト
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif

" マウスの有効化
if has('mouse')
    set mouse=a
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
endif

" -----------------
"  NeoBundle 
" -----------------
" NeoBundle がインストールされていない時 or
" プラグインの初期化に失敗した時の処理
function! s:WithoutBundles()
  colorscheme desert
  " Please write what you want to do.
endfunction

" NeoBundle よるプラグインのロードと各プラグインの初期化
function! s:LoadBundles()
  " 読み込むプラグインの指定
  NeoBundle 'Shougo/neobundle.vim'
  NeoBundle 'Shougo/unite.vim'
  NeoBundle 'Shougo/vimfiler.vim'
  " ステータスラインの表示内容強化
  NeoBundle 'itchyny/lightline.vim'
  " Python plugin
  NeoBundle 'davidhalter/jedi-vim'
 
  " ###読み込んだプラグインの設定###
  "-------------------------------------------------
  " ステータスラインの設定
  "-------------------------------------------------
  set laststatus=2 " ステータスラインを常に表示
  set showmode " 現在のモードを表示
  set showcmd " 打ったコマンドをステータスラインの下に表示
  set ruler " ステータスラインの右側にカーソルの現在位置を表示する
endfunction

" NeoBundle がインストールされているなら LoadBundles() を呼び出す
" そうでないなら WithoutBundles() を呼び出す
function! s:InitNeoBundle()
  if isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
    filetype plugin indent off
    if has('vim_starting')
      set runtimepath+=~/.vim/bundle/neobundle.vim/
    endif
    try
      call neobundle#begin(expand('~/.vim/bundle/'))
      call s:LoadBundles()
    catch
      call s:WithoutBundles()
    endtry 
  else
    call s:WithoutBundles()
  endif
	
  NeoBundleCheck
  call neobundle#end()
  filetype indent plugin on
  syntax on
endfunction

call s:InitNeoBundle()

" ----------------------
" カラースキーマを設定
" ----------------------
colorscheme molokai
syntax on
let g:molokai_original = 1
let g:rehash256 = 1
set background=dark
hi LineNr ctermbg=111
" Set CommentColor
hi Comment ctermfg=111

" docstringは表示しない
autocmd FileType python setlocal completeopt-=preview
set clipboard=unnamed,autoselect


