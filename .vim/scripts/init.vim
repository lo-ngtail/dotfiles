" Tiny vim
if 0 | endif

" Use plain vim
" when vim was invoked by 'sudo' command
" or, invoked as 'git difftool'
if exists('$SUDO_USER') || exists('$GIT_DIR')
  finish
endif

if &compatible
  set nocompatible
endif

let g:false = 0
let g:true = 1

augroup MyAutoCmd
  autocmd!
augroup END

" Base functions "{{{1
function! s:glob(from, pattern)
  return split(globpath(a:from, a:pattern), "[\r\n]")
endfunction

function! s:source(from, ...)
  let found = g:false
  for pattern in a:000
    for script in s:glob(a:from, pattern)
      execute 'source' escape(script, ' ')
      let found = g:true
    endfor
  endfor
  return found
endfunction

function! s:load(...) abort
  let base = expand($HOME.'/.vim/scripts')
  let found = g:true

  if len(a:000) > 0
    " Stop to load
    if index(a:000, g:false) != -1
      return g:false
    endif
    for file in a:000
      if !s:source(base, file)
        let found = s:source(base, '*[0-9]*_'.file)
      endif
    endfor
  else
    " Load all files starting with number
    let found = s:source(base, '*[0-9]*_*.vim')
  endif

  return found
endfunction
"}}}

" Init
if !s:load('env.vim')
  " Finish if loading env.vim is failed
  finish
endif

let g:env.vimrc.plugin_on = g:true

if g:env.is_starting
  " Necesary for lots of cool vim things
  " http://rbtnn.hateblo.jp/entry/2014/11/30/174749

  scriptencoding utf-8
  set runtimepath&

  " Check if there are plugins not to be installed
  augroup vimrc-check-plug
    autocmd!
    if g:env.vimrc.check_plug_update == g:true
      autocmd VimEnter * if !argc() | call g:plug.check_installation() |     endif
endif
  augroup END

  " Vim starting time
  if has('reltime')
    let g:startuptime = reltime()
    augroup vimrc-startuptime
      autocmd!
      autocmd VimEnter * let g:startuptime = reltime(g:startuptime) | redraw
            \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
    augroup END
  endif
endif

if s:load('plug.vim') " 各プラグインのインストール
  call s:load('custom.vim') " 各プラグインの設定
endif
call s:load('base.vim') " 警告とかエラーを出力する関数
call s:load('view.vim') " 色とか
call s:load('map.vim') " キーコンフィグとか
call s:load('option.vim') " vimのオプション設定

" Must be written at the last.  see :help 'secure'.
set secure

" __END__ {{{1
" vi:set ts=2 sw=2 sts=2:
" vim:fdt=substitute(getline(v\:foldstart),'\\(.\*\\){\\{3}','\\1',''):
" vim:fdm=marker expandtab fdc=3:
