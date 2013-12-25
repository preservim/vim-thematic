" Autoload portion of plugin/themata.vim.
"
" Credit for some font regex/functions: https://github.com/drmikehenry/vim-fontsize

if exists("autoloaded_themata")
  finish
endif
let autoloaded_themata = 1

" # FONT REGEXES {{{1
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
" }}}1

" # FUNCTIONS {{{1
" # Function: s:encodeFont {{{2
function! s:encodeFont(font)
  if has("iconv") && exists("g:themata#encoding")
    let encodedFont = iconv(a:font, &enc, g:themata#encoding)
  else
    let encodedFont = a:font
  endif
  return encodedFont
endfunction
" }}}2
" # Function: s:decodeFont {{{2
function! s:decodeFont(font)
  if has("iconv") && exists("g:themata#encoding")
    let decodedFont = iconv(a:font, g:themata#encoding, &enc)
  else
    let decodedFont = a:font
  endif
  return decodedFont
endfunction
" }}}2
" # Function: s:getSize {{{2
function! s:getSize(font, fallback)
  let l:decodedFont = s:decodeFont(a:font)
  if match(l:decodedFont, s:regex) != -1
    " Add zero to convert to integer.
    let l:size = 0 + substitute(l:decodedFont, s:regex, '\2', '')
  else
    let l:size = 0 + fallback
  endif
  return l:size
endfunction
" }}}2
" # Function: s:getTypeface {{{2
function! s:getTypeface(font, fallback)
  let decodedFont = s:decodeFont(a:font)
  if match(decodedFont, s:regex) != -1
    let l:typeface = substitute(decodedFont, s:regex, '\1', '')
  else
    let l:typeface = a:fallback
  endif
  return l:typeface
endfunction
" }}}2
" # Function: s:getThemeName {{{2
function! s:getThemeName(mode)
  let l:avail_names = sort(keys(g:themata#themes))
  let l:avail_count = len(l:avail_names)
  let l:new_n = -1
  if a:mode == '#first'
    let l:new_n = 0
  elseif a:mode == '#last'
    let l:new_n = l:avail_count - 1
  elseif a:mode == '#random'
    let l:new_n =
          \ str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:])
          \ % l:avail_count
  elseif a:mode == '#next' || a:mode == '#previous'
    let l:current_n = index(l:avail_names, g:themata#theme_name)
    if a:mode == '#next'
      if l:current_n == -1 || l:current_n == l:avail_count - 1
        let l:new_n = 0
      else
        let l:new_n = l:current_n + 1
      endif
    elseif a:mode == '#previous'
      if l:current_n <= 0
        let l:new_n = l:avail_count - 1
      else
        let l:new_n = l:current_n - 1
      endif
    endif
  endif

  if l:new_n == -1
    return a:mode
  else
    return l:avail_names[l:new_n]
  endif
endfunction
" }}}2
" # Function: s:getThemeValue {{{2
" Obtain value for theme property, falling back to either user-specified
" defaults or the original value.
function! s:getThemeValue(th, key_name, ultimate_fallback_value)
  if has_key(g:themata#defaults, a:key_name)
    let l:fallback_value = get(g:themata#defaults, a:key_name)
  elseif has_key(g:themata#original, a:key_name)
    let l:fallback_value = get(g:themata#original, a:key_name)
  else
    let l:fallback_value = a:ultimate_fallback_value
  endif
  return get(a:th, a:key_name, l:fallback_value)
endfunction
" }}}2
" # Function: s:updateFullscreenBackground {{{2
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
" }}}2
" # Function: s:airline {{{2
function! s:airline(th)
  " set the g:airline_theme variable and refresh
  "https://github.com/bling/vim-airline/wiki/Screenshots
  if exists(':AirlineRefresh')
    " attempt to preserve original airline theme if not yet set
    if !has_key(g:themata#original, 'airline-theme') && exists('g:airline_theme')
      let g:themata#original['airline-theme'] = g:airline_theme
    endif

    let l:al = s:getThemeValue(a:th, 'airline-theme', '')
    if l:al != ''
      let g:airline_theme = l:al
    else
      let l:airline_supported = {
            \ '.*solarized.*': 'solarized',
            \ '.*zenburn.*': 'zenburn',
            \ 'Tomorrow.*': 'tomorrow',
            \ 'base16.*': 'base16',
            \ 'jellybeans.*': 'jellybeans',
            \ 'mo[l|n]okai': 'molokai',
            \ 'wombat.*': 'wombat',
            \ }
      if exists('g:colors_name')
        for l:item in items(l:airline_supported) | if g:colors_name =~ l:item[0]
          let g:airline_theme = l:item[1]
          break
        endif | endfo
      endif
    endif
    AirlineRefresh
  endif
endfunction
" }}}2
" # Function: s:composeGuifontString {{{2
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
" }}}2
" # Function: s:setGuifont {{{2
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
" }}}
" # Function: s:guiFont {{{2
function! s:guiFont(th)
  " attempt to preserve original font if not yet set
  if !has_key(g:themata#original, 'typeface')
    let l:typeface = s:getTypeface(&guifont, '')
    if l:typeface != ''
      let g:themata#original['typeface'] = l:typeface
    endif
  endif
  if !has_key(g:themata#original, 'font-size')
    let l:size = s:getSize(&guifont, 0)
    if l:size != 0
      let g:themata#original['font-size'] = l:size
    endif
  endif

  let l:tf = s:getThemeValue(a:th, 'typeface', '')
  let l:fs = s:getThemeValue(a:th, 'font-size', -1)

  " TODO support list of typefaces with most desired as first in list
  let l:gf = s:composeGuifontString(l:tf, l:fs)
  if l:gf != ''
    call s:setGuifont(l:gf)
  endif
endfunction
" }}}2
" # Function: s:guiMisc {{{2
function! s:guiMisc(th)
  let l:tr = s:getThemeValue(a:th, 'transparency', -1)
  if l:tr > 100
    let l:tr = 100
  endif
  if l:tr > 0
    try
      execute 'set transparency=' . l:tr
    catch
      echohl ErrorMsg
      echo 'Unable to set transparency=' . l:tr
      echohl None
    endtry
  endif

  let l:ls = s:getThemeValue(a:th, 'linespace', -1)
  if l:ls != -1
    try
      execute 'set linespace=' . l:ls
    catch
      echohl ErrorMsg
      echo 'Unable to set linespace=' . l:ls
      echohl None
    endtry
  endif

  if has('fullscreen')
    " Because it can be jarring to see fullscreen disable,
    " we'll only enable it.
    if !&fullscreen && s:getThemeValue(a:th, 'fullscreen', -1) == 1
      try
        set fullscreen
      catch
        echohl ErrorMsg
        echo 'Fullscreen not supported'
        echohl None
      endtry
    endif

    " Have the fullscreen background match the text background
    if s:getThemeValue(a:th, 'fullscreen-background-color-fix', 0)
      call s:updateFullscreenBackground()
    endif
  endif
endfunction
" }}}2
" # Function: s:setColumnsAndLines {{{2
" If no explicit settings on lines and columns in
" either the theme or the defaults, then leave alone.
function! s:setColumnsAndLines(th)

  let l:columns = s:getThemeValue(a:th, 'columns', 0)
  if l:columns > 0
    execute 'set columns=' . l:columns
  elseif s:getThemeValue(a:th, 'maxhorz', 0)
    set columns=999
  endif

  let l:lines = s:getThemeValue(a:th, 'lines', 0)
  if l:lines > 0
    execute 'set lines=' . l:lines
  elseif s:getThemeValue(a:th, 'maxvert', 0)
    set lines=999
  endif
endfunction
" }}}2
" # Function: load {{{2
function! themata#load(mode)
  if len(g:themata#themes) == 0
    echohl WarningMsg | echo 'No themes found.' | echohl NONE
    finish
  endif

  " attempt to preserve original colorscheme and its background
  if !has_key(g:themata#original, 'colorscheme') && exists('g:colors_name')
    let g:themata#original.colorscheme = g:colors_name
    let g:themata#original.background = &background
  endif

  " Resolve theme_name from mode, where mode can be #first, #last, #next,
  " #previous, #random, a colorscheme, a key in g:themata#themes, or the
  " user's original settings.
  if a:mode == '#original'
    let l:theme_name = ''
    let l:th = g:themata#original
  else
    let l:theme_name = s:getThemeName(a:mode)
    let l:th = get(g:themata#themes, l:theme_name, {})
  endif

  " ------ Set colorscheme and background ------ {{{3

  " assume the colorscheme matches the theme name if not explicit
  let l:cs = get(l:th, 'colorscheme', l:theme_name)
  try
    execute 'colorscheme ' . l:cs
  catch /E185:/
    " no colorscheme matching the theme name, so fall back to original, if any
    if has_key(g:themata#original, 'colorscheme')
      let l:cs = g:themata#original.colorscheme
      execute 'colorscheme ' . l:cs
    endif
  endtry

  " use the original background, if not explicit and no default
  let l:bg = s:getThemeValue(l:th, 'background', '')
  if (l:bg == 'light' || l:bg == 'dark') && &background != l:bg
    execute 'set background=' . l:bg
  endif

  " }}}3

  " ------ Fix/mute colors ------ {{{3

  if s:getThemeValue(l:th, 'sign-column-color-fix', 0)
    " Ensure the gutter matches the text background
    " TODO how about match the number background?
    hi! SignColumn guifg=fg guibg=bg
  endif

  if s:getThemeValue(l:th, 'diff-color-fix', 0)
    " Override diff colors
    " TODO figure out what to do for cterm
    hi! DiffAdd    guifg=darkgreen  guibg=bg "cterm=bold ctermbg=237 ctermfg=119
    hi! DiffDelete guifg=darkorange guibg=bg "cterm=bold ctermbg=237 ctermfg=167
    hi! DiffChange guifg=darkyellow guibg=bg "cterm=bold ctermbg=237 ctermfg=227
    hi! DiffText   guifg=fg         guibg=bg
  endif

  if s:getThemeValue(l:th, 'fold-column-color-mute', 0)
    " Ensure the fold column is blank, for non-distracted editing
    hi! FoldColumn guifg=bg guibg=bg cterm=none ctermbg=none ctermfg=none
  endif

  " }}}3

  " ------ Set sign column for all buffers ------ {{{3

  " Force the display of a two-column gutter for signs, etc.
  " The sign configuration is apparently buffer-scoped, so iterate
  " over all listed buffers to force the sign column.
  let l:sc = s:getThemeValue(l:th, 'sign-column', -1)
  if l:sc == 1
    " TODO how to auto-refresh/disable Signify, gitgutter, etc.?
    sign define dummy
    let l:b_all = range(1, bufnr('$'))
    for l:b_no in filter(l:b_all, 'buflisted(v:val)')
      execute 'sign place 9999 line=1 name=dummy buffer=' . l:b_no
    endfor
  elseif l:sc == 0
    sign unplace *
  endif

  " }}}3

  " ------ Set statusline, ruler, airline_theme ------ {{{3

  "  These are all globally-scoped settings

  let l:ruler = s:getThemeValue(l:th, 'ruler', -1)
  if l:ruler == 1
    set ruler
  elseif l:ruler == 0
    set noruler
  endif

  call s:airline(l:th)

  let l:ls = s:getThemeValue(l:th, 'laststatus', -1)
  if l:ls > 2
    let l:ls = 2
  endif
  if l:ls >= 0
    execute 'set laststatus=' . l:ls
  endif

  " }}}3

  " ------ Set GUI-only settings ------ {{{3

  if has('gui_running')
    call s:guiFont(l:th)
    call s:guiMisc(l:th)
    call s:setColumnsAndLines(l:th)
  endif

  " }}}3

  let g:themata#theme_name = l:theme_name

  if s:getThemeValue(l:th, 'force-redraw', 0)
    redraw!
  endif
endfunction
" }}}2
" # Function: adjustColumns {{{2
function! themata#adjustColumns(delta)
  let l:nu_cols = &columns + a:delta
  silent execute "set columns=" . l:nu_cols
endfunction
" }}}2
" }}}1
" vim:ts=2:sw=2:sts=2
