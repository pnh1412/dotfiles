# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" > /dev/null
fi

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)               # Include hidden files.

alias rm='rm -I'
alias mv='mv -i'
alias cp='cp -i'
alias ls='exa --icons --color=auto'
alias ll='ls -alhF'
alias lt='ls -hFT'
alias grep='grep --color=auto'
alias vim='nvim'
alias sudo='sudo '
alias checkupdates='checkupdates && paru -Qua'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias lzconf='lazygit --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias j="z"
alias ji="zi"
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias icat="kitty +kitten icat"
alias du="du -h"


confup() {
  config commit -m "update" && config push
}

aliasexp() {
  if [[ $ZSH_VERSION ]]; then
    # shellcheck disable=2154  # aliases referenced but not assigned
    [ ${aliases[$1]+x} ] && printf '%s\n' "${aliases[$1]}" && return
  else  # bash
    [ "${BASH_ALIASES[$1]+x}" ] && printf '%s\n' "${BASH_ALIASES[$1]}" && return
  fi
  false  # Error: alias not defined
}

gitrelease() {
  MASTER=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
	git push && git checkout $MASTER && git merge develop && git push && git checkout develop
}

lf() {
  tmp="$(mktemp)"
  command lf -last-dir-path="$tmp" "$@"
  if [ -f "$tmp" ]; then
      dir="$(cat "$tmp")"
      rm -f "$tmp"
      if [ -d "$dir" ]; then
          if [ "$dir" != "$(pwd)" ]; then
              cd "$dir"
          fi
      fi
  fi
}

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.tar.xz)    tar xJf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Settings
bindkey -v
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

ZVM_KEYTIMEOUT=0.1
ZVM_VI_HIGHLIGHT_BACKGROUND=white
ZVM_VI_HIGHLIGHT_FOREGROUND=black
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

zstyle ':fzf-tab:*' fzf-flags --height 40%
zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ${(Q)realpath}'
export LESSOPEN='|~/.lessfilter %s'

bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word

#local WORDCHARS='*?_[]~=&;!#$%^(){}<>'
autoload -U select-word-style
select-word-style bash

HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
KEYTIMEOUT=5

# Environment variables
source ~/.profile
export SHELL=zsh

if [ "$TERM" = "linux" ]; then
  [[ ! -f ~/.p10k-tty.zsh ]] || source ~/.p10k-tty.zsh
else
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

source /usr/share/zsh/plugins/zsh-autopair/autopair.zsh
source ~/.config/zsh/catppuccin-tty.sh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
zvm_after_init_commands+=('source /usr/share/fzf/completion.zsh && source /usr/share/fzf/key-bindings.zsh && autopair-init')
eval "$(zoxide init zsh)"
source /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.zsh 2>/dev/null
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# local path
export PATH=$HOME/.local/bin:$PATH

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"

# PYENV_ROOT
export PATH="$PYENV_ROOT/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Android Studio
export ANDROID_SDK_ROOT='/opt/android-sdk'
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools/
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin/
export PATH=$PATH:$ANDROID_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/

# Java Home
#export JAVA_HOME=$(/usr/libexec/java_home)
export JAVA_HOME='/usr/lib/jvm/java-17-openjdk'
#export JAVA_HOME='/usr/lib/jvm/java-8-openjdk/'
#export JAVA_HOME='/usr/lib/jvm/java-11-openjdk'
export PATH=$JAVA_HOME/bin:$PATH
#alias pixel_9.0 ='emulator @pixel_9.0 -no-boot-anim -netdelay none -no-snapshot -wipe-data -skin 1080x1920 &'

# npm-global
export PATH=~/.npm-global/bin:$PATH

# go path
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export GOROOT=/usr/lib/go

# node path
PATH=/usr/bin/node:$PATH

# lua path
#export LUA_DIR=/usr/local/lib/lua/5.4.4
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

# postgresql path
export PATH=/usr/pgsql-14.6.2/bin:$PATH
