# vim-thematic

> Conveniently manage Vim’s appearance to suit your task and environment

* Groups global settings (like colorscheme) into ‘themes’
* Stays out of your way, except where you want it
* No predefined key mappings to interfere with your other mappings
* Integrates with [airline](https://github.com/bling/vim-airline)
* Support for GUI-based Vim includes: font, linespace, fullscreen,
  transparency, and screen columns/lines

## Why thematic?

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
a hassle. The thematic plugin is intended to solve that problem,
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

GUI-based Vim users have additional options available in theming. For example,

```vim
let g:thematic#defaults = {
...
\ 'font-size': 20,
\ 'transparency': 0,
\ }
```
    
```vim
let g:thematic#themes = {
\ 'bubblegum'  : { 'typeface': 'Cutive Mono',
\                  'linespace': 9,
\                },
\ 'matrix'     : { 'colorscheme': 'base16-greenscreen',
\                  'font-size': 24,
\                  'linespace': 9,
\                  'typeface': 'Dot Matrix',
\                  'transparency': 10,
\                },
\ 'solar_dark' : { 'colorscheme': 'solarized',
\                  ...
\                  'typeface': 'Source Code Pro Light',
\                },
\ 'solar_lite' : { 'colorscheme': 'solarized',
\                  ...
\                  'font-size': 20,
\                  'linespace': 8,
\                  'typeface': 'Source Code Pro',
\                },
\ 'iawriter'   : { 'colorscheme': 'reede_light',
\                  ...
\                  'columns': 75,
\                  'font-size': 20,
\                  'fullscreen': 1,
\                  'linespace': 8,
\                  'typeface': 'Menlo',
\                },
\ }
```

### Commands

Running `:ThematicFirst` invokes thematic and chooses the first theme.
Note that your themes will be ordered alphabetically by name.

```vim
:ThematicFirst         " switch to the first theme, ordered by name
:ThematicNext          " switch to the next theme, ordered by name
:ThematicPrevious      " switch to the previous theme, ordered by name
:ThematicRandom        " switch to a random theme
:ThematicOriginal      " revert to the original theme
:Thematic {theme_name} " load a theme by name (with tab completion)
```

thematic does not map any keys by default, but you can easily do so in
your `.vimrc` file:

```vim
nnoremap <Leader>T <Plug>ThematicNext
```

## What theme properties can I set?

For each theme you specify one or more properties.

For console or GUI-based Vim:
* `laststatus` (0, 1, or 2) - controls the visibility of the status bar
* `ruler` - as alternative to status bar, shows minimal position details
  in lower right
* `colorscheme` - set the colors for all windows (optional if your theme
  name is the same as the colorscheme name)
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

The following options are for GUI-based Vim only:

Typography-related:

* `typeface` - name of font
* `font-size` - point size of font
* `linespace` (0+) - additional pixel spacing between lines

Screen-related:

* `fullscreen` - if 1, force a switch to fullscreen
* `fullscreen-background-color-fix` - optional change of color of the
  background (or border) to match text background
* `columns` and `lines` - you’ll mostly use these to manage the height
  and width the text area in `fullscreen` mode
* `transparency` (0=opaque, 100=fully transparent) - view details of
  window and desktop beneath Vim

## GUI fullscreen capabilities

thematic supports fullscreen capabilities for GUI-based Vim, including
typeface, font-size, lines, columns, linespace, transparency and even the
fullscreen background.

Note that once invoked, thematic will override your fullscreen settings,
specifically `fuoptions` to get better control over screen lines and
columns and the fullscreen background.

## FAQ

### Q: I want to set `cursorline`, `wrap`, `textwidth`, `foldcolumn`, etc. in my themes.

thematic focuses exclusively on global settings. The settings above are
not globally-scoped but are instead scoped to individual buffers and
windows. These are best set using the `FileType` feature in Vim.

In addition, settings like `textwidth` will modify your documents, which
this plugin strenuously avoids.

### Q: How can I configure Vim to emulate markdown editors like IAWriter?

It works best with GUI Vim's fullscreen. A few steps are involved:

(1) Install a couple of plugins:

* [vim-markdown](https://github.com/tpope/vim-markdown) - support for editing markdown
* [vim-writer](https://github.com/reedes/vim-writer) - to configure for word processing

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

Without GUI-based Vim, console-based emulation is trickier, as there's
no easy way to create generous left and right margins. You can
approximate it by switching from soft-wrap to hard line breaks with
`vim-writer` and using with a narrow `textwidth`:

```vim
autocmd FileType markdown set foldcolumn=12 textwidth=74
```

### Q: Using MacVim, the fullscreen background color isn't working as expected. How do I change its behavior?

To have the fullscreen background's color set by thematic, enter the
following in OS X Terminal:

```
$ defaults write org.vim.MacVim MMNativeFullScreen 0
```

Or, if you prefer your fullscreen window to float against a standard
background:

```
$ defaults write org.vim.MacVim MMNativeFullScreen 1
```

## Monospaced fonts

Whether using console or GUI-based Vim, a good monospaced font can
improve your editing experience. Many are available for free:

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

Note that you already have a few installed, such as `Menlo` on OS X.

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
* [vim-writer](http://github.com/reedes/vim-writer) - Extending Vim to better support writing prose and documentation

## Future development

If you have any ideas on improving this plugin, please post them to the
github project issue page.

<!-- vim: set tw=74 :-->
