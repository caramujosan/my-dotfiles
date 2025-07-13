" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

runtime! debian.vim

" Vim will load $VIMRUNTIME/defaults.vim if the user does not have a vimrc.
" This happens after /etc/vim/vimrc(.local) are loaded, so it will override
" any settings in these files.
" If you don't want that to happen, uncomment the below line to prevent
" defaults.vim from being loaded.
" let g:skip_defaults_vim = 1

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif


" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark


" Uncomment the following to have Vim jump to the last position when
" reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
filetype plugin indent on


" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes)

" meu mapeamento com alias 'cs' para 'clear search', limpar highlight search no modo normal
nmap cs :let @/=''<cr>

set nomodeline		" Desabilita o uso de Modelines (evita ataques de execução de comandos)
set modelines=0		" Mesmo que modelines estejam habilitados ele executa 0 linhas (parse 0)
set number		" habilita a numeração das linhas
set hls			" Grifa o resultado da busca
set wildmode=longest,list " Para completar com TAB igualzinho o bash faz (Use CTRL+P para completar)
set hlg=pt		" Idioma preferido para buscar ajuda
set ul=500		" máximo de mudanças que podem ser desfeitas
set ai			" Habilita a autoindentação


" habilita a régua (mostrar linha e coluna no canto inferior direito)
set ruler
" Ruler e cursor sempre em branco
hi StatusLine ctermfg=white
" Habilita barra visual na régua que mostra linha e coluna no canto inferior direito
set laststatus=2


" F2 Para 'ocultar' e F3 voltar os comentarios do arquivo atual
noremap <F2> :hi Comment ctermfg=black guifg=black<cr>
noremap <F3> :hi Comment term=bold ctermfg=cyan guifg=cyan<cr>


" Alterna entre janelas sem sair do modo insercao (depois do :split)
map <F4> <esc><c-w><c-w>
" Aperte F5 e a tela fica embaralhada e F5 para voltar ao normal"
map <F5> ggVGg?
" Procura a primeira linha vazia e comeca a editar
map <F6> gg/^$<cr>i#
" Remove espaços redundantes no fim das linhas com F7
map <F7> <esc>mz:%s/\s\+$//g<cr>`z
" Retira os ^M que ficam no final de arquivos salvos pelo windows. Aperte F8 e suma com eles.
map <F8> :%s/\r//g
" Cria o cabecalho padrao para shell script
map <F9>  ggO#!/bin/bash
          \<c-o>:r!echo %<cr># <c-o>o
          \# Versao: <c-o>o
          \# Script para:<c-o>i
	  \<c-o>:r!date '+\%Y-\%m-\%d \%H:\%M-0300'<cr># <c-o>o
	  \# Codificacao utf-8<c-o>o
          \# Autor: caramujosan<cr>


" Abreviações para quando a tecla CAPS LOCK estiver ativada."
cab W w | cab Q q | cab Wq wq | cab wQ wq | cab WQ wq
" Função que fecha automaticamente { ( [, ao escrevê-los o vim fecha automaticamente.
imap { {}<left>
imap ( ()<left>
imap [ []<left>


" Salva os arquivos .sh com permissao de escrita
au BufWritePost *.sh  !chmod +x %


" Busca colorida em amarelo 
hi    Search ctermbg=yellow ctermfg=black
hi IncSearch ctermbg=yellow ctermfg=black


" Faz os resultados da busca aparecerem no meio da tela
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz


"Arquivos .sh sao sempre bash, e não sh
au FileType sh let b:is_bash=1


" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
