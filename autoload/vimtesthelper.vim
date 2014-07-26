scriptencoding utf-8

let s:cpo_bak = &cpoptions
lockvar s:cpo_bak
set cpoptions&vim

let s:vital = vital#of('vimtest-helper')
let s:vfp = s:vital.import('System.Filepath')

function! vimtesthelper#isTestFilePath(path)
	" [TODO] Think about error handling for the argument.

	let path = s:vfp.unify_separator(fnamemodify(a:path, ':p'))

	return path =~# '\m/test/.\+_test\.vim$'
endfunction

let &cpoptions = s:cpo_bak
unlockvar s:cpo_bak
