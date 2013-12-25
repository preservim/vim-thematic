# `thematic.vim`

_Manage the look and feel of your Vim text editor_

* Written in pure Vimscript for recent versions of MacVim, gVim, Vim, etc.
* Stays out of your way, except where you want it
* No predefined key mappings that could interfere with your other mappings
* Support for font and fullscreen settings in GUI-based Vim
* Integrates with [airline][https://github.com/bling/vim-airline], another `themeable` plugin

## Why `thematic`?

Many Vim users will keep things simple by sticking with a single theme that suits their needs, configuring it in their `.vimrc` by setting colorscheme, `guifont`, number, status line, etc.. Nothing wrong with that approach.

But you may instead want to configure the visual details of Vim to match the task at hand, or even to suit your mood. For example, you might choose a theme that is less fatiguing to your eyes given the ambient lighting conditions, where you'll have a muted theme for a dark room and a high-contrast theme for use in a bright one.

Writing code, you may want a status bar, ruler, transparency and a programming font. But if you're writing an essay or screenplay, you may want the screen stripped of all extraneous detail, with a traditional font and generous left and right margins.

You may want to complement a colorscheme with a particular typeface -- a lightweight anti-aliased typeface like Adobe's _Source Code Pro ExtraLight_ may look great against a black background but be unreadable against a white one. Or for a given typeface you may want a specific [leading][http://en.wikipedia.org/wiki/Leading] as supported with Vim's `linespace`.

Managing such an environment in Vim has traditionally been a hassle. The `thematic` plugin is intended to provide the Vim user more flexibility and convenience.

## What theme properties can I set?

For each theme you specify one or more properties.

For console or GUI Vim:
* `laststatus` (0, 1, or 2) - _controls the visibility of the status bar_
* `ruler` - _as alternative to status bar, shows minimal position details in lower right_
* `colorscheme` - _set the colors for all windows_
* `background` (dark or light) - _some colorschemes can be further configured via background_
* `sign-column` - _optional two-character gutter on left-side of window_
* `airline-theme` - _plugin for theming your status bar_
* `sign-column-color-fix` - _temporarily modifies colorscheme to force gutter background_
* `diff-color-fix` - _temporarily modifies colorscheme to force diff character color_
* `fold-column-color-mute` - _temporarily modifies colorscheme to hide indicators in foldcolumn_
* `force-redraw` - _if 1, forces a `redraw!` after `thematic` makes changes_

For GUI-based Vim only:
* `typeface`, `font-size`, and `linespace` - _be specific about typography_
* `fullscreen` and `fullscreen-background-color-fix` - _force a switch to fullscreen, with optional change of color of the background (or border)_
* `columns` and `lines` - _manage the width of margins in `fullscreen` mode_
* `transparency` (0-100) - _view details of window and desktop beneath Vim_

* Check `:help thematic` for details.

## Basic Usage

* Run `:ThematicFirst` to invoke `thematic` and choose the first theme. Your themes will be ordered alphabetically.

    ```vim
    :ThematicFirst         " select the first theme
    :ThematicNext          " select the next theme
    :ThematicPrevious      " select the previous theme
    :ThematicRandom        " select a random theme
    :ThematicOriginal      " revert to the original theme
    ```

`thematic` does not map any keys by default, but you can easily do so in your `.vimrc` file, like this:

    ```vim
    nmap <Leader>t <Plug>ThematicNext
    nmap <Leader>T <Plug>ThematicPrevious
    ```

...where with the default leader key of `\`, `\t` would select the next theme in your list, as ordered alphabetically.

A few of Vim's standard `colorschemes` are configured as default themes, but you'll likely want to override them with your own, like this:

    ```
    let g:thematic#themes = {
    \ 'bubblegum'  : { 'typeface': 'CosmicSansNeueMono',
    \                  'sign-column-color-fix': 1,
    \                  'transparency': 10,
    \                },
    \ 'desert'     : { 'sign-column': 0,
    \                },
    \ 'jellybeans' : { 'typeface': 'Droid Sans Mono',
    \                  'font-size': 20,
    \                  'laststatus': 0,
    \                  'ruler': 1,
    \                },
    \ 'matrix'     : { 'colorscheme': 'base16-greenscreen',
    \                  'typeface': 'Dot Matrix',
    \                  'laststatus': 0,
    \                  'linespace': 9,
    \                  'transparency': 10,
    \                },
    \ 'reede_dark' : { 'typeface': 'Source Code Pro ExtraLight',
    \                  'airline-theme': 'badwolf',
    \                },
    \ 'reede_light': { 'typeface': 'Luxi Mono',
    \                  'columns': 75,
    \                  'font-size': 20,
    \                  'fullscreen': 1,
    \                  'laststatus': 0,
    \                  'linespace': 9,
    \                  'sign-column': 1,
    \                },
    \ 'solar_dark' : { 'colorscheme': 'solarized',
    \                  'background': 'dark',
    \                  'diff-color-fix': 1,
    \                  'sign-column-color-fix': 1,
    \                  'signcolumn-color-fix': 1,
    \                  'typeface': 'Source Code Pro Light',
    \                },
    \ 'solar_lite' : { 'colorscheme': 'solarized',
    \                  'background': 'light',
    \                  'font-size': 20,
    \                  'signcolumn-color-fix': 1,
    \                },
    \ }
    ```

If you don't specify a `colorscheme`, `thematic` will assume it matches your theme name.

You can also specify a dictionary of default values, to be shared by all of your themes.

    ```
    let g:thematic#defaults = {
    \ 'airline-theme': 'jellybeans',
    \ 'fullscreen-background-color-fix': 1,
    \ 'laststatus': 2,
    \ 'font-size': 20,
    \ 'transparency': 0,
    \ }
    ```

Note that an explicit setting in a theme will always override these defaults.

Note also that `thematic` stays out of your way, ignoring any settings that you aren't explicitly setting through your `thematic` configuration.* For example, you can `set guifont=` in your .gvimrc independent of your `thematic` configuration.

* * the one exception is `fuoptions` discussed below

## Installation

Install using Pathogen, Vundle, Neobundle, or your favorite Vim package manager. 

## Configuration

    ```
    set nocompatible
    filetype off
    ```

## GUI fullscreen capabilities

`thematic` supports fullscreen capabilities in a GUI-based Vim, including typeface, font-size, lines, columns, linespace, transparency and even the fullscreen background.

Note that once invoked, `thematic` will override your fullscreen settings, specifically `fuoptions` to get better control over lines and columns and the fullscreen background.

## Column sizing

You may wish to adjust the columns while in full screen. Map to Command-9 and Command-0 in your `.vimrc` with:

    ```
    nmap <silent> <D-9> <Plug>ThematicNarrow
    nmap <silent> <D-0> <Plug>ThematicWiden
    ```

## FAQ

### Q: I want to set `cursorline`, `wrap`, `foldcolumn`, `list`, `number`, `relativenumber`, `textwidth`, etc. in my themes.

`thematic` focuses exclusively on global settings. The settings above are not globally-scoped but are instead scoped to individual buffers and windows. These are best set using the existing `FileType` facility in Vim.

In addition, settings like `textwidth` will modify your documents. This plugin strenuously avoids doing anything to change your documents.

To your `.vimrc` add

    ```
    filetype plugin on

    " defaults for all buffers/windows
    set nocursorline
    set foldcolumn=0
    set list
    set nonumber
    set norelativenumber
    set nowrap
    ```

Then for each `filetype` that you wish to support with specific settings, create a file in the `~/.vim/after/ftplugin` directory.

For example, to support custom settings for `python` files, create a file `~/.vim/after/ftplugin/python.vim` containing:

    ```
    " python-specific settings
    set cursorline
    set number
    ```

Then a cursor line and line numbering will be present whenever you edit a python file.

### Q: Using MacVim, the fullscreen background color isn't working as expected. How do I change its behavior?

To have the fullscreen background's color set by `thematic`, enter the following in OSX Terminal:

    ```
    $ defaults write org.vim.MacVim MMNativeFullScreen 0
    ```

Or, if you prefer your fullscreen window to float against a standard background:

    ```
    $ defaults write org.vim.MacVim MMNativeFullScreen 1
    ```

### Q: How can I configure Vim to emulate soft-wrapping markdown editors like IAWriter?

It works best in GUI Vim's fullscreen. Several steps are involved:

(1) Install a `markdown.vim` plugin from [plasticboy][https://github.com/plasticboy/vim-markdown] or [tpope][https://github.com/tpope/vim-markdown].

(2) Configure your `~/.gvimrc` to disable the tool bar, etc.

    ```
    set antialias
    set guicursor+=a:blinkon0    " disable cursor blink
    set guioptions-=r   "kill right scrollbar
    set guioptions-=l   "kill left scrollbar
    set guioptions-=L   "kill left scrollbar multiple buffers
    set guioptions-=T   "kill toolbar
    ```

(3) Edit `~/.vim/after/ftplugin/markdown.vim` to control editing behavior and buffer-specific settings:

    ```
    " IAWriter-like settings (soft-wrap mode)
    setlocal textwidth=0
    setlocal wrap
    setlocal complete+=k
    setlocal complete+=kspell
    setlocal complete+=s
    setlocal nocursorline
    setlocal dictionary+=/usr/share/dict/words
    setlocal display+=lastline
    setlocal formatoptions+=l     " long lines not broken in insert mode
    setlocal linebreak            " default breakat ' ^I!@*-+;:,./?'
    setlocal nojoinspaces         " only one space after a .!?
    setlocal nolist
    setlocal nonumber
    setlocal norelativenumber
    setlocal spell spelllang=en_us
    setlocal spellfile=~/.vim/spell/en.utf-8.add
    setlocal thesaurus+=~/.vim/thesaurus/mthesaur.txt
    setlocal virtualedit=
    setlocal wrapmargin=0
    nnoremap <buffer> <silent> $ g$
    nnoremap <buffer> <silent> 0 g0
    nnoremap <buffer> <silent> j gj
    nnoremap <buffer> <silent> k gk
    vnoremap <buffer> <silent> $ g$
    vnoremap <buffer> <silent> 0 g0
    vnoremap <buffer> <silent> j gj
    vnoremap <buffer> <silent> k gk
    ```

(4) Finally, add a theme configured to your tastes. Here's an example:

    ```
    let g:thematic#themes = {
    \ 'mark_lite'   :{ 'colorscheme': 'solarized',
    \                  'background': 'light',
    \                  'columns': 75,
    \                  'font-size': 20,
    \                  'fullscreen': 1,
    \                  'laststatus': 0,
    \                  'linespace': 8,
    \                  'typeface': 'Menlo',
    \                },
    ...
    \ }
    ```

Console-based emulation is trickier, as there's no easy way to create generous left and right margins. You can approximate it by switching from soft-wrap to hard line breaks with additional changes to `~/.vim/after/ftplugin/markdown.vim`:

    ```
    setlocal foldcolumn=12          " add a generous left column
    setlocal nowrap                 " replaces 'set wrap'
    setlocal textwidth=70           " replaces 'set textwidth=0'
    ```

Note that this chooses hard line breaks over soft-wrapping and thus may not be desirable. You can also use the following setting in your theme to hide the indicators in the fold column.

    ```
    let g:thematic#themes = {
    \ 'YOURTHEME'   :{ 'fold-column-color-mute': 1,
                       ...
    \                },
    ...
    \ }
    ```

Also, check out:
* [vimroom][https://github.com/mikewest/vimroom/blob/master/plugin/vimroom.vim]
* [vim-writeroom][https://github.com/jamestomasino/vim-writeroom]
* [vim-zenmode][https://github.com/mmai/vim-zenmode]
* [df_moded][https://github.com/nielsadb/df_mode.vim]

### Q: In Mac OSX I switch to fullscreen via Control+Command+F and the screen is blank!

You can refresh via `:redraw!`

(if anybody knows how to fix this, let me know!)

As an alternative to key command you can force fullscreen in a theme with:

  ```
  let g:thematic#themes = {
  \ 'bubblegum'  : { 'fullscreen': 1,
  \                  ...
  \                },
  \ ...
  \ }
  ```

## Where to find

TODO GUI Vim
TODO Colorschemes

## Monospaced fonts

Many monospaced fonts are available for free. Note that your computer probably has several installed, such as `Menlo` on OSX.

### Popular monospaced fonts

* [Anonymous Pro](https://www.google.com/fonts/specimen/Anonymous+Pro)
* [CosmicSansNeueMono](https://github.com/belluzj/cosmic-sans-neue)
* [Courier Prime](http://quoteunquoteapps.com/courierprime/)
* [Cousine](http://www.google.com/fonts/specimen/Cousine)
* [Cutive Mono](http://www.google.com/fonts/specimen/Cutive+Mono)
* [DejaVu Sans Mono](http://dejavu-fonts.org/wiki/Download)
* [Droid Sans Mono](http://www.google.com/fonts/specimen/Droid+Sans+Mono)
* [Hermit](https://pcaro.es/p/hermit/)
* [Inconsolata](http://www.google.com/fonts/specimen/Inconsolata)
* [Linux Libertine Mono O](http://sourceforge.net/projects/linuxlibertine/)
* [Liberation](https://fedorahosted.org/liberation-fonts/)
* [Luxi Mono Regular](http://www.fontsquirrel.com/fonts/Luxi-Mono)
* [Meslo](https://github.com/andreberg/Meslo-Font)
* [Oxygen Mono](https://www.google.com/fonts/specimen/Oxygen+Mono)
* [PT Mono](http://www.google.com/fonts/specimen/PT+Mono)
* [Share Tech Mono](http://www.google.com/fonts/specimen/Share+Tech+Mono)
* [Source Code Pro](http://www.google.com/fonts/specimen/Source+Code+Pro)
* [Ubuntu Mono](https://www.google.com/fonts/specimen/Ubuntu+Mono)

## Similar Projects

If this project is not to your liking, you might enjoy:
* [vim-ultimate-colorscheme-utility][https://github.com/biskark/vim-ultimate-colorscheme-utility]
* [stylish][https://github.com/mislav/stylish.vim]
* [vim-session][https://github.com/xolox/vim-session]
* [vim-obsession][https://github.com/tpope/vim-obsession]

