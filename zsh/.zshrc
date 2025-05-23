
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

##################################### ohmyzsh configure start #####################################
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ABC_DIR="$HOME/abc"
export PYBIND11_DIR="$HOME/anaconda3/pkgs/pybind11-abi-4-hd3eb1b0_1"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=( 
  git
  battery
  zsh-autosuggestions
  zsh-syntax-highlighting
  copypath copyfile copybuffer
  zsh-history-substring-search
  zoxide
)

# plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search vi-mode )

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down 
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

export YSU_MESSAGE_POSITION="after"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=(bg=none,fg=cyan,bold)
source $ZSH/oh-my-zsh.sh
# eval "$(zoxide init zsh)"
##################################### ohmyzsh configure end #####################################
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
############################################ pnpm ############################################
export PNPM_HOME="/Users/yck/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
########################################### pnpm end ##########################################

source $HOME/.zshrc.local

# If you come from bash you might have to change your $PATH.
export PATH=/opt/homebrew/bin:$HOME/bin:/usr/local/bin:$PATH
export PATH="/opt/homebrew/sbin:$PATH"
