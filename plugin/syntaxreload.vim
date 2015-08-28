let s:syntaxTmp    = 'syntax match {n} "{p}"'
let s:highlightTmp = 'highlight {n} ctermbg={c}'

let s:syntaxPath = '~/dev/vim/syntaxreload/syntax/'
let s:syntaxFile = 'syntaxreload.vim'

" http://vimdoc.sourceforge.net/htmldoc/syntax.html#colortest.vim
let s:colors = ['black', 'darkred', 'darkgreen',
      \ 'brown', 'darkblue', 'darkmagenta',
      \ 'darkcyan', 'lightgray', 'darkgray',
      \ 'red', 'green', 'yellow',
      \ 'blue', 'magenta', 'cyan',
      \ 'white', 'grey', 'lightred',
      \ 'lightgreen', 'lightyellow', 'lightblue',
      \ 'lightmagenta', 'lightcyan']
let s:currentColor = 0

function! s:GetColor() abort
  if s:currentColor == len(s:colors)
    let s:currentColor = 0
  endif
  let s:currentColor += 1
  return s:colors[s:currentColor - 1]
endfunction

" http://stackoverflow.com/a/8498568/2558252
function! s:AddToList(list, item) abort
  call add(a:list, a:item)
  return a:item
endfunction

function! s:GetMatchingText() abort
  let l:list=[]
  " Add all matches to the list
  %s//\=<SID>AddToList(l:list, submatch(0))/n
  " Sort and remove duplicates
  let l:matches = uniq(sort(l:list))
  let l:highlights = {}
  " build the dictionnary of 
  "   match : color
  for l:match in l:matches
    let l:highlights[l:match] = <SID>GetColor()
  endfor
  return l:highlights
endfunction

function! s:ReloadSyntax() abort
  let l:elements = <SID>GetMatchingText()
  new
  let l:index = 1
  for [l:key, l:value] in items(l:elements)
    let l:syntaxString = substitute(s:syntaxTmp, '{n}', l:key, '')
    let l:syntaxString = substitute(l:syntaxString, '{p}', l:key, '')
    let l:highlightString = substitute(s:highlightTmp, '{n}', l:key, '')
    let l:highlightString = substitute(l:highlightString, '{c}', l:value, '')

    echo l:index l:syntaxString l:highlightString
    call setline(l:index, l:syntaxString)
    let l:index += 1

    call setline(l:index, l:highlightString)
    let l:index += 1
  endfor
  exec 'cd '.s:syntaxPath
  exec 'x! '.s:syntaxFile
  syntax on
endfunction

command! Reload call <SID>ReloadSyntax()
command! Match call <SID>GetMatchingText()


