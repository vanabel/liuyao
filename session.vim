let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd E:\cygwin64\home\van\development\nodejs-dev\liuyao
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +1 E:\cygwin64\home\van\development\nodejs-dev\liuyao\deploy.sh
badd +3 E:\cygwin64\home\van\development\nodejs-dev\liuyao\vue.config.js
badd +5 E:\cygwin64\home\van\development\nodejs-dev\vue-login\server\package.json
badd +1 ~\liuyao.sh
badd +14 ~\liuy.sh
badd +1 ~\liuyao-data
badd +80 E:\cygwin64\home\van\development\nodejs-dev\liuyao\src\conn.js
badd +1 ~\myvim.bat
badd +64 E:\cygwin64\home\van\development\nodejs-dev\liuyao\src\components\Yaogua.vue
badd +3 ~\.vuerc
badd +1 D:\Program\ Files\frp\frpc.ini
badd +2 ~\vimfiles\vimrc
argglobal
silent! argdel *
$argadd D:\Program\ Files\frp\frpc.ini
set lines=48 columns=211
edit ~\vimfiles\vimrc
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 872 - ((871 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
872
normal! 0
tabedit E:\cygwin64\home\van\development\nodejs-dev\liuyao\deploy.sh
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 23 - ((22 * winheight(0) + 22) / 45)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
23
normal! 046|
tabnext 2
if exists('s:wipebuf')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToO
set winminheight=1 winminwidth=1
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
