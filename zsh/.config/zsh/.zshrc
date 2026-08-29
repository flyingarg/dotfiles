fastfetch
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Use powerline
USE_POWERLINE="true"
# Has weird character width
# Example:
#    is not a diamond
HAS_WIDECHARS="false"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

tdl() {
  local editor="${EDITOR:-nvim}"
  local agent="${1:-}"
  local second_agent="${2:-}"

  if [ -z "$TMUX" ]; then
    echo "tdl must be run inside tmux"
    return 1
  fi

  if [ -z "$agent" ]; then
    echo "Usage: tdl <ai-command> [second-ai-command]"
    return 1
  fi

  # Remember the pane we're starting from.
  local main_pane="$TMUX_PANE"

  # Bottom terminal: split the original pane horizontally.
  local terminal_pane
  terminal_pane=$(tmux split-window -v -p 15 -P -F '#{pane_id}' -t "$main_pane")

  #Right-side AI pane: split the original/editor pane vertically.
  local agent_pane
  agent_pane=$(tmux split-window -h -p 30 -P -F '#{pane_id}' -t "$main_pane")

  #Start editor in the left pane.
  tmux send-keys -t "$main_pane" "$editor" C-m

  #Start AI agent in the right pane.
  tmux send-keys -t "$agent_pane" "$agent" C-m

  #Optional second AI agent.
  if [ -n "$second_agent" ]; then
    tmux split-window -v -p 50 -t "$agent_pane"
    tmux send-keys -t "$agent_pane" "$second_agent" C-m
  fi

  #Return focus to editor.
  tmux select-pane -t "$main_pane"
}
