" ============================================================================
" File:        autoload/gui.vim
" Description: autoload script for vim-thematic-gui plugin
" Maintainer:  Reed Esau <github.com/reedes>
" Last Change: December 30, 2013
" License:     The MIT License (MIT)
" ============================================================================

" Credit for some font regex/functions:
"   https://github.com/drmikehenry/vim-fontsize

if exists("autoloaded_thematic_gui") | finish | endif
let autoloaded_thematic_gui = 1

" # FONT REGEXES
" Regex values for each platform split guifont into three
" sections (\1, \2, and \3 in capturing parentheses):
" - prefix
" - size (possibly fractional)
" - suffix (possibly including extra fonts after commas)

if has("gui_macvim")
  " gui_macvim: Courier\ New:h11
  let s:regex = '\(.\{-}\):h\(\d\+\)'
elseif has("gui_gtk2")
  " gui_gtk2: Courier\ New\ 11
  let s:regex = '\(.\{-} \)\(\d\+\)\(.*\)'
elseif has("gui_photon")
  " gui_photon: Courier\ New:s11
  let s:regex = '\(.\{-}\):s\(\d\+\)\(.*\)'
elseif has("gui_kde")
  " gui_kde: Courier\ New/11/-1/5/50/0/0/0/1/0
  let s:regex = '\(.\{-}\)\/\(\d\+\)\(.*\)'
"elseif has("x11")
"  " gui_x11: -*-courier-medium-r-normal-*-*-180-*-*-m-*-*
"  let s:regex = '\(.\{-}-\)\(\d\+\)\(.*\)'
else
  " gui_other: Courier_New:h11:cDEFAULT
  let s:regex = '\(.\{-}\):h\(\d\+\)\(.*\)'
endif


function! s:encodeFont(font)
  if has("iconv") && exists("g:thematic#encoding")
    let encodedFont = iconv(a:font, &enc, g:thematic#encoding)
  else
    let encodedFont = a:font
  endif
  return encodedFont
endfunction


function! s:decodeFont(font)
  if has("iconv") && exists("g:thematic#encoding")
    let decodedFont = iconv(a:font, g:thematic#encoding, &enc)
  else
    let decodedFont = a:font
  endif
  return decodedFont
endfunction


function! s:getSize(font, fallback)
  let l:decodedFont = s:decodeFont(a:font)
  if match(l:decodedFont, s:regex) != -1
    " Add zero to convert to integer.
    let l:size = 0 + substitute(l:decodedFont, s:regex, '\2', '')
  else
    let l:size = 0 + a:fallback
  endif
  return l:size
endfunction


function! s:getTypeface(font, fallback)
  let decodedFont = s:decodeFont(a:font)
  if match(decodedFont, s:regex) != -1
    let l:typeface = substitute(decodedFont, s:regex, '\1', '')
  else
    let l:typeface = a:fallback
  endif
  return l:typeface
endfunction


" Note that bgcolor may not be available at initial program load
function! s:updateFullscreenBackground()
  " #123456 => #00123456
  let l:bgcolor=synIDattr(hlID('Normal'), 'bg#')
  if l:bgcolor =~ '#[0-9a-fA-F]\+'
    let l:border_color = substitute(l:bgcolor, '#', '#00', '')
    " Note that this will blow away existing options, such
    " as maxhorz and maxvert, but we removed those earlier.
    execute 'set fuoptions=background:' . l:border_color
  endif
endfunction


function! s:composeGuifontString(typeface, fontsize)
  " TODO need support for platform-specific suffixes
  let l:encoded_typeface = s:encodeFont(a:typeface)
  if has('gui_macvim')
    "set guifont=Courier\ New\:h11
    let l:gf = substitute(l:encoded_typeface, ' ', '\\ ', 'g') . '\:h' . a:fontsize
  elseif has('gui_gtk') || has('gui_gtk2') || has('gui_gnome')
    "set guifont=Courier\ New\ 11
    let l:gf = substitute(l:encoded_typeface, ' ', '\\ ', 'g') . '\ ' . a:fontsize
  elseif has('gui_photon')
    "set guifont=Courier\ New:s11
    let l:gf = substitute(l:encoded_typeface, ' ', '\\ ', 'g') . ':s' . a:fontsize
  elseif has('gui_kde') "|| has('gui_qt')
    "set guifont=B&H\ LucidaTypewriter/9/-1/5/50/0/0/0/1/0
    "set guifont=Courier\ New/11/-1/5/50/0/0/0/1/0
    let l:gf = substitute(l:encoded_typeface, ' ', '\\ ', 'g') . '/' . a:fontsize
  "elseif has("x11") && !(has("gui_gtk2") || has("gui_kde") || has("gui_photon"))
  "  "set guifont=-*-courier-medium-r-normal-*-*-180-*-*-m-*-*
  "  " 18.0pt Courier
  "  "set gfn=-*-lucidatypewriter-medium-r-normal-*-*-95-*-*-m-*-*
  "  " 9.5pt LucidaTypewriter
  "  let l:gf = '-*-' . tolower(l:tf) . '-medium-r-normal-*-*-' . (l:fs*10) . '-*-*-m-*-*'
  elseif has('win32') || has('win64') "|| has('gui_win32') || has('gui_win64')
    "set guifont=courier_new:h11
    "set guifont=Lucida_Console:h8:cANSI
    let l:gf = substitute(l:encoded_typeface, ' ', '_', 'g') . ':h' . a:fontsize
  else
    echoerr 'GUI platform not yet supported'
    let l:gf = ''
  endif
  return l:gf
endfunction


function! s:setGuifont(gf)
  if strlen(a:gf)
    try
      execute 'set guifont=' . a:gf
      return 1
    catch /E596/
      echohl ErrorMsg
      echo 'Unable to set guifont=' . a:gf
      echohl None
    endtry
  endif
  return 0
endfunction


function! thematic#gui#setFont(th) abort
  " attempt to preserve original font if not yet set
  if !has_key(g:thematic#original, 'typeface')
    let l:typeface = s:getTypeface(&guifont, '')
    if l:typeface != ''
      let g:thematic#original['typeface'] = l:typeface
    endif
  endif
  if !has_key(g:thematic#original, 'font-size')
    let l:size = s:getSize(&guifont, 0)
    if l:size != 0
      let g:thematic#original['font-size'] = l:size
    endif
  endif

  let l:tf = thematic#getThemeValue(a:th, 'typeface', '')
  let l:fs = thematic#getThemeValue(a:th, 'font-size', -1)

  " TODO support list of typefaces with most desired as first in list
  let l:gf = s:composeGuifontString(l:tf, l:fs)
  if l:gf != ''
    call s:setGuifont(l:gf)
  endif
endfunction


function! thematic#gui#setTransparency(th) abort
  let l:tr = thematic#getThemeValue(a:th, 'transparency', -1)
  if l:tr > 100
    let l:tr = 100
  endif
  if l:tr >= 0
    try
      execute 'set transparency=' . l:tr
    catch
      echohl ErrorMsg
      echo 'Unable to set transparency=' . l:tr
      echohl None
    endtry
  endif
endfunction


function! thematic#gui#setLinespace(th) abort
  let l:ls = thematic#getThemeValue(a:th, 'linespace', -1)
  if l:ls != -1
    try
      execute 'set linespace=' . l:ls
    catch
      echohl ErrorMsg
      echo 'Unable to set linespace=' . l:ls
      echohl None
    endtry
  endif
endfunction


function! thematic#gui#setFullscreen(th) abort
  if has('fullscreen')
    " Because it can be jarring to see fullscreen disable,
    " we'll only enable it.
    if !&fullscreen && thematic#getThemeValue(a:th, 'fullscreen', -1) == 1
      try
        set fullscreen
      catch
        echohl ErrorMsg
        echo 'Fullscreen not supported'
        echohl None
      endtry
    endif

    " Have the fullscreen background match the text background
    if thematic#getThemeValue(a:th, 'fullscreen-background-color-fix', 0)
      call s:updateFullscreenBackground()
    endif
  endif
endfunction


" If no explicit settings on lines and columns in
" either the theme or the defaults, then leave alone.
function! thematic#gui#setColumnsAndLines(th) abort
  let l:columns = thematic#getThemeValue(a:th, 'columns', 0)
  if l:columns > 0
    execute 'set columns=' . l:columns
  elseif thematic#getThemeValue(a:th, 'maxhorz', 0)
    set columns=999
  endif
  let l:lines = thematic#getThemeValue(a:th, 'lines', 0)
  if l:lines > 0
    execute 'set lines=' . l:lines
  elseif thematic#getThemeValue(a:th, 'maxvert', 0)
    set lines=999
  endif
endfunction


function! thematic#gui#adjustColumns(delta)
  let l:nu_cols = &columns + a:delta
  silent execute "set columns=" . l:nu_cols
endfunction

" vim:ts=2:sw=2:sts=2
