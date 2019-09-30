# modify the prompt to contain git branch name if applicable
get_pwd() {
    echo "${PWD/$HOME/~}"
}

parse_git_dirty() {
  local STATUS=''
  STATUS=$(command git status --porcelain 2> /dev/null | tail -n1)
  if [[ -n $STATUS ]]; then
    echo "%F{red}✗"
  else
    echo "%F{green}✔"
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

git_prompt_info() {
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$(parse_git_dirty) [git:$(current_branch)]"
}

setopt promptsubst
export PS1='
%F{cyan}%m: %F{yellow}$(get_pwd) $(git_prompt_info)
%F{blue}→%f '

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
setopt inc_append_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_verify
setopt append_history
setopt extended_history
setopt share_history
HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000

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
zle -N fh
bindkey "^R" fh
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

# Setting ag as the default source for fzf
export FZF_DEFAULT_COMMAND='ag -g ""'

EDITOR=vi
PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin
export PATH="$HOME/.fastlane/bin:$PATH"
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="$HOME/Library/Python/3.6/bin:$PATH"
export PATH="$HOME/.esp/xtensa-esp32-elf/bin:$PATH"

export IDF_PATH="$HOME/.esp/esp-idf"

export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

eval "$(rbenv init - --no-rehash zsh)"

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/tony/.config/yarn/global/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/tony/.config/yarn/global/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/tony/.config/yarn/global/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/tony/.config/yarn/global/node_modules/tabtab/.completions/sls.zsh

eval "$(direnv hook bash)"
