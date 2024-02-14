const s:deincache = ($XDG_CACHE_HOME ?? expand('~/.cache')) .. '/dein'

function! s:deinsetup() abort
  call dein#options(#{
        \ install_progress_type: 'floating',
        \ auto_remote_plugins: v:true,
        \ lazy_rplugins: v:true,
        \ install_check_diff: v:true,
        \ enable_notification: v:true,
        \ })
  if dein#min#load_state(s:deincache)
    const here = stdpath('config')
    call dein#begin(s:deincache)
    const configdir = $'{here}/plugins.d'
    call map(
          \ readdir(configdir),
          \ { _, path ->
          \   path->fnamemodify(':e') ==# 'toml'
          \     ? dein#load_toml($'{configdir}/{path}')
          \     : v:null
          \ }
          \)
    call dein#end()
    if dein#check_install()
      call dein#install()
    endif
    call dein#save_state()
  endif
endfunction

const s:deinrtp = s:deincache .. '/repos/github.com/Shougo/dein.vim'
execute $'set runtimepath^={s:deinrtp}'
try
  call s:deinsetup()
catch /^\%(Vim\%((\a\+)\)\=:\)\{,1}E117:/
  echom system([
        \ 'git',
        \ 'clone',
        \ 'https://github.com/Shougo/dein.vim.git',
        \ s:deinrtp,
        \ ])
  call s:deinsetup()
endtry

" vim:ft=vim expandtab tabstop=2 shiftwidth=2
