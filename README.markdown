# vim-thematic

> Conveniently manage Vim’s appearance to suit your task and environment

![demo](http://i.imgur.com/xfx69v3.gif)

## Features

* Groups global settings (like colorscheme, ruler, etc.) into ‘themes’
* Pure Vimscript with no dependencies
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
\ 'pencil_dark' :{'colorscheme': 'pencil',
\                 'background': 'dark',
\                 'airline-theme': 'badwolf',
\                 'ruler': 1,
\                },
\ 'pencil_lite' :{'colorscheme': 'pencil',
\                 'background': 'light',
\                 'airline-theme': 'light',
\                 'ruler': 1,
\                },
\ }
```

Name your themes as you wish. Note that if you don't specify a
`colorscheme` property, _thematic_ will attempt to load one using your
theme name. (See bubblegum and jellybeans example above.)

To curb redundancy among your themes, you can specify a dictionary of
default values, to be shared by all of your themes:

```vim
let g:thematic#defaults = {
\ 'airline-theme': 'jellybeans',
\ 'background': 'dark',
\ 'laststatus': 2,
\ }
```

Note that an explicit setting in a theme will take precedence over these
defaults.

GUI-based Vim users have additional options available in theming. For example,

```vim
let g:thematic#themes = {
\ 'bubblegum'  : { 'typeface': 'Menlo',
\                  'font-size': 18,
\                  'transparency': 10,
\                  'linespace': 2,
\                },
\ 'pencil_dark' :{ 'colorscheme': 'pencil',
\                  'background': 'dark',
\                  'airline-theme': 'badwolf',
\                  'ruler': 1,
\                  'laststatus': 0,
\                  'typeface': 'Source Code Pro Light',
\                  'font-size': 20,
\                  'transparency': 10,
\                  'linespace': 8,
\                },
\ 'pencil_lite' :{ 'colorscheme': 'pencil',
\                  'background': 'light',
\                  'airline-theme': 'light',
\                  'laststatus': 0,
\                  'ruler': 1,
\                  'typeface': 'Source Code Pro',
\                  'fullscreen': 1,
\                  'transparency': 0,
\                  'font-size': 20,
\                  'linespace': 6,
\                },
\ }
```

_thematic_ stays out of your way, ignoring any settings that you aren't
explicitly setting through your _thematic_ configuration. For example, you
can `set guifont=` in your .gvimrc independent of _thematic_.

### Setting an initial theme

By default, _thematic_ doesn’t initialize a theme when you start Vim.

But you can have it do so by specifying a theme to load in your `.vimrc`:

```vim
let g:thematic#theme_name = 'pencil_dark'
```

### Commands

Commands can be used to navigate through your available themes. For
instance, running `:ThematicFirst` invokes _thematic_ and chooses the
first theme, alphabetically.

```vim
:Thematic {theme_name} " load a theme by name (with tab completion)
:ThematicFirst         " switch to the first theme, ordered by name
:ThematicNext          " switch to the next theme, ordered by name
:ThematicPrevious      " switch to the previous theme, ordered by name
:ThematicRandom        " switch to a random theme
```

_thematic_ does not map any keys by default, but you can easily do so in
your `.vimrc` file:

```vim
nnoremap <Leader>T :ThematicNext<CR>
nnoremap <Leader>D :Thematic pencil_dark<CR>
nnoremap <Leader>L :Thematic pencil_lite<CR>
```

### What theme properties can I set?

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
* `background` ('dark' or 'light') - colorschemes like pencil and
  solarized can be further configured via background
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
  and width of the text area in `fullscreen` mode
* `transparency` (0=opaque, 100=fully transparent) - view details of
  window and desktop beneath Vim

## GUI fullscreen capabilities

_thematic_ supports fullscreen capabilities for GUI-based Vim, including
changing the fullscreen background to match the text background.

### Disabling fullscreen

By design, once enabled, _thematic_ won't disable fullscreen, as it can
erode the user experience. You can still disable manually per the
command:

```
:set nofullscreen
```

Note that when installed on a GUI-based Vim, _thematic_ will override the
fullscreen settings, specifically `fuoptions` to get better control over
screen lines and columns and the fullscreen background.

### Narrow and Widen

To narrow and widen the visible screen area _without_ changing the font
size, _thematic_ provides a couple of handy commands you can map to keys
of your choice. For example, to map this feature to the `Command-9` and
`Command-0` keys in MacVim, add to your `.gvimrc`:

```vim
noremap <silent> <D-9> :<C-u>ThematicNarrow<cr>
noremap <silent> <D-0> :<C-u>ThematicWiden<cr>
inoremap <silent> <D-9> <C-o>:ThematicNarrow<cr>
inoremap <silent> <D-0> <C-o>:ThematicWiden<cr>
```

This is especially useful in fullscreen mode to adjust the side margins.
It also complements `Command-Minus` and `Command-Equals` to adjust font
size.

## FAQ

### Q: I want to set `cursorline`, `wrap`, `textwidth`, `foldcolumn`, etc. in my themes.

At present, _thematic_ focuses exclusively on global settings. The
settings above are not globally-scoped but are instead scoped to
individual buffers and windows. Until we determine a good approach to
support these 'lesser' scoped settings, you can set them for all
buffers via your `.vimrc` or by file type using the `autocmd FileType`
feature in Vim.

Settings that actively modify your files, such as `textwidth`, aren't
likely to ever be part of _thematic_.

### Q: How can I configure Vim to emulate markdown editors like IA Writer?

It works best with fullscreen in a GUI-based Vim. A few steps are
involved:

(1) Install a word processing plugin like `pencil` and a suitable
colorscheme:

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

(3) Finally, create a theme configured to your tastes:

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

See the “Narrow and Widen” feature above to adjust the side margins
interactively.

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

(Note: due to OSX/MacVim bugs, `fullscreen` may or may not work 
for you in Yosemite (OS X 10.10). For example, you might encounter a persistent 
menu bar, an odd screen offset, or screen tearing. In such cases, try 
`set lines=` or `set columns=` with reduced values to fix things.) 

### Q: How can I apply my own custom highlights?

_thematic_ doesn't yet support theme-specific customization beyond the `-fix`
and `-mute` options mentioned above, but you can ensure that custom highlights
are used in your `.vimrc`, for example:

```vim
augroup MyCustomHighlights
  autocmd!
  autocmd colorscheme *
   \ highlight SpellBad   gui=bold guibg=#faa |
   \ highlight SpellCap   gui=bold guibg=#faf |
   \ highlight SpellRare  gui=bold guibg=#aff |
   \ highlight SpellLocal gui=bold guibg=#ffa
augroup END
```

This will apply across all themes, as well as manual colorscheme changes.

### Q: In certain cases, the screen doesn’t properly redraw. Can you fix this?

You have encountered an outstanding bug that hasn’t yet been diagnosed and
fixed. In the meantime, set up a handy key to force a redraw when the
redraw does not occur. In your `.vimrc`:

```vim
" <c-l> to clear the highlight, as well as redraw the screen
noremap <silent> <C-l> :<C-u>nohlsearch<cr><C-l>
inoremap <silent> <C-l> <C-o>:nohlsearch<cr>
```

If you can fix this problem, a pull request would be welcome.

## Monospaced fonts

Whether using terminal or GUI-based Vim, a good monospaced font can
improve your editing experience. You already have a few installed (such
as Menlo on OS X.) Many more are available to download for free:

* [Cutive Mono](http://www.google.com/fonts/specimen/Cutive+Mono) (serif)
* [Droid Sans Mono](http://www.google.com/fonts/specimen/Droid+Sans+Mono)
* [Hermit](https://pcaro.es/p/hermit/)
* [Inconsolata](http://www.google.com/fonts/specimen/Inconsolata) (2 weights)
* [Linux Libertine Mono O](http://sourceforge.net/projects/linuxlibertine/) (serif)
* [Meslo](https://github.com/andreberg/Meslo-Font)
* [Oxygen Mono](https://www.google.com/fonts/specimen/Oxygen+Mono)
* [PT Mono](http://www.google.com/fonts/specimen/PT+Mono)
* [Share Tech Mono](http://www.google.com/fonts/specimen/Share+Tech+Mono)
* [Source Code Pro](http://www.google.com/fonts/specimen/Source+Code+Pro) (7 weights)

The following collections feature **bold** and *italic* variations,
to make the most of colorschemes that use them:

* [Anonymous Pro](https://www.google.com/fonts/specimen/Anonymous+Pro) (serif)
* [Courier Prime](http://quoteunquoteapps.com/courierprime/) (serif)
* [Cousine](http://www.google.com/fonts/specimen/Cousine)
* [DejaVu Sans Mono](http://dejavu-fonts.org/wiki/Download)
* [Fantasque Sans Mono](http://openfontlibrary.org/en/font/fantasque-sans-mono)
* [Liberation](https://fedorahosted.org/liberation-fonts/)
* [Luxi Mono Regular](http://www.fontsquirrel.com/fonts/Luxi-Mono) (serif)
* [Ubuntu Mono](https://www.google.com/fonts/specimen/Ubuntu+Mono)

## See also

If you find this plugin useful, you may want to check out these others by
[@reedes][re]:

* [vim-colors-pencil][cp] - color scheme for Vim inspired by IA Writer
* [vim-lexical][lx] - building on Vim’s spell-check and thesaurus/dictionary completion
* [vim-litecorrect][lc] - lightweight auto-correction for Vim
* [vim-one][vo] - make use of Vim’s _+clientserver_ capabilities
* [vim-pencil][pn] - rethinking Vim as a tool for writers
* [vim-textobj-quote][qu] - extends Vim to support typographic (‘curly’) quotes
* [vim-textobj-sentence][ts] - improving on Vim's native sentence motion command
* [vim-wheel][wh] - screen-anchored cursor movement for Vim
* [vim-wordy][wo] - uncovering usage problems in writing

[re]: http://github.com/reedes
[cp]: http://github.com/reedes/vim-colors-pencil
[lx]: http://github.com/reedes/vim-lexical
[lc]: http://github.com/reedes/vim-litecorrect
[vo]: http://github.com/reedes/vim-one
[pn]: http://github.com/reedes/vim-pencil
[ts]: http://github.com/reedes/vim-textobj-sentence
[qu]: http://github.com/reedes/vim-textobj-quote
[wh]: http://github.com/reedes/vim-wheel
[wo]: http://github.com/reedes/vim-wordy

## Future development

If you’ve spotted a problem or have an idea on improving this plugin,
please post it to the github project issue page. Pull requests are
welcome.

<!-- vim: set tw=74 :-->
