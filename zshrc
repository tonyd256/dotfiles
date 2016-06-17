# modify the prompt to contain git branch name if applicable
get_pwd() {
    echo "${PWD/$HOME/~}"
}

parse_git_dirty() {
  local STATUS=''
  STATUS=$(command git status --porcelain 2> /dev/null | tail -n1)
  if [[ -n $STATUS ]]; then
    echo "%{$fg[red]%}✗"
  else
    echo "%{$fg[green]%}✔"
  fi
}

current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

put_spacing() {
    local git=$(current_branch) || ""
    git=${#git}

    local termwidth
    (( termwidth = ${COLUMNS} - 5 - ${#HOST} - ${#$(get_pwd)} - ${git} ))

    local spacing=""
    for i in {1..$termwidth}; do
        spacing="${spacing} "
    done
    echo $spacing
}

git_prompt_info() {
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$(parse_git_dirty) [git:$(current_branch)]"
}

setopt promptsubst
export PS1='
%{$fg[cyan]%}%m: %{$fg[yellow]%}$(get_pwd)$(put_spacing)$(git_prompt_info)
%{$fg[blue]%}→%{$reset_color%} '

# completion
autoload -U compinit
compinit

# load our own completion functions
for completion in ~/.zsh/completions/*; do
  source $completion
done

# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc
export CLICOLOR=1

# history settings
setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory
HISTSIZE=4096
SAVEHIST=4096

# awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

# Enable extended globbing
setopt extendedglob

# Allow [ or ] whereever you want
unsetopt nomatch

# Allow case insensitive tab completion
setopt +o menucomplete
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# vi mode
bindkey -v
bindkey "^F" vi-cmd-mode
bindkey jj vi-cmd-mode

# handy keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^K" kill-line
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
  _dir="$1"
  if [ -d "$_dir" ]; then
    if [ -d "$_dir/pre" ]; then
      for config in "$_dir"/pre/**/*(N-.); do
        . $config
      done
    fi

    for config in "$_dir"/**/*(N-.); do
      case "$config" in
        "$_dir"/pre/*)
          :
          ;;
        "$_dir"/post/*)
          :
          ;;
        *)
          if [ -f $config ]; then
            . $config
          fi
          ;;
      esac
    done

    if [ -d "$_dir/post" ]; then
      for config in "$_dir"/post/**/*(N-.); do
        . $config
      done
    fi
  fi
}
_load_settings "$HOME/.zsh/configs"

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local


PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

export PATH="$HOME/.bin:$PATH"
eval "$(rbenv init - --no-rehash zsh)"

source /usr/local/opt/chswift/share/chswift/chswift.sh
source /usr/local/opt/chswift/share/chswift/auto.sh
