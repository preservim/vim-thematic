" ============================================================================
" File:        plugin/gui.vim
" Description: script for vim-thematic-gui plugin
" Maintainer:  Reed Esau <github.com/reedes>
" Last Change: December 30, 2013
" License:     The MIT License (MIT)
" ============================================================================

if exists('g:loaded_thematic_gui') || &cp | finish | endif
let g:loaded_thematic_gui = 1

" Save 'cpoptions' and set Vim default to enable line continuations.
let s:save_cpo = &cpo
set cpo&vim

function! thematic#gui#init(...) abort
  let l:th = a:0 ? a:1 : {}
  call thematic#gui#setFont(l:th)
  call thematic#gui#setTransparency(l:th)
  call thematic#gui#setLinespace(l:th)
  call thematic#gui#setFullscreen(l:th)
  call thematic#gui#setColumnsAndLines(l:th)
endfunction

function! thematic#gui#initFullscreen() abort
  " Take control of fullscreen behavior from Vim, specifically to
  " override its default behavior of maximizing columns and lines
  " in fullscreen Vim.
  if has('fullscreen')
    let l:fuopts = split(&fuoptions, ',')
    if index(l:fuopts, 'maxvert') != -1
      let g:thematic#original.maxvert = 1
      " NOTE removing maxvert results in a screen redraw problem
      "      if Ctrl+Command+F hit before switching themes,
      "      so we'll remove it here.
      "set fuoptions-=maxvert
    endif
    if index(l:fuopts, 'maxhorz') != -1
      let g:thematic#original.maxhorz = 1
      set fuoptions-=maxhorz
    endif
  endif
endfunction

command -nargs=0 ThematicNarrow call thematic#gui#adjustColumns(-5)
command -nargs=0 ThematicWiden  call thematic#gui#adjustColumns(5)

let &cpo = s:save_cpo
unlet s:save_cpo
" vim:ts=2:sw=2:sts=2
