# vim-thematic

> Conveniently manage Vim’s appearance to suit your task and environment

![demo](screenshots/demo.gif)

## Features

* Groups global settings (like colorscheme, ruler, etc.) into ‘themes’
* Stays out of your way, except where you want it
* Integrates with [airline](https://github.com/bling/vim-airline)
* Support for GUI-based Vim includes: font, linespace, fullscreen,
  transparency, and screen columns/lines

## Why _thematic_?

You may be among the many Vim users who keep things simple by sticking
with a single theme that suits their needs, configuring it in their
`.vimrc` by setting the color scheme, font and status line.

Or you might instead be among the users who instead configure the visual
details of Vim to match the lighting conditions or task at hand, or even
to suit their mood. For example, you might choose a theme that is less
fatiguing to your eyes given the ambient lighting conditions, where
you'll have a muted theme for a dark room and a high-contrast theme for
use in a bright one.

Writing code, you want a status bar, ruler, a hint of transparency and
a programming font. But if you're writing an essay or screenplay, you
want the screen stripped of all extraneous detail, with a traditional
font and generous left and right margins.

Managing such an multi-theme environment in Vim has traditionally been
a hassle. The _thematic_ plugin is intended to solve that problem,
providing you flexibility and convenience.

GUI-based Vim users can complement a colorscheme with a particular
typeface. For example, the lightweight anti-aliased typeface like
Adobe's _Source Code Pro ExtraLight_ may look great against a black
background but be unreadable against a white one, so you’ll only pair it
with an appropriate colorscheme.

Or for a particular typeface you may want a larger
[leading](http://en.wikipedia.org/wiki/Leading) to reduce crowding of
lines. See the `linespace` option.

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

If you don't specify a `colorscheme`, _thematic_ will attempt to load one
using your theme name.

You can also specify a dictionary of default values, to be shared by all
of your themes:

```vim
let g:thematic#defaults = {
\ 'airline-theme': 'jellybeans',
\ 'background': 'dark',
\ 'laststatus': 2,
\ }
```

Note that an explicit setting in a theme will take precedence over these
defaults.

_thematic_ stays out of your way, ignoring any settings that you aren't
explicitly setting through your _thematic_ configuration. For example, you
can `set guifont=` in your .gvimrc independent of _thematic_.

GUI-based Vim users have additional options available in theming. For example,

```vim
let g:thematic#themes = {
\ 'bubblegum'  : { 'typeface': 'Menlo',
\                  'font-size': 18,
\                  'linespace': 2,
\                },
\ 'solar_dark' : { 'colorscheme': 'solarized',
\                  'typeface': 'Source Code Pro Light',
\                  'font-size': 20,
\                  'linespace': 8,
\                },
\ 'solar_lite' : { 'colorscheme': 'solarized',
\                  'typeface': 'Source Code Pro',
\                  'font-size': 20,
\                  'linespace': 6,
\                },
\ }
```

### Commands

Running `:ThematicFirst` invokes _thematic_ and chooses the first theme.
Note that your themes will be ordered alphabetically by name.

```vim
:ThematicFirst         " switch to the first theme, ordered by name
:ThematicNext          " switch to the next theme, ordered by name
:ThematicPrevious      " switch to the previous theme, ordered by name
:ThematicRandom        " switch to a random theme
:ThematicOriginal      " revert to the original theme
:Thematic {theme_name} " load a theme by name (with tab completion)
```

_thematic_ does not map any keys by default, but you can easily do so in
your `.vimrc` file:

```vim
nnoremap <Leader>T :ThematicNext<CR>
nnoremap <Leader>I :Thematic iawriter<CR>
```

## What theme properties can I set?

Many properties are available for terminal-only and GUI-based Vim.

Note that you can set these properties in `g:thematic#defaults` and
`g:thematic#themes`, where a setting in the latter overrides a setting in
the former.

For terminal or GUI-based Vim:
* `laststatus` (0, 1, or 2) - controls the visibility of the status bar
* `ruler` (0 or 1) - as alternative to status bar, shows minimal position
  details in lower right
* `colorscheme` ('pencil', e.g.) - set the colors for all windows
  (optional if your theme name is the same as the colorscheme name)
* `background` ('dark' or 'light') - colorschemes like solarized can be
  further configured via background
* `airline-theme` ('jellybeans', e.g.) - plugin for theming your status
  bar
* `sign-column-color-fix` (0 or 1) - temporarily modifies colorscheme to
  force gutter background to match Normal background
* `diff-color-fix` (0 or 1) - temporarily modifies colorscheme to force
  diff character color to a standard red/green/yellow/blue
* `fold-column-color-mute` (0 or 1) - temporarily modifies colorscheme to
  hide indicators, matching Normal text background
* `number-column-color-mute` (0 or 1) - temporarily modifies colorscheme
  to hide numbers, matching Normal text background

The following options are for GUI-based Vim only (they will be ignored if
you're running a terminal-based Vim):

Typography-related:

* `typeface` ('Source Code Pro ExtraLight', e.g.) - name of font
* `font-size` (1+) - point size of font
* `linespace` (0+) - pixel spacing between lines to allow the type to breathe

Screen-related:

* `fullscreen` (0 or 1) - if 1, force a switch to fullscreen
* `fullscreen-background-color-fix` (0 or 1) - optional change of color of
  the background (or border) to match Normal text background
* `columns` (1+) and `lines` (1+) - typically used to manage the height
  and width the text area in `fullscreen` mode
* `transparency` (0=opaque, 100=fully transparent) - view details of
  window and desktop beneath Vim

## GUI fullscreen capabilities

_thematic_ supports fullscreen capabilities for GUI-based Vim, including
changing the fullscreen background to match the text background.

Note that when installed on a GUI-based Vim, _thematic_ will override the
fullscreen settings, specifically `fuoptions` to get better control over
screen lines and columns and the fullscreen background.

## FAQ

### Q: I want to set `cursorline`, `wrap`, `textwidth`, `foldcolumn`, etc. in my themes.

_thematic_ focuses exclusively on global settings. The settings above are
not globally-scoped but are instead scoped to individual buffers and
windows. Those are best set using the `autocmd FileType` feature in Vim.

In addition, settings like `textwidth` will modify your documents, which
this plugin strenuously avoids.

### Q: How can I configure Vim to emulate markdown editors like IA Writer?

It works best with fullscreen in a GUI-based Vim. A few steps are
involved:

(1) Install a couple plugins and a suitable colorscheme:

* [vim-markdown](https://github.com/tpope/vim-markdown) - support for
  editing markdown text
* [vim-pencil](https://github.com/reedes/vim-pencil) - to configure
  buffers for word processing
* [vim-colors-pencil](https://github.com/reedes/vim-colors-pencil) - an
  iAWriter-like colorscheme

(2) Edit your `.gvimrc` to disable the tool bar, etc.

```vim
set antialias
set guicursor+=a:blinkon0    " disable cursor blink
set guioptions-=r   "kill right scrollbar
set guioptions-=l   "kill left scrollbar
set guioptions-=L   "kill left scrollbar multiple buffers
set guioptions-=T   "kill toolbar
```

(3) Finally, create a theme configured to your tastes. Here's an example
for MacVim:

```vim
let g:thematic#themes = {
\ 'iawriter'   : { 'colorscheme': 'pencil',
\                  'background': 'light',
\                  'columns': 75,
\                  'font-size': 20,
\                  'fullscreen': 1,
\                  'laststatus': 0,
\                  'linespace': 8,
\                  'typeface': 'Cousine',
\                },
...
\ }
```

Non-GUI terminal-based emulation is trickier, as there's no easy way to
create a generous right margin. You can approximate it by switching from
soft-wrap to hard line breaks with `vim-pencil` and using with a narrow
`textwidth`:

```vim
autocmd FileType markdown set foldcolumn=12 textwidth=74
```

### Q: Using MacVim, the fullscreen background color isn't working as expected. How do I change its behavior?

To have the fullscreen background's color set by _thematic_, enter the
following in OS X Terminal:

```
$ defaults write org.vim.MacVim MMNativeFullScreen 0
```

Or, if you prefer that your fullscreen window float against a standard
background:

```
$ defaults write org.vim.MacVim MMNativeFullScreen 1
```

## Monospaced fonts

Whether using terminal or GUI-based Vim, a good monospaced font can
improve your editing experience. Many are available to download for free:

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

Note that you already have a few installed, such as ‘Menlo’ on OS X.

## Related projects

If this project is not to your liking, you might enjoy:

* [vim-ultimate-colorscheme-utility](https://github.com/biskark/vim-ultimate-colorscheme-utility)
* [stylish](https://github.com/mislav/stylish.vim)
* [vim-session](https://github.com/xolox/vim-session)
* [vim-obsession](https://github.com/tpope/vim-obsession)

## See also

If you like this plugin, you might like these others from the same author:

* [vim-lexical](http://github.com/reedes/vim-lexical) - Building on Vim’s spell-check and thesaurus/dictionary completion
* [vim-litecorrect](http://github.com/reedes/vim-litecorrect) - Lightweight auto-correction for Vim
* [vim-quotable](http://github.com/reedes/vim-quotable) - extends Vim to support typographic (‘curly’) quotes
* [vim-pencil](http://github.com/reedes/vim-pencil) - Extending Vim to better support writing prose and documentation
* [vim-colors-pencil](http://github.com/reedes/vim-colors-pencil) — A color scheme for Vim inspired by IA Writer

## Future development

If you’ve spotted a problem or have an idea on improving this plugin,
please post it to the github project issue page.

<!-- vim: set tw=74 :-->
