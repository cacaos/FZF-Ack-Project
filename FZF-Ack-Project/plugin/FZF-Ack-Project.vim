" The MIT License (MIT)

" Copyright (c) 2013-2021 Junegunn Choi

" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:

" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.

" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.

if exists('g:loaded_fzf_ack_project') || version < 700
	finish
endif
let g:loaded_fzf_ack_project = 1

"xd mu gf mu lu bc ui wf jm 
if !exists("g:Project_Identification_Files")
	let g:Project_Identification_Files = ['pom.xml','.gitignore','README','build.xml', 'Makefile', '.project', '.vimrc']
endif

"Function: s:findPif() {{{3
"xd uh jm so wf jm vi gf mu lu
"Add the |+file_in_path| feature at compile time,maybe
"ta hv yi vi xd uh jm so vi gf mu lu, uf vs
function! s:findPif()
	let dir = expand("%:p:h")
	let thisDir = expand("%:p:h")
	let dirLen = len(split(expand("%:p:h"),"\\")) + 1
	for curDir in split(expand("%:p:h"),"\\")
		for filename in g:Project_Identification_Files
			let file = findfile(filename,thisDir, 1)
			if filereadable(file)
				let b:ProjectRoot = fnamemodify(file, ':p:h')
				break
			endif
		endfor
		if exists("b:ProjectRoot")
			break
		endif
		if !exists("lastcomma")
			let thisDir = strpart(dir,0)
			let lastcomma = strridx(dir, "\\")
		else	
			let thisDir = strpart(dir,0,lastcomma)
			let lastcomma = strridx(dir, "\\", lastcomma - 1)
		endif
	endfor
endfunction

"Function: s:toggleFZF() {{{2
"vi xy FZF  
"
"Args:
"ke ui ys ! bc ui,ke ys yr cj uu mo ui , lu jy xr xd iu wl 

function! s:toggleFZF(bang, ...)
	if a:bang 	
		let cmd = 'FZF '
	else
		let cmd = 'FZF! '
	endif

	let args = copy(a:000)
	for argStr in args
		let cmd .= argStr
		let cmd .= " " 
	endfor
	call s:findPif()
	if exists('b:ProjectRoot')
		let cmd .= b:ProjectRoot
	else
		let cmd .= expand("%:p:h")
	endif
	echo cmd
	execute cmd
endfunction


"Function: s:toggleAck() {{{2
"vixy Ack my ly
"
"Args:
"ke ui ys ! bc ui,ke ys yr cj uu mo ui , lu jy xr xd iu wl 
function! s:toggleAck(...)
	let cmd = 'Ack '
	let args = copy(a:000)
	for argStr in args
		let cmd .= argStr
		let cmd .= " " 
	endfor
	call s:findPif()
	if exists('b:ProjectRoot')
		let cmd .= b:ProjectRoot
	else
		let cmd .= expand("%:p:h")
	endif
	echo cmd
	execute cmd
endfunction

command! -nargs=* -complete=dir  -bang RFZF :call s:toggleFZF(<bang>0, <f-args>)
command! -bang -nargs=* -complete=file RAck :call s:toggleAck(<q-args>)
