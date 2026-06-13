# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f /run/.toolboxenv ]]; then
  export IN_TOOLBOX=1
fi

# Jure zsh setup

source "$HOME/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme"

autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list \
        'm:{a-z}={A-Za-z}' \
        'r:|[._-]=* r:|=*' \
        'l:|=* r:|=*'

zstyle ':completion:*' max-errors 1
zstyle ':completion:*' completer _complete _approximate

# Use LS_COLORS for completion lists and for ls command
alias ls='ls --color=auto'
eval "$(dircolors)"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Enable prompt command substitution
setopt PROMPT_SUBST

# Colors
autoload -Uz colors
colors

# Git info (fast, built-in)
# autoload -Uz vcs_info
# zstyle ':vcs_info:git:*' formats '(%b%u%c)'
# zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'
# zstyle ':vcs_info:*' enable git
# zstyle ':vcs_info:git:*' check-for-changes true
# zstyle ':vcs_info:git:*' unstagedstr '*'
# zstyle ':vcs_info:git:*' stagedstr '+'
# 
# precmd() {
#   vcs_info
# }

# Exit status (only if non-zero)
# exit_status='%(?..%F{red}✘ %?%f )'

# Prompt
# PROMPT='%B${exit_status}%F{green}%~%f ${vcs_info_msg_0_}
# %m%#%b '

# History file
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# History behavior (bash-like but better)
setopt HIST_IGNORE_DUPS        # no immediate duplicates
setopt HIST_IGNORE_ALL_DUPS    # remove older duplicates
setopt HIST_REDUCE_BLANKS      # trim extra spaces
unsetopt INC_APPEND_HISTORY    # dont write immediately
unsetopt SHARE_HISTORY         # dont share across terminals
setopt APPEND_HISTORY          # append current history to history file after closing shell
setopt EXTENDED_HISTORY        # timestamps
setopt HIST_VERIFY             # edit recalled command before running

if [[ "$IN_TOOLBOX" == "1" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# VSCode-like word movement for zsh
autoload -Uz select-word-style
select-word-style bash

# Treat these as word separators
WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'

smart-backward-word() {
  zle backward-word
}

smart-forward-word() {
  zle forward-word
}

zle -N smart-backward-word
zle -N smart-forward-word

# Ctrl + Left / Right
bindkey '^[[1;5D' smart-backward-word
bindkey '^[[1;5C' smart-forward-word
bindkey '^[[5D' smart-backward-word
bindkey '^[[5C' smart-forward-word

# Home / End
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line

# delete char
bindkey "${terminfo[kdch1]}" delete-char

# fzf history search on Ctrl+R
if command -v fzf >/dev/null 2>&1; then
  fzf-history-widget() {
    local selected
    selected=$(fc -rl 1 | fzf --height 40% --reverse --query "$LBUFFER" | sed 's/^[[:space:]]*[0-9]\+[[:space:]]*//')

    if [[ -n "$selected" ]]; then
      LBUFFER="$selected"
    fi

    zle redisplay
  }

  zle -N fzf-history-widget
  bindkey '^R' fzf-history-widget
fi

# Auto suggestions (based on history)
source "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
# source "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Add .local/bin to PATH
export PATH=$PATH:/home/${USER}/.local/bin

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
