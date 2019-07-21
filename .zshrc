#
# 基本
#

# 文字コードはUTF-8
export LANG=ja_JP.UTF-8

# コマンドのスペルミスを指摘
setopt correct

# ディレクトリ名でcd
setopt auto_cd

# ビープ音を鳴らさない
#setopt no_beep

# Ctrl+S を無効化
if [[ -t 0 ]]; then
    stty stop undef
    stty start undef
fi

#
# 補完
#
autoload -Uz compinit
compinit

# 補完候補表示時にビープ音を鳴らさない
setopt nolistbeep

# 候補が多い場合は詰めて表示
setopt list_packed

# コマンドラインの引数でも補完を有効にする（--prefix=/userなど）
setopt magic_equal_subst

# 大文字小文字を区別しない（大文字を入力した場合は区別する）
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# cd -<tab>で以前移動したディレクトリを表示
setopt auto_pushd

# auto_pushdで重複するディレクトリは記録しない
setopt pushd_ignore_dups

#setopt auto_list
#setopt auto_menu
#setopt auto_param_keys
#setopt complete_aliases
#setopt list_types
#setopt always_last_prompt
#setopt complete_in_word


#
# 履歴
#
HISTFILE=~/.zsh_history

# メモリ上に保存される件数（検索できる件数）
HISTSIZE=100000

# ファイルに保存される件数
SAVEHIST=100000

# rootは履歴を残さないようにする
if [ $UID = 0 ]; then
  unset HISTFILE
  SAVEHIST=0
fi

# 履歴検索
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# 履歴を複数の端末で共有する
setopt share_history

# 直前と同じコマンドの場合は履歴に追加しない
setopt hist_ignore_dups

# 重複するコマンドは古い法を削除する
setopt hist_ignore_all_dups

# 複数のzshを同時に使用した際に履歴ファイルを上書きせず追加する
#setopt append_history

# 履歴ファイルにzsh の開始・終了時刻を記録する
#setopt extended_history

# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
#setopt hist_verify

# 先頭がスペースで始まる場合は履歴に追加しない
#setopt hist_ignore_space

# ファイルに書き出すとき古いコマンドと同じなら無視
#setopt hist_save_no_dups


#
# 色
#
autoload colors
colors

# git
autoload -Uz vcs_info
setopt prompt_subst
precmd () { vcs_info }
zstyle ':vcs_info:git:*' check-for-changes true #formats 設定項目で %c,%u が使用可
zstyle ':vcs_info:git:*' stagedstr "%F{green}!" #commit されていないファイルがある
zstyle ':vcs_info:git:*' unstagedstr "%F{magenta}+" #add されていないファイルがある
zstyle ':vcs_info:*' formats "%F{cyan}%c%u(%b)%f" #通常
zstyle ':vcs_info:*' actionformats '[%b|%a]' #rebase 途中,merge コンフリクト等 formats 外の表示

# プロンプト
PROMPT="%{${fg[green]}%}%n@%m %{${fg[yellow]}%}%~ %{${reset_color}%}"
PROMPT=$PROMPT'${vcs_info_msg_0_}%{${fg[red]}%}$%{${reset_color}%} '
PROMPT2="%{${fg[yellow]}%} %_ > %{${reset_color}%}"
SPROMPT="%{${fg[red]}%}correct: %R -> %r ? [n,y,a,e] %{${reset_color}%}"


# ls
export LSCOLORS=gxfxcxdxbxegedabagacag
export LS_COLORS='di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;46'

# 補完候補もLS_COLORSに合わせて色が付くようにする
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# lsがカラー表示になるようエイリアスを設定
case "${OSTYPE}" in
darwin*)
  # Mac
  alias ls="ls -GF"
  ;;
linux*)
  # Linux
  alias ls='ls -F --color'
  ;;
esac


#
# その他
#

#centosにsshするとviで下記のエラーが出ることがあるので対策
# E437: terminal capability "cm" required
alias ssh='TERM=xterm ssh'

# tmux自動起動(空:ON, それ以外:OFF)
TMUX=OFF
alias tmux='tmux -2 a || tmux -2'
#tmuxで既存セッションがあればnew-sessionせずにアタッチする
if [[ -z $TMUX && -n $PS1 ]]; then
  function tmux() {
    if [[ $# == 0 ]] && tmux has-session 2>/dev/null; then
      # tmuxのオプションに-2を付けないとubuntuのtmux上でvimがカラーにならない
      command tmux -2 attach-session
    else
      command tmux -2 "$@"
    fi
  }
fi
if [[ -z $TMUX ]]; then
  tmux
fi

# ローカルのzshrcを読み込む
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# zsh コマンド入力途中は zsh操作 を tmux操作より優先
function _left-pane() {
      tmux select-pane -L
}
zle -N left-pane _left-pane

function _down-pane() {
      tmux select-pane -D
}
zle -N down-pane _down-pane

function _up-pane() {
      tmux select-pane -U
}
zle -N up-pane _up-pane

function _right-pane() {
      tmux select-pane -R
}
zle -N right-pane _right-pane

function _backspace-or-left-pane() {
      if [[ $#BUFFER -gt 0 ]]; then
              zle backward-delete-char
                elif [[ ! -z ${TMUX} ]]; then
                    zle left-pane
                      fi
}
zle -N backspace-or-left-pane _backspace-or-left-pane

function _kill-line-or-up-pane() {
      if [[ $#BUFFER -gt 0 ]]; then
              zle kill-line
                elif [[ ! -z ${TMUX} ]]; then
                    zle up-pane
                      fi
}
zle -N kill-line-or-up-pane _kill-line-or-up-pane

function _accept-line-or-down-pane() {
      if [[ $#BUFFER -gt 0 ]]; then
              zle accept-line
                elif [[ ! -z ${TMUX} ]]; then
                    zle down-pane
                      fi
}
zle -N accept-line-or-down-pane _accept-line-or-down-pane

bindkey '^k' kill-line-or-up-pane
bindkey '^l' right-pane
bindkey '^h' backspace-or-left-pane
bindkey '^j' accept-line-or-down-pane
