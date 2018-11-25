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
