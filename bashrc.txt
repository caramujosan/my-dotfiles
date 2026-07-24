# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=500
HISTFILESIZE=1000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi


# --- Configuração do Prompt Personalizado ---

# 1. Definição de Cores em variáveis
C_RED="\[\e[0;31m\]"
C_BLUE="\[\e[1;94m\]"      # Azul Claro Brilhante
C_GREEN="\[\e[1;92m\]"     # Verde Claro Brilhante
C_YELLOW="\[\e[1;33m\]"
C_CYAN="\[\e[1;96m\]"
C_WHITE="\[\e[1;37m\]"
C_RESET="\[\e[0m\]"

# 2. Símbolos Unicode
S_TL="┌"   # Top Left
S_HL="─"   # Horizontal Line
S_BL="└"   # Bottom Left
S_ARR="╼"  # Arrow
S_ERR="✗"  # Error

# 3. Função que constrói o prompt
function build_prompt() {
    # Salva o código de saída do último comando (0 = sucesso, >0 = erro)
    local exit_code=$? 
    
    
    # Imprime o título direto no emulador do terminal, sem misturar com o PS1
    case "$TERM" in
        xterm*|rxvt*)
            # echo -ne envia a sequência ANSI invisível que atualiza a aba
            echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/#$HOME/\~}\007"
            ;;
    esac
    # -----------------------------


    local c_lines
    local user_host
    local TERM_SYMBOL
    local TERM_PATH
    
    
    # Lógica condicional: Diferenciar Root do Usuário Comum
    if [[ ${EUID} == 0 ]]; then
        c_lines="${C_RED}"
        # Root: Informações com a cor padrão do terminal
        user_host="${C_RESET}\u@\h" 
        # Cor do símbolo do root do terminal (#)
        TERM_SYMBOL="${C_RESET}"
        # Path inteiro quando root
        TERM_PATH="\w"
    else
        c_lines="${C_BLUE}"
        # Usuário: Usuário (padrão), @ (amarelo), Host (ciano)
        user_host="${C_CYAN}\u${C_YELLOW}@${C_CYAN}\h"
        # Cor do símbolo do usuário do terminal ($)
        TERM_SYMBOL="${C_YELLOW}"
        # Path relativo quando usuário
        TERM_PATH="\W"
    fi

    # Lógica condicional: Se o último comando deu erro, adiciona o [✗] vermelho
    local err_block=""
    if [[ $exit_code != 0 ]]; then
        err_block="[${C_RED}${S_ERR}${c_lines}]${S_HL}"
    fi

    # 4. Montagem final da variável PS1
    PS1=""
    PS1+="${c_lines}${S_TL}${S_HL}${err_block}[${user_host}${c_lines}]${S_HL}"
    PS1+="[${C_GREEN}${TERM_PATH}${c_lines}]\n"
    PS1+="${c_lines}${S_BL}${S_HL}${S_HL}${S_ARR} ${TERM_SYMBOL}\\$ ${C_RESET}"
}

# 5. Informa ao Bash para executar nossa função
PROMPT_COMMAND=build_prompt

# --- Fim da Configuração do Prompt Personalizado ---


# Lógica do título da aba/janela (só funciona em terminais gráficos)
#case "$TERM" in
#xterm*|rxvt*)
#    window_title="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]"
#    ;;
#esac


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


export JAVA_HOME=/usr/bin/java
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/.local/bin/

# Meus alias.
alias rm='rm -iv'
alias cp='cp -iv'
alias mv='mv -iv'

####
