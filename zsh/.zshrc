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
alias k='kubectl'
alias kgp='kubectl get pod'
alias kgd='kubectl get deploy'
alias kdp='kubectl describe pod'
alias kdd='kubectl describe deploy'
alias kctx='kubectx'
alias kns='kubens'
alias awsp="source _awsp"

# iTerm2 Shell Integration
source ~/.iterm2_shell_integration.zsh

bindkey -e
: "peco snippet" && {
  function peco-select-snippet() {
    BUFFER=$(cat ~/.snippets | peco)
    CURSOR=$#BUFFER
    zle -R -c
  }
  zle -N peco-select-snippet
  bindkey '^T' peco-select-snippet
}

export GREP_OPTIONS='--color=auto' 

# Homebrew
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
# brew doctorのwarning回避, PATHから一時的に以下を除いて実行
alias brew="env PATH=${PATH/\/Users\/${USER}\/\.pyenv\/shims:/} brew"

# anyenv
if [ -d $HOME/.anyenv ] ; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init - --no-rehash zsh)"
    # tmux対応
    for D in `\ls $HOME/.anyenv/envs`
    do
        export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
    done
fi

# Node.js
export PATH=$(npm bin -g):$PATH

# Golang
export GO_VERSION=1.13.5
export GOROOT=$HOME/.anyenv/envs/goenv/versions/$GO_VERSION
export GOPATH=$HOME/gocode
export PATH=$HOME/.anyenv/envs/goenv/shims/bin:$PATH
export PATH=$GOROOT/bin:$PATH
export PATH=$GOPATH/bin:$PATH

### Options ###
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

# Install z
. `brew --prefix`/etc/profile.d/z.sh
# z and peco
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
# dir history search
bindkey '^f' peco-z-search

autoload -Uz colors 
colors

### zplugin ###
source $HOME/.zplugin/bin/zplugin.zsh
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

zplugin light zsh-users/zsh-autosuggestions
zplugin light zsh-users/zsh-completions
# 利用可能なエイリアスを使わずにコマンドを実行した際に通知するプラグイン
zplugin light 'djui/alias-tips'
# zsh の補完を使いやすく設定する oh-my-zsh のスニペットをロード
zplugin snippet 'OMZ::lib/completion.zsh'
zplugin snippet 'OMZ::lib/compfix.zsh'
# Load OMZ Git library
zplugin snippet OMZ::lib/git.zsh
# Load Git plugin from OMZ
zplugin snippet OMZ::plugins/git/git.plugin.zsh
zplugin cdclear -q # <- forget completions provided up to this moment
setopt promptsubst
zplugin light zdharma/fast-syntax-highlighting
zplugin light zdharma/history-search-multi-word
zplugin light nnao45/zsh-kubectl-completion

autoload -Uz compinit
compinit

# zsh-completions
if [ -e /usr/local/share/zsh-completions ]; then
	fpath=(/usr/local/share/zsh-completions $fpath)
fi
if [ -e /usr/local/share/zsh/functions ]; then
	fpath=(/usr/local/share/zsh/functions $fpath)
fi
if [ -e /usr/local/share/zsh/site-functions ]; then
	    fpath=(/usr/local/share/zsh/site-functions $fpath)
fi

### 補完方法毎にグループ化する。
zstyle ':completion:*' format '%B%F{blue}%d%f%b'
zstyle ':completion:*' group-name ''
### 補完侯補をメニューから選択する。
### select=2: 補完候補を一覧から選択する。補完候補が2つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=2
### 補完候補に色を付ける。
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
### 補完候補がなければより曖昧に候補を探す。
### m:{a-z}={A-Z}: 小文字を大文字に変えたものでも補完する。
### r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完する。
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' recent-dirs-insert both
### 補完候補
### _oldlist 前回の補完結果を再利用する。
### _complete: 補完する。
### _match: globを展開しないで候補の一覧から補完する。
### _history: ヒストリのコマンドも補完候補とする。
### _ignored: 補完候補にださないと指定したものも補完候補とする。
### _approximate: 似ている補完候補も補完候補とする。
### _prefix: カーソル以降を無視してカーソル位置までで補完する。
zstyle ':completion:*' completer _oldlist _complete _match _history _ignored _approximate _prefix
zstyle ':completion:*' completer _complete _ignored

## 補完候補をキャッシュする。
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache

# zcompile
if [ ~/.zshrc -nt ~/.zshrc.zwc -o ! -e ~/.zshrc.zwc ]; then
  zcompile ~/.zshrc
  zcompile ~/.zplugin/bin/zplugin.zsh
fi

# zprof
if type zprof > /dev/null 2>&1; then
  zprof | less
fi

# direnv
export EDITOR=vim
eval "$(direnv hook zsh)"

# awsp
#function aws_prof {
#  local profile="${AWS_PROFILE:=default}"

#  echo "%{$fg_bold[white]%}(%{$fg_bold[red]%}aws|%{$fg[yellow]%}${profile}%{$fg_bold[white]%})%{$reset_color%} "
#}

#PS1='$(aws_prof)'' '$PS1

### k8s ### 
# krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
PS1='$(kube_ps1 )'' '$PS1

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship

######################################################################

# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /Users/yokoyama/.anyenv/envs/nodenv/versions/8.10.0/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . /Users/yokoyama/.anyenv/envs/nodenv/versions/8.10.0/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/c-yokoyama/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/c-yokoyama/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/c-yokoyama/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/c-yokoyama/google-cloud-sdk/completion.zsh.inc'; fi
