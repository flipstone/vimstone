function! neoformat#formatters#haskell#enabled() abort
  return ['project_haskell_format', 'project_stylish_haskell', 'project_hindent', 'project_brittany']
endfunction

function! neoformat#formatters#haskell#project_haskell_format() abort
  return {
        \ 'exe': './haskell-format',
        \ 'stdin': 1
        \ }
endfunction

function! neoformat#formatters#haskell#project_stylish_haskell() abort
  return {
        \ 'exe': './stylish-haskell',
        \ 'stdin': 1
        \ }
endfunction

function! neoformat#formatters#haskell#project_hindent() abort
  return {
        \ 'exe': './hindent',
        \ 'stdin': 1
        \ }
endfunction

function! neoformat#formatters#haskell#project_brittany() abort
  return {
        \ 'exe': './brittany',
        \ 'stdin': 1
        \ }
endfunction
