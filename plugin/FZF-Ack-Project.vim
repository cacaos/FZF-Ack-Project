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
function! s:findPif2()
    let b:ProjectRoot = ""
    let lastcomma = ""
	let dir = expand("%:p:h")
	let thisDir = expand("%:p:h")
	for curDir in split(expand("%:p:h"),"\\")
		for filename in g:Project_Identification_Files
			let file = findfile(filename,thisDir, 1)
			if filereadable(file)
				let b:ProjectRoot = fnamemodify(file, ':p:h')
				break
			endif
		endfor
		if (b:ProjectRoot != "")
			break
		endif
		if (lastcomma == "")
			let thisDir = strpart(dir,0)
			let lastcomma = strridx(dir, "\\")
		else	
			let thisDir = strpart(dir,0,lastcomma)
			let lastcomma = strridx(dir, "\\", lastcomma - 1)
		endif
	endfor
endfunction

function! s:findPif()
    let b:ProjectRoot = ""
	for filename in g:NTPNames
		let file = findfile(filename, expand("%:p:h") . ';')
		if filereadable(file)
			let b:ProjectRoot = fnamemodify(file, ':p:h')
			break
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
		let b:cmd = 'FZF! '
	else
		let b:cmd = 'FZF '
	endif
	call s:toggle(a:000)
endfunction


"Function: s:toggleAck() {{{2
"vixy Ack my ly
"
"Args:
"ke ui ys ! bc ui,ke ys yr cj uu mo ui , lu jy xr xd iu wl 
function! s:toggleAck(bang, ...)
	if a:bang 	
        let b:cmd = 'Ack '
	else
        let b:cmd = 'Ack! '
	endif
	call s:toggle(a:000)
endfunction

function! s:toggle(args)
    if !exists('b:cmd')
        echo 'not found cmd'
    else
        let args = copy(a:args)
        if(len(args) == 1)
            if stridx(b:cmd,"FZF") != -1
                let b:cmd .= "-q " 
            endif
        endif

        for argStr in args
            let b:cmd .= argStr
            let b:cmd .= " " 
        endfor
        if (b:ProjectRoot != "")
            let b:cmd .= b:ProjectRoot
        else
            let b:cmd .= expand("%:p:h")
        endif
        let msg = "execute: "
        let msg .= b:cmd
        let choice = confirm(msg, "&Yes \n&No ")
        if choice == 1
            execute b:cmd
        else
            echo "execute quit"
        endif
    endif
endfunction


command! -nargs=* -complete=dir  -bang RFZF :call s:toggleFZF(<bang>0, <f-args>)
command! -bang -nargs=* -complete=file RAck :call s:toggleAck(<bang>0, <q-args>)

autocmd BufNewFile,BufRead * call s:findPif()
