scriptencoding utf-8

let s:cpo_bak = &cpoptions
lockvar s:cpo_bak
set cpoptions&vim

let s:sfile = expand('<sfile>:p')
lockvar s:sfile
let s:headOfPath = matchstr(s:sfile, '\m^.\{-}/')
lockvar s:headOfPath

let s:t = vimtest#new('vimtesthelper#isTestFilePath()') " {{{
	function! s:t.startup()
		let self._F = function('vimtesthelper#isTestFilePath')
		lockvar self._F
	endfunction

	function! s:t.should_return_1_when_the_argument_is_file_path_contains_test_directory_and_file_root_ended_test()
		call self.assert.equals(1, self._F('/test/foo_test.vim'))
	endfunction

	function! s:t.should_return_0_when_the_argument_is_file_path_contains_test_directory_only()
		call self.assert.equals(0, self._F('/test'))
	endfunction

	function! s:t.should_return_0_when_the_argument_is_file_path_contains_test_ending_filename_only()
		call self.assert.equals(0, self._F('foo_test.vim'))
	endfunction
" }}}

let s:t = vimtest#new('vimtesthelper#getTestFilePathCandidates()') " {{{
	function! s:t.startup()
		let self._F = function('vimtesthelper#getTestFilePathCandidates')
		lockvar self._F
	endfunction

	function! s:t.should_return_test_file_path_candidates()
		let patterns = {
		\	s:headOfPath . 'foo.vim': [
		\		s:headOfPath . 'test/foo_test.vim'
		\	],
		\	s:headOfPath . 'foo/bar.vim': [
		\		s:headOfPath . 'test/foo/bar_test.vim',
		\		s:headOfPath . 'foo/test/bar_test.vim'
		\	]
		\ }

		for k in keys(patterns)
			call self.assert.equals(sort(patterns[k]), sort(self._F(k)))
		endfor
	endfunction
" }}}

let s:t = vimtest#new('vimtesthelper#getProductFilePathCandidates()') " {{{
	function! s:t.startup()
		let self._F = function('vimtesthelper#getProductFilePathCandidates')
		lockvar self._F
	endfunction

	function! s:t.should_return_product_file_path_candidates()
		let patterns = {
		\	'/test/foo_test.vim': [
		\		'/foo.vim'
		\	],
		\	'/foo/test/bar_test.vim': [
		\		'/foo/bar.vim'
		\	],
		\	'/test/foo/bar_test.vim': [
		\		'/foo/bar.vim'
		\	],
		\	'/test/foo/test/bar_test.vim': [
		\		'/foo/test/bar.vim',
		\		'/test/foo/bar.vim',
		\	],
		\ }

		for k in keys(patterns)
			call self.assert.equals(sort(patterns[k]), sort(self._F(k)))
		endfor
	endfunction

	function! s:t.should_throw_error_when_the_argument_not_matched_the_test_file_path_format()
		" Don't decide the error string.
		call self.assert.throw_pattern('\m.')

		call self._F('')
		call self._F('/test/foo.vim')
		call self._F('/foo/bar_test.vim')
	endfunction
" }}}

unlockvar s:sfile
unlockvar s:headOfPath

let &cpoptions = s:cpo_bak
unlockvar s:cpo_bak
