" ============================================================================
" File:        plugin/thematic.vim
" Description: script for vim-thematic plugin
" Maintainer:  Reed Esau <github.com/reedes>
" Last Change: December 30, 2013
" License:     The MIT License (MIT)
" ============================================================================

if exists('g:loaded_thematic') || &cp | finish | endif
let g:loaded_thematic = 1

" Save 'cpoptions' and set Vim default to enable line continuations.
let s:save_cpo = &cpo
set cpo&vim

" Preserve original settings

let g:thematic#original = {}
let g:thematic#original.laststatus = &laststatus
let g:thematic#original.ruler = &ruler
if has('fullscreen')
  try
    call thematic#gui#initFullscreen()
  catch /E117/
    " This is happening during BundleUpdate in Vundle on first load.
    " Unsure how best to fix.
  endtry
endif

" Defaults
if !exists('g:thematic#defaults')
  let g:thematic#defaults = {}
endif
if !exists('g:thematic#themes')
  let g:thematic#themes = {
  \ 'blue'       : { 'sign-column-color-fix': 1,
  \                  'fold-column-color-mute': 1,
  \                },
  \ 'desert'     : { 'sign-column-color-fix': 1,
  \                  'fold-column-color-mute': 1,
  \                },
  \ 'peachpuff'  : {
  \                },
  \ 'slate'      : {
  \                },
  \ }
endif

function! <SID>chooseTheme(ArgLead, CmdLine, CursorPos)
  return filter(sort(keys(g:thematic#themes)),
              \ "stridx(v:val,'".a:ArgLead."') == 0")
endfunction

" Commands

" Thematic {theme_name}
command -nargs=1
      \ -complete=customlist,<SID>chooseTheme
      \ Thematic
      \ call thematic#init(<f-args>)

command -nargs=0 ThematicFirst    call thematic#init('#first')
command -nargs=0 ThematicNext     call thematic#init('#next')
command -nargs=0 ThematicPrevious call thematic#init('#previous')
command -nargs=0 ThematicRandom   call thematic#init('#random')
command -nargs=0 ThematicOriginal call thematic#init('#original')

" Plugin mappings

" TODO support resizing while in virtual mode
noremap <silent> <Plug>ThematicNarrow :ThematicNarrow<CR>
noremap <silent> <Plug>ThematicWiden  :ThematicWiden<CR>

" Create mappings for the `Thematic` commands
noremap <silent> <Plug>ThematicFirst    :ThematicFirst<CR>
noremap <silent> <Plug>ThematicNext     :ThematicNext<CR>
noremap <silent> <Plug>ThematicPrevious :ThematicPrevious<CR>
noremap <silent> <Plug>ThematicRandom   :ThematicRandom<CR>
noremap <silent> <Plug>ThematicOriginal :ThematicOriginal<CR>

if exists('g:thematic#theme_name')
  " support an initial theme when starting Vim
  augroup thematic_startup
    autocmd!
    autocmd VimEnter * call thematic#init(g:thematic#theme_name)
  augroup END
else
  let g:thematic#theme_name = ''
endif

let &cpo = s:save_cpo
unlet s:save_cpo
" vim:ts=2:sw=2:sts=2
