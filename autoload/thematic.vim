" ============================================================================
" File:        autoload/thematic.vim
" Description: autoload script for vim-thematic plugin
" Maintainer:  Reed Esau <github.com/reedes>
" Last Change: December 30, 2013
" License:     The MIT License (MIT)
" ============================================================================

if exists("autoloaded_thematic") | finish | endif
let autoloaded_thematic = 1

function! s:normalColors(hi_grps)
  call s:setColorsTo(a:hi_grps, 'Normal', 'fg', 'bg')
endfunction

function! s:invertColors(hi_grps)
  call s:setColorsTo(a:hi_grps, 'Normal', 'bg', 'fg')
endfunction

function! s:muteColors(hi_grps)
  call s:setColorsTo(a:hi_grps, 'Normal', 'bg', 'bg')
endfunction

function! s:setColorsTo(hi_grps, target_grp, target_fg, target_bg)
  " modify the specified highlight groups based on another highlight group
  if has('gui_running')
    for l:hi_grp in a:hi_grps
      execute 'hi! ' . l:hi_grp . ' guifg=' . a:target_fg . ' guibg=' . a:target_bg
    endfor
  else
    " set the cterm colors iff colorscheme specifies fg and bg
    " 'desert' does not, but 'bubblegum' does
    let l:target_grp_fg = synIDattr(synIDtrans(hlID(a:target_grp)), 'fg')
    let l:target_grp_bg = synIDattr(synIDtrans(hlID(a:target_grp)), 'bg')
    let l:ok_fg = l:target_grp_fg !~ '^-1$\|^$'
    let l:ok_bg = l:target_grp_bg !~ '^-1$\|^$'
    if l:ok_fg && l:ok_bg
      for l:hi_grp in a:hi_grps
        let l:nu_fg = a:target_fg ==# 'fg' ? l:target_grp_fg : l:target_grp_bg
        let l:nu_bg = a:target_bg ==# 'bg' ? l:target_grp_bg : l:target_grp_fg
        execute 'hi! ' . l:hi_grp .  ' ctermfg=' . l:nu_fg . ' ctermbg=' . l:nu_bg
      endfor
    endif
  endif
endfunction

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

function! thematic#init(mode) abort
  if len(g:thematic#themes) == 0
    echohl WarningMsg | echo 'No themes found.' | echohl NONE
    return
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

  " ------ Set background and colorscheme ------

  " Use the original background, if not explicit and no default.
  " Note that we're setting background BEFORE the colorscheme,
  " because many colorschemes will deliberately override it.
  " And some, like solarized, will dynamically adjust to it.
  let l:bg = thematic#getThemeValue(l:th, 'background', '')
  if (l:bg == 'light' || l:bg == 'dark') && &background != l:bg
    execute 'set background=' . l:bg
  endif

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

  " ------ Fix/mute colors ------

  let l:gui_running = has('gui_running')

  if thematic#getThemeValue(l:th, 'sign-column-color-fix', 0)
    " Ensure the gutter matches 'Normal' highlighting
    call s:normalColors(['SignColumn',])
  endif

  if thematic#getThemeValue(l:th, 'diff-color-fix', 0)
    " Override diff colors, in case the colorscheme's diff colors are awful
    " Use also to fix sign column colors
    if l:gui_running
      hi! DiffAdd    guifg=DarkGreen  guibg=bg
      hi! DiffDelete guifg=DarkRed    guibg=bg
      hi! DiffChange guifg=DarkYellow guibg=bg
      hi! DiffText   guifg=DarkCyan   guibg=bg
    else
      call s:normalColors(['DiffAdd','DiffDelete','DiffChange','DiffText',])
      hi! DiffAdd    ctermfg=DarkGreen
      hi! DiffDelete ctermfg=DarkRed
      hi! DiffChange ctermfg=DarkYellow
      hi! DiffText   ctermfg=DarkCyan
    endif
  endif

  if thematic#getThemeValue(l:th, 'fold-column-color-mute', 0)
    " Ensure the fold column is blank, for non-distracted editing
    call s:muteColors(['FoldColumn',])
  endif

  if thematic#getThemeValue(l:th, 'number-column-color-mute', 0)
    " Ensure the number column is blank, for non-distracted editing
    call s:muteColors(['LineNr', 'CursorLineNr',])
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

  if l:gui_running
    call thematic#gui#init(l:th)
  endif

  let g:thematic#theme_name = l:theme_name

  " only seems to work for non-gui
  "redraw | echo 'Thematic: ' . l:theme_name
endfunction

" vim:ts=2:sw=2:sts=2
