scriptencoding utf-8

let s:cpo_bak = &cpoptions
lockvar s:cpo_bak
set cpoptions&vim

let s:vital = vital#of('vimtest-helper') " {{{
let s:vfp = s:vital.import('System.Filepath')
let s:vdl = s:vital.import('Data.List')
" Replace Vital.System.Filepath.split(), because its ignore the first "/"
" that is the first character.
function! s:filepath_split(path)
	return split(a:path, s:vfp.separator(), 1)
endfunction
let s:vfp.split = function('s:filepath_split')
" Replace Vital.System.Filepath.join(), because its is broken.
" Vital.System.Filepath.join(Vital.System.Filepath.split('/foo/bar') can't
" become '/foo/bar', become 'foo/bar'.
function! s:filepath_join(...)
	let parts = s:vdl.flatten(a:000)
	return join(parts, s:vfp.separator())
endfunction
let s:vfp.join = function('s:filepath_join')
" }}}

function! vimtesthelper#isTestFilePath(path)
	" [TODO] Think about error handling for the argument.

	let path = s:vfp.unify_separator(fnamemodify(a:path, ':p'))

	return path =~# '\m/test/.\+_test\.vim$'
endfunction

function! vimtesthelper#getTestFilePathCandidates(productFilePath)
	let productFilePath = fnamemodify(a:productFilePath, ':p')
	let productFilePath = s:vfp.unify_separator(productFilePath)
	let parts = s:vfp.split(productFilePath)
	let parts[-1] = substitute(parts[-1], '\M\ze.vim$', '_test', '')

	let candidates = []
	for i in range(1, len(parts) - 1)
		let path = s:vfp.join(insert(copy(parts), 'test', i))
		call add(candidates, path)
	endfor
	return candidates
endfunction

let &cpoptions = s:cpo_bak
unlockvar s:cpo_bak
