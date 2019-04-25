let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/development/nodejs-dev/liuyao/src/components
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +22 ~/development/python-learn/intFilter.py
badd +72 ~/development/nodejs-dev/liuyao/src/components/Yaogua.vue
badd +1248 ~/development/laravel/composer-setup.php
badd +6 ~/development/nodejs-dev/liuyao/src/conn.js
badd +5 ~/development/nodejs-dev/mathconf/index.js
badd +39 ~/.bash_aliases
badd +1 /tmp/bash-fc.0fi13q
badd +8 ~/development/nodejs-dev/mathconf/package.json
badd +1 ~/development/vim/test.md
badd +85 /cygdrive/c/Users/van/test.dsed
badd +1 /cygdrive/c/Users/van/test.d
badd +1 /tmp/bash-fc.8RkuRl
badd +10194 ~/development/python-learn/ams-abbrev/annser-abbrev.tex
badd +5 ~/development/python-learn/ams-abbrev/README.md
badd +2 ~/development/python-learn/ams-abbrev/.gitignore
badd +1 ~/development/python-learn/ams-abbrev/abbrev-amsrefs.py
badd +1 /tmp/bash-fc.KJjiC9
badd +1 ~/development/python-learn/abbrev-amsrefs.py
badd +13 ~/development/nodejs-dev/mathrefmanager/src/main.js
badd +495 /cygdrive/i/cygwin64/home/van/development/tex/exam/mathexam.dtx
badd +1 /tmp/bash-fc.eT0WOg
badd +1 /tmp/bash-fc.GZqjc3
badd +1 ~/development/vim/Vim4WP/ftplugin/wp/mserver.py
badd +1 ~/Vim4WP/ftplugin/wp/mserver.py
badd +1 ~/Vim4WP/ftplugin/wp/testmserver.py
badd +34 ~/Vim4WP/ftplugin/wp/xor.py
badd +1 ~/Vim4WP/ftplugin/wp/mserver.py.bak2
badd +1 ~/python-learn/hello.py
badd +396 ~/.vim/vimrc
badd +1 ~/development/nodejs-dev/mathrefmanager/node_modules/fsevents/build/gyp-mac-tool
badd +429 ~/development/nodejs-dev/mathrefmanager/node_modules/istanbul-api/lib/config.js
badd +1 ~/development/python-learn/hello.py
badd +11 ~/.vim/test.dsed
badd +4 ~/development/nodejs-dev/liuyao/public/index.html
badd +1 ~/development/nodejs-dev/liuyao/src/components/fenc=cp936
badd +1 ~/development/nodejs-dev/liuyao/src/components/Jiegua.vue
badd +1 ~/development/nodejs-dev/liuyao/src/components/index.html
badd +9 ~/development/nodejs-dev/liuyao/src/components/LiuyaoGenerator.vue
argglobal
silent! argdel *
edit ~/development/nodejs-dev/liuyao/src/components/Yaogua.vue
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
2
normal! zo
3
normal! zo
4
normal! zo
13
normal! zo
4
normal! zc
128
normal! zo
194
normal! zo
196
normal! zo
197
normal! zo
239
normal! zo
252
normal! zo
258
normal! zo
294
normal! zo
333
normal! zo
358
normal! zo
366
normal! zo
381
normal! zo
387
normal! zo
404
normal! zo
let s:l = 358 - ((8 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
358
normal! 011|
tabedit ~/development/nodejs-dev/liuyao/src/components/Jiegua.vue
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
2
normal! zo
3
normal! zo
5
normal! zo
6
normal! zo
42
normal! zo
44
normal! zo
let s:l = 6 - ((3 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
6
normal! 09|
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
