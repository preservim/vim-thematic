# vim-thematic

> Conveniently manage Vim’s appearance to suit your task and environment

* Groups global settings (like colorscheme) into ‘themes’
* Stays out of your way, except where you want it
* No predefined key mappings to interfere with your other mappings
* [vim-thematic-gui](https://github.com/reedes/vim-thematic-gui) extension
  available with GUI-based support for: font, fullscreen, etc.
* Integrates with [airline][https://github.com/bling/vim-airline]

## Why thematic?

You may be among the many Vim users who keep things simple by sticking
with a single theme that suits your needs, configuring it in your `.vimrc`
by setting the color scheme, font and status line.

Or you might instead be among the users who instead configure the visual
details of Vim to match the lighting conditions or task at hand, or even
to suit your mood. For example, you might choose a theme that is less
fatiguing to your eyes given the ambient lighting conditions, where you'll
have a muted theme for a dark room and a high-contrast theme for use in
a bright one.

Writing code, you want a status bar, ruler, a hint of transparency and
a programming font. But if you're writing an essay or screenplay, you want
the screen stripped of all extraneous detail, with a traditional font and
generous left and right margins.

Managing such an multi-theme environment in Vim has traditionally been
a hassle. The thematic plugin is intended to solve that problem,
providing you flexibility and convenience.

## Requirements

May require a recent version of Vim.

## Installation

Install using Pathogen, Vundle, Neobundle, or your favorite Vim package
manager. 

## Configuration

### Themes

A few of Vim's standard `colorschemes` are configured by default, but
you'll want to override them with your own, like this:

    ```vim
    let g:thematic#themes = {
    \ 'bubblegum'  : {
    \                },
    \ 'jellybeans' : { 'laststatus': 0,
    \                  'ruler': 1,
    \                },
    \ 'matrix'     : { 'colorscheme': 'base16-greenscreen',
    \                  'laststatus': 0,
    \                },
    \ 'solar_dark' : { 'colorscheme': 'solarized',
    \                  'background': 'dark',
    \                  'diff-color-fix': 1,
    \                  'sign-column-color-fix': 1,
    \                },
    \ 'solar_lite' : { 'colorscheme': 'solarized',
    \                  'background': 'light',
    \                  'sign-column-color-fix': 1,
    \                },
    \ }
    ```

If you don't specify a `colorscheme`, thematic will attempt to load one
given your theme name.

You can also specify a dictionary of default values, to be shared by all
of your themes.

    ```vim
    let g:thematic#defaults = {
    \ 'airline-theme': 'jellybeans',
    \ 'laststatus': 2,
    \ }
    ```

Note that an explicit setting in a theme will always override these defaults.

Note also that thematic stays out of your way, ignoring any settings
that you aren't explicitly setting through your thematic configuration.
For example, you can `set guifont=` in your .gvimrc independent of your
thematic configuration.

### Commands

Running `:ThematicFirst` invoke thematic and chooses the first theme,
as your themes will be reordered alphabetically by name.

    ```vim
    :ThematicFirst         " switch to the first theme, ordered by name
    :ThematicNext          " switch to the next theme, ordered by name
    :ThematicPrevious      " switch to the previous theme, ordered by name
    :ThematicRandom        " switch to a random theme
    :ThematicOriginal      " revert to the original theme
    :Thematic {theme_name} " load a theme by name
    ```

thematic does not map any keys by default, but you can easily do so in
your `.vimrc` file:

    ```vim
    nnoremap <Leader>t <Plug>ThematicNext
    nnoremap <Leader>T <Plug>ThematicPrevious
    ```

## What theme properties can I set?

For each theme you specify one or more properties.

For console or GUI Vim:
* `laststatus` (0, 1, or 2) - controls the visibility of the status bar
* `ruler` - as alternative to status bar, shows minimal position details
  in lower right
* `colorscheme` - set the colors for all windows
* `background` (dark or light) - some colorschemes can be further
  configured via background
* `sign-column` - optional two-character gutter on left-side of window
* `airline-theme` - plugin for theming your status bar
* `sign-column-color-fix` - temporarily modifies colorscheme to force
  gutter background
* `diff-color-fix` - temporarily modifies colorscheme to force diff
  character color
* `fold-column-color-mute` - temporarily modifies colorscheme to hide
  indicators in foldcolumn
* `force-redraw` - if 1, forces a `redraw!` after thematic makes changes

For GUI-based options, see the `vim-thematic-gui` plugin. Here’s
a summary:

* `typeface`, `font-size`, and `linespace` - be specific about typography
* `fullscreen` and `fullscreen-background-color-fix` - force a switch to
  fullscreen, with optional change of color of the background (or border)
* `columns` and `lines` - manage the width of margins in `fullscreen` mode
* `transparency` (0-100) - view details of window and desktop beneath Vim

## FAQ

### Q: I want to set `cursorline`, `wrap`, `textwidth`, etc. in my themes.

thematic focuses exclusively on global settings. The settings above are
not globally-scoped but are instead scoped to individual buffers and
windows. These are best set using the `FileType` feature in Vim.

In addition, settings like `textwidth` will modify your documents, which
this plugin strenuously avoids.

### Q: How can I configure Vim to emulate markdown editors like IAWriter?

It works best with GUI Vim's fullscreen. A few steps are involved:

(1) Install a few plugins:

* [vim-thematic-gui](https://github.com/reedes/vim-thematic-gui) - support GUI features in thematic
* [vim-markdown](https://github.com/tpope/vim-markdown) - support for editing markdown
* [vim-writer](https://github.com/reedes/vim-writer) - to configure for word processing

(2) Edit your `.gvimrc` to disable the tool bar, etc.

    ```
    set antialias
    set guicursor+=a:blinkon0    " disable cursor blink
    set guioptions-=r   "kill right scrollbar
    set guioptions-=l   "kill left scrollbar
    set guioptions-=L   "kill left scrollbar multiple buffers
    set guioptions-=T   "kill toolbar
    ```

(3) Finally, create a theme configured to your tastes. Here's an example for
MacVim:

    ```
    let g:thematic#themes = {
    \ 'iawriter'    :{ 'colorscheme': 'solarized',
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

Without GUI-based Vim, console-based emulation is trickier, as there's no
easy way to create generous left and right margins. You can approximate it
by switching from soft-wrap to hard line breaks with `vim-writer` and using
with a narrow `textwidth`:

    ```
    autocmd FileType markdown set foldcolumn=12 textwidth=74
    ```

## Related projects

If this project is not to your liking, you might enjoy:

* [vim-ultimate-colorscheme-utility](https://github.com/biskark/vim-ultimate-colorscheme-utility)
* [stylish](https://github.com/mislav/stylish.vim)
* [vim-session](https://github.com/xolox/vim-session)
* [vim-obsession](https://github.com/tpope/vim-obsession)

## See also

If you like this plugin, you might like these others from the same author:

* [vim-litecorrect](http://github.com/reedes/vim-litecorrect) - Lightweight auto-correction for Vim
* [vim-quotable](http://github.com/reedes/vim-quotable) - extends Vim to support typographic (‘curly’) quotes
* [vim-thematic-gui](http://github.com/reedes/vim-thematic-gui) — A GUI-based extension to the thematic plugin for Vim
* [vim-writer](http://github.com/reedes/vim-writer) - Extending Vim to better support writing prose and documentation

## Future development

If you have any ideas on improving this plugin, please post them to the github
project issue page.

<!-- vim: set tw=74 :-->
