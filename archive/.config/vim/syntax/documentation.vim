"
" Documentation syntax highlighting
"

"=== Font Styles ==="
syntax      cluster FontStyles      contains=Bold,Italic,Underline

" Bold
syntax      match   Bold            /\*[^*]*\*/
highlight           Bold            term=bold
                        \           ctermfg=NONE    ctermbg=NONE
                        \           cterm=bold
                        \           guifg=NONE      guibg=NONE      guisp=NONE
                        \           gui=bold        font=NONE

" Italic
syntax      match   Italic          /\~[^~]*\~/
highlight           Italic          term=italic
                        \           ctermfg=NONE    ctermbg=NONE
                        \           cterm=italic
                        \           guifg=NONE      guibg=NONE      guisp=NONE
                        \           gui=italic      font=NONE


" Underline
syntax      match   Underline       /_[^_]*_/
highlight           Underline       term=underline
                        \           ctermfg=NONE    ctermbg=NONE
                        \           cterm=underline
                        \           guifg=NONE      guibg=NONE      guisp=NONE
                        \           gui=underline   font=NONE


"=== Quotes ==="
syntax      cluster Quotes          contains=SingleQuotes,DoubleQuotes
highlight           Quotes          term=NONE
                        \           ctermfg=Yellow  ctermbg=NONE
                        \           cterm=NONE
                        \           guifg=Yellow    guibg=NONE      guisp=NONE
                        \           gui=NONE        font=NONE

" SingleQuotes
syntax      region  SingleQuotes    start=/'/
                        \           skip=/\\./
                        \           end=/'/
                        \           contains=@FontStyles
highlight   link    SingleQuotes    Quotes

" DoubleQuotes
syntax      region  DoubleQuotes    start=/"/
                        \           skip=/\\./
                        \           end=/"/
                        \           contains=@FontStyles
highlight   link    DoubleQuotes    Quotes

"=== ListItems ==="
syntax      cluster ListItems       contains=ListItem1,ListItem2
highlight           ListItems       term=NONE
                        \           ctermfg=Yellow  ctermbg=NONE
                        \           cterm=NONE  
                        \           guifg=Yellow    guibg=NONE      guisp=NONE
                        \           gui=NONE        font=NONE

" ListItem1
syntax      match   ListItem1       /^\s*-\s/
highlight   link    ListItem1       ListItems

" ListItem2
syntax      match   ListItem2       /^\s*>\s/
highlight   link    ListItem2       ListItems

"=== Sections ==="
" Header
syntax      region  Header          start=/^#\{80\}$/
                        \           end=/^#\{80\}$/
                        \           contains=@FontStyles,@Quotes,@ListItems
                        \           keepend
highlight           Header          term=NONE
                        \           ctermfg=Cyan    ctermbg=NONE
                        \           cterm=NONE
                        \           guifg=Cyan      guibg=NONE      guisp=NONE
                        \           gui=NONE        font=NONE

" TableOfContents
syntax      region  TableOfContents start=/^O=\{78\}O$/
                        \           end=/^O=\{78\}O$/
                        \           contains=@FontStyles,@Quotes,@ListItems
                        \           keepend
highlight           TableOfContents term=NONE
                        \           ctermfg=Yellow  ctermbg=NONE
                        \           cterm=NONE
                        \           guifg=Yellow    guibg=NONE      guisp=NONE
                        \           gui=NONE        font=NONE

" Heading
syntax      region  Heading         start=/^#=\{78\}#$/
                        \           end=/^#=\{78\}#$/
                        \           contains=@FontStyles,@Quotes,@ListItems
                        \           keepend
highlight           Heading         term=NONE
                        \           ctermfg=Magenta ctermbg=NONE
                        \           cterm=NONE
                        \           guifg=Blue      guibg=NONE      guisp=NONE
                        \           gui=NONE        font=NONE

" Subheading1
syntax      region  Subheading1     start=/#===\s\([0-9]*\.\)\{2\}\s/
                        \           end=/\s===#$/
                        \           contains=@FontStyles,@Quotes,@ListItems
                        \           keepend oneline
highlight           Subheading1     term=NONE
                        \           ctermfg=Green   ctermbg=NONE
                        \           cterm=NONE
                        \           guifg=Green     guibg=NONE      guisp=NONE
                        \           gui=NONE        font=NONE

" Subheading2
syntax      region  Subheading2     start=/#===\s\([0-9]*\.\)\{3\}\s/
                        \           end=/\s===#$/
                        \           contains=@FontStyles,@Quotes,@ListItems
                        \           keepend oneline
highlight           Subheading2     term=NONE
                        \           ctermfg=Blue    ctermbg=NONE
                        \           cterm=NONE
                        \           guifg=Blue      guibg=NONE      guisp=NONE
                        \           gui=NONE        font=NONE

" Subheading3
syntax      region  Subheading3     start=/#===\s\([0-9]*\.\)\{4\}\s/
                        \           end=/\s===#$/
                        \           contains=@FontStyles,@Quotes,@ListItems
                        \           keepend oneline
highlight           Subheading3     term=NONE
                        \           ctermfg=Red     ctermbg=NONE
                        \           cterm=NONE
                        \           guifg=Red       guibg=NONE      guisp=NONE
                        \           gui=NONE        font=NONE

