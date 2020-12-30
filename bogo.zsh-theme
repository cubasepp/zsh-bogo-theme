
# Colors: red|blue|green|yellow|orange|magenta|cyan
local red=$fg[red]
local blue=$fg[blue]
local green=$fg[green]
local yellow=$fg[yellow]
local orange=$fg[orange]
local magenta=$fg[magenta]
local cyan=$fg[cyan]

local red_bold=$fg_bold[red]
local blue_bold=$fg_bold[blue]
local green_bold=$fg_bold[green]
local yellow_bold=$fg_bold[yellow]
local orange_bold="%F{166}"
local magenta_bold=$fg_bold[magenta]
local cyan_bold=$fg_bold[cyan]

local highlight_bg=$bg[red]

# Git info.
ZSH_THEME_GIT_PROMPT_PREFIX="%{$cyan_bold%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$green_bold%} ✔ "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$red_bold%} ✘ "

# Git status.
ZSH_THEME_GIT_PROMPT_ADDED="%{$green_bold%}+"
ZSH_THEME_GIT_PROMPT_DELETED="%{$red_bold%}-"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$magenta_bold%}*"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$blue_bold%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$cyan_bold%}="
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$yellow_bold%}?"


# Directory info.
function get_current_dir {
    echo "${PWD/#$HOME/~}"
}

# User info.

function get_user {
  echo %n
}

# Host info.
function get_host {
  echo $HOST
}

# Current time
function current_time {
  echo "%*"
}

# Git prompt.
function get_git_prompt {
    if [[ -n $(git rev-parse --is-inside-work-tree 2>/dev/null) ]]; then
        local git_status="$(git_prompt_status)"
        if [[ -n $git_status ]]; then
            git_status="[$git_status%{$reset_color%}]"
        fi
        local git_prompt=" <$(git_prompt_info)$git_status>"
        echo $git_prompt
    fi
}

# Build space.
function get_space {
    local str=$1$2
    local zero='%([BSUbfksu]|([FB]|){*})'
    local len=${#${(S%%)str//$~zero/}}
    local size=$(( $COLUMNS - $len - 1 ))
    local space=""
    while [[ $size -gt 0 ]]; do
        space="$space "
        let size=$size-1
    done
    echo $space
}

function get_versions {
    if hash rvm 2>/dev/null; then
        rvm current 2>/dev/null
    fi
}



function build_prompt_head {
  local left_prompt="\
%{$orange_bold%}# \
%{$cyan_bold%}$(get_user)\
%{$blue_bold%}@\
%{$cyan_bold%}$(get_host)\
%{$orange_bold%}: \
$(get_current_dir)\
%{$reset_color%}\
$(get_git_prompt) \
%b\
%{$reset_color%}"

  local right_prompt="%{$blue%}[$(get_versions)]%{$reset_color%}"
  print -rP "$left_prompt$(get_space $left_prompt $right_prompt)$right_prompt"
}

autoload -U add-zsh-hook
add-zsh-hook precmd build_prompt_head

PROMPT="~ %{$reset_color%}"
RPROMPT='$(current_time)'
