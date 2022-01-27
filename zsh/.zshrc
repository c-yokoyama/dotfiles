# Add to  PATH
export PATH=$PATH:/usr/local/bin
# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# My aliases
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias h='history'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias kctx='kubectx'
alias kns='kubens'
alias kb='kustomize build'
alias awsp="source _awsp"
export GREP_OPTIONS='--color=auto'

# 補完
autoload -U compinit
compinit

### k8s
source <(kubectl completion zsh)
alias k='kubecolor'
compdef __start_kubectl kubecolor k
# kubectl_aliasesを入れていることでサブコマンドの補完が効かない
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases
# krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# kube-ps1
source "/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"
PROMPT='$(kube_ps1)'$PROMPT

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# anyenv
eval "$(anyenv init -)"

# Golang
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
export PATH=$GOROOT/bin:$PATH

# Node.js
export PATH=$(npm bin -g):$PATH

### Other options
setopt autocd
setopt correct
setopt list_packed 
# 直前の重複を記録しない
setopt hist_ignore_dups
# 重複したヒストリは追加しない
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt auto_list
setopt complete_in_word
# 開始と終了を記録
setopt EXTENDED_HISTORY
# メモリに保存される履歴の件数
export HISTSIZE=5000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=20000
export HISTFILE=${HOME}/.zsh_history
# history設定
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# auto ls
autoload -Uz add-zsh-hook
add-zsh-hook precmd autols
autols(){
  [[ ${AUTOLS_DIR:-$PWD} != $PWD ]] && ls -l
  AUTOLS_DIR="${PWD}"
}

### z and peco
source ~/z/z.sh
function peco-z-search
{
  which peco z > /dev/null
  if [ $? -ne 0 ]; then
    echo "Please install peco and z"
    return 1
  fi
  local res=$(z | sort -rn | cut -c 12- | peco)
  if [ -n "$res" ]; then
    BUFFER+="cd $res"
    zle accept-line
  else
    return 1
  fi
}
zle -N peco-z-search
# peco dir history search
bindkey '^f' peco-z-search

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit light 'djui/alias-tips'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# iTerm2 Shell Integration
source ~/.iterm2_shell_integration.zsh
