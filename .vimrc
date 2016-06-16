".vimrc
set nu
set cindent

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

syntax on
"关闭代码折叠
set nofoldenable
"基于语法折叠代码
set foldmethod=syntax
"禁止代码折行
set nowrap
inoremap jj <esc>
"保存但不退出
imap ss <esc>:w<CR>
"搜索高亮显示
set hls
"开启实时搜索
set incsearch
"使注释颜色变浅，vim专用
hi Comment ctermfg=6
set mouse=a
