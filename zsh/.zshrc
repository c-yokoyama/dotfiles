# my alias
alias ls='ls -GF'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -al'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias kc='kubectl'

setopt autocd
autoload -Uz add-zsh-hook
add-zsh-hook precmd autols

autols(){
  [[ ${AUTOLS_DIR:-$PWD} != $PWD ]] && ls
  AUTOLS_DIR="${PWD}"
}

setopt correct

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
export HISTFILE=${HOME}/.zsh_history
# メモリに保存される履歴の件数
export HISTSIZE=500
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=2000
# 重複を記録しない
setopt hist_ignore_dups
# 開始と終了を記録
setopt EXTENDED_HISTORY

# 補完候補を詰めて表示する
setopt list_packed 

# Homebrew
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
# brew doctorのwarning回避:  PATHから一時的に以下を除いて実行
alias brew="env PATH=${PATH/\/Users\/${USER}\/\.pyenv\/shims:/} brew"

# z
source ~/.zsh.d/z.sh
# z and peco command-history
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
bindkey '^f' peco-z-search

# peco-history
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

# anyenv
if [ -d $HOME/.anyenv ] ; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"
    # tmux対応
    for D in `\ls $HOME/.anyenv/envs`
    do
        export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
    done
fi

# Go
export GO_VERSION=1.9.3
export GOROOT=$HOME/.anyenv/envs/goenv/versions/$GO_VERSION
export GOPATH=$HOME/gocode
export PATH=$HOME/.anyenv/envs/goenv/shims/bin:$PATH
export PATH=$GOROOT/bin:$PATH
echo Now using golang v$GO_VERSION


## zplug
# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi
source ~/.zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "peco/peco", as:command, from:gh-r

zplug "plugins/git", from:oh-my-zsh, if:"(( $+commands[git] ))"
zplug "plugins/brew", from:oh-my-zsh
zplug "lib/clipboard", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "themes/candy", from:oh-my-zsh, as:theme

# check コマンドで未インストール項目があるかどうか。 あればインストール
if [ ! ~/.zplug/last_zshrc_check_time -nt ~/.zshrc ]; then
    touch ~/.zplug/last_zshrc_check_time
    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
           echo; zplug install
        fi
    fi
fi
zplug load

# zsh-completionsを利用
if [ -e /usr/local/share/zsh-completions ]; then
	    fpath=(/usr/local/share/zsh-completions $fpath)
fi
if [ -e /usr/local/share/zsh/functions ]; then
	    fpath=(/usr/local/share/zsh/functions $fpath)
fi
if [ -e /usr/local/share/zsh/site-functions ]; then
	    fpath=(/usr/local/share/zsh/site-functions $fpath)
fi
# k8s
source <(kubectl completion zsh)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/c-yokoyama/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/c-yokoyama/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/c-yokoyama/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/c-yokoyama/google-cloud-sdk/completion.zsh.inc'; fi

### azure completion - begin. generated by omelette.js ###
if type compdef &>/dev/null; then
  _azure_complette() {
    compadd -- `azure --compzsh --compgen "${CURRENT}" "${words[CURRENT-1]}" "${BUFFER}"`
  }
  compdef _azure_complette azure
elif type complete &>/dev/null; then
  _azure_complette() {
    COMPREPLY=( $(compgen -W '$(azure --compbash --compgen "${COMP_CWORD}" "${COMP_WORDS[COMP_CWORD-1]}" "${COMP_LINE}")' -- "${COMP_WORDS[COMP_CWORD]}") )
  }
  complete -F _azure_complette azure
fi

### azure completion - end ###

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/c-yokoyama/.anyenv/envs/nodenv/versions/6.10.3/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/c-yokoyama/.anyenv/envs/nodenv/versions/6.10.3/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/c-yokoyama/.anyenv/envs/nodenv/versions/6.10.3/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/c-yokoyama/.anyenv/envs/nodenv/versions/6.10.3/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh

### Added by IBM Cloud CLI
source /usr/local/Bluemix/bx/zsh_autocomplete

if (which zprof > /dev/null 2>&1) ;then
  zprof
fi

# zcompile
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
  zcompile ~/.zshrc
fi

if type zprof > /dev/null 2>&1; then
  zprof | less
fi
