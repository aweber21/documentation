"
" Documentation syntax highlighting
"

"=== Font Styles ==="
syntax		cluster	FontStyles		contains=Bold,Italic,Underline

" Bold
syntax		match	Bold			/\*[^*]*\*/
highlight			Bold			ctermfg=NONE
						\			ctermbg=NONE
						\			cterm=bold

" Italic
syntax		match	Italic			/\~[^~]*\~/
highlight			Italic			ctermfg=NONE
						\			ctermbg=NONE
						\			cterm=italic

" Underline
syntax		match	Underline		/_[^_]*_/
highlight			Underline		ctermfg=NONE
						\			ctermbg=NONE
						\			cterm=underline

"=== Quotes ==="
syntax		cluster	Quotes			contains=SingleQuotes,DoubleQuotes
highlight			Quotes			ctermfg=Yellow
						\			ctermbg=NONE
						\			cterm=NONE

" SingleQuotes
syntax		region	SingleQuotes	start=/'/
						\			skip=/\\./
						\			end=/'/
						\			contains=@FontStyles
highlight	link	SingleQuotes	Quotes

" DoubleQuotes
syntax		region	DoubleQuotes	start=/"/
						\			skip=/\\./
						\			end=/"/
						\			contains=@FontStyles
highlight	link	DoubleQuotes	Quotes

"=== ListItems ==="
syntax		cluster	ListItems		contains=ListItem1,ListItem2
highlight			ListItems		ctermfg=Yellow
						\			ctermbg=NONE
						\			cterm=NONE

" ListItem1
syntax		match	ListItem1		/^\s*-\s/
highlight	link	ListItem1		ListItems

" ListItem2
syntax		match	ListItem2		/^\s*>\s/
highlight	link	ListItem2		ListItems

"=== Sections ==="
" Header
syntax		region	Header			start=/^#\{80\}$/
						\			end=/^#\{80\}$/
						\			contains=@FontStyles,@Quotes,@ListItems
						\			keepend
highlight			Header			ctermfg=Cyan
						\			ctermbg=NONE
						\			cterm=NONE

" TableOfContents
syntax		region	TableOfContents	start=/^O=\{78\}O$/
						\			end=/^O=\{78\}O$/
						\			contains=@FontStyles,@Quotes,@ListItems
						\			keepend
highlight			TableOfContents ctermfg=Yellow
						\			ctermbg=NONE
						\			cterm=NONE

" Heading
syntax		region	Heading			start=/^#=\{78\}#$/
						\			end=/^#=\{78\}#$/
						\			contains=@FontStyles,@Quotes,@ListItems
						\			keepend
highlight			Heading			ctermfg=Magenta
						\			ctermbg=NONE
						\			cterm=NONE

" Subheading1
syntax		region	Subheading1		start=/#===\s\([0-9]*\.\)\{2\}\s/
						\			end=/\s===#$/
						\			contains=@FontStyles,@Quotes,@ListItems
						\			keepend oneline
highlight			Subheading1		ctermfg=Green
						\			ctermbg=NONE
						\			cterm=NONE

" Subheading2
syntax		region	Subheading2		start=/#===\s\([0-9]*\.\)\{3\}\s/
						\			end=/\s===#$/
						\			contains=@FontStyles,@Quotes,@ListItems
						\			keepend oneline
highlight			Subheading2		ctermfg=Blue
						\			ctermbg=NONE
						\			cterm=NONE

" Subheading3
syntax		region	Subheading3		start=/#===\s\([0-9]*\.\)\{4\}\s/
						\			end=/\s===#$/
						\			contains=@FontStyles,@Quotes,@ListItems
						\			keepend oneline
highlight			Subheading3		ctermfg=Red
						\			ctermbg=NONE
						\			cterm=NONE
