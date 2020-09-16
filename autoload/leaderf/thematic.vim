function! leaderf#thematic#source(args) abort "{{{
	return keys(g:thematic#themes)
endfunction "}}}

function! leaderf#thematic#accept(line, args) abort "{{{
	execute 'Thematic ' . a:line
endfunction "}}}
