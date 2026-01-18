# M1 or M2 mac brew path
eval "$(/opt/homebrew/bin/brew shellenv)"

#console
setopt PROMPT_SUBST
PS1='%n@ [$(date +%H:%M:%S)] :%~ %# '

#alias
alias ll="ls -latr"
alias cdc="cd $HOME/Documents/code"
alias cdt="cd $HOME/Desktop"
alias cdd="cd $HOME/Documents"
alias icat="wezterm imgcat" # wezterm上で画像を開く

# rye
source "$HOME/.rye/env"
export RYE_NO_AUTO_INSTALL=1

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

. "$HOME/.local/bin/env"
