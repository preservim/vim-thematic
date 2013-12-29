" ============================================================================
" File:        autoload/thematic.vim
" Description: autoload script for vim-thematic plugin
" Maintainer:  Reed Esau <github.com/reedes>
" Last Change: December 30, 2013
" License:     The MIT License (MIT)
" ============================================================================

if exists("autoloaded_thematic") | finish | endif
let autoloaded_thematic = 1


function! s:getThemeName(mode)
  let l:avail_names = sort(keys(g:thematic#themes))
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
    let l:current_n = index(l:avail_names, g:thematic#theme_name)
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


" Obtain value for theme property, falling back to either user-specified
" defaults or the original value.
function! thematic#getThemeValue(th, key_name, ultimate_fallback_value)
  if has_key(g:thematic#defaults, a:key_name)
    let l:fallback_value = get(g:thematic#defaults, a:key_name)
  elseif has_key(g:thematic#original, a:key_name)
    let l:fallback_value = get(g:thematic#original, a:key_name)
  else
    let l:fallback_value = a:ultimate_fallback_value
  endif
  return get(a:th, a:key_name, l:fallback_value)
endfunction


function! s:airline(th)
  " set the g:airline_theme variable and refresh
  "https://github.com/bling/vim-airline/wiki/Screenshots
  if exists(':AirlineRefresh')
    " attempt to preserve original airline theme if not yet set
    if !has_key(g:thematic#original, 'airline-theme') && exists('g:airline_theme')
      let g:thematic#original['airline-theme'] = g:airline_theme
    endif

    let l:al = thematic#getThemeValue(a:th, 'airline-theme', '')
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

function! thematic#init(mode)
  if len(g:thematic#themes) == 0
    echohl WarningMsg | echo 'No themes found.' | echohl NONE
    finish
  endif

  " attempt to preserve original colorscheme and its background
  if !has_key(g:thematic#original, 'colorscheme') && exists('g:colors_name')
    let g:thematic#original.colorscheme = g:colors_name
    let g:thematic#original.background = &background
  endif

  " Resolve theme_name from mode, where mode can be #first, #last, #next,
  " #previous, #random, a colorscheme, a key in g:thematic#themes, or the
  " user's original settings.
  if a:mode == '#original'
    let l:theme_name = ''
    let l:th = g:thematic#original
  else
    let l:theme_name = s:getThemeName(a:mode)
    let l:th = get(g:thematic#themes, l:theme_name, {})
  endif

  " ------ Set colorscheme and background ------

  " assume the colorscheme matches the theme name if not explicit
  let l:cs = get(l:th, 'colorscheme', l:theme_name)
  try
    execute 'colorscheme ' . l:cs
  catch /E185:/
    " no colorscheme matching the theme name, so fall back to original, if any
    if has_key(g:thematic#original, 'colorscheme')
      let l:cs = g:thematic#original.colorscheme
      execute 'colorscheme ' . l:cs
    endif
  endtry

  " use the original background, if not explicit and no default
  let l:bg = thematic#getThemeValue(l:th, 'background', '')
  if (l:bg == 'light' || l:bg == 'dark') && &background != l:bg
    execute 'set background=' . l:bg
  endif

  " ------ Fix/mute colors ------

  if thematic#getThemeValue(l:th, 'sign-column-color-fix', 0)
    " Ensure the gutter matches the text background
    " TODO how about match the number background?
    hi! SignColumn guifg=fg guibg=bg
  endif

  if thematic#getThemeValue(l:th, 'diff-color-fix', 0)
    " Override diff colors
    " TODO figure out what to do for cterm
    hi! DiffAdd    guifg=darkgreen  guibg=bg "cterm=bold ctermbg=237 ctermfg=119
    hi! DiffDelete guifg=darkorange guibg=bg "cterm=bold ctermbg=237 ctermfg=167
    hi! DiffChange guifg=darkyellow guibg=bg "cterm=bold ctermbg=237 ctermfg=227
    hi! DiffText   guifg=fg         guibg=bg
  endif

  if thematic#getThemeValue(l:th, 'fold-column-color-mute', 0)
    " Ensure the fold column is blank, for non-distracted editing
    hi! FoldColumn guifg=bg guibg=bg cterm=none ctermbg=none ctermfg=none
  endif

  " ------ Set sign column for all buffers ------

  " Force the display of a two-column gutter for signs, etc.
  " The sign configuration is apparently buffer-scoped, so iterate
  " over all listed buffers to force the sign column.
  let l:sc = thematic#getThemeValue(l:th, 'sign-column', -1)
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

  " ------ Set statusline, ruler, airline_theme ------

  "  These are all globally-scoped settings

  let l:ruler = thematic#getThemeValue(l:th, 'ruler', -1)
  if l:ruler == 1
    set ruler
  elseif l:ruler == 0
    set noruler
  endif

  call s:airline(l:th)

  let l:ls = thematic#getThemeValue(l:th, 'laststatus', -1)
  if l:ls > 2
    let l:ls = 2
  endif
  if l:ls >= 0
    execute 'set laststatus=' . l:ls
  endif

  " ------ Set GUI-only settings ------

  if has('gui_running') && exists('*thematic#gui#init')
    call thematic#gui#init(l:th)
  endif

  let g:thematic#theme_name = l:theme_name

  if thematic#getThemeValue(l:th, 'force-redraw', 0)
    redraw!
  endif
endfunction

" vim:ts=2:sw=2:sts=2
