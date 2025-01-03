# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Your PATH Exports
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git fzf-zsh-plugin zsh-autosuggestions zsh-syntax-highlighting dirhistory)
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
#setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
#setopt SHARE_HISTORY             # Share history between all sessions.
#setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
#setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
#setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
#setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
#setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
#setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# dt scripts
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export DT_SCRIPTS_FOLDER="/home/alain/Openbravo/dt/retail_scripts"
export PATH="$PATH:/home/alain/Openbravo/dt/retail_scripts"
export PATH="$PATH:/home/alain/Openbravo/dt/dev_tools"
autoload bashcompinit
bashcompinit
source /home/alain/Openbravo/dt/retail_scripts/dt-completion
alias c2start="(cd modules/org.openbravo.core2/web-jspack/org.openbravo.core2 && npm start)"
alias c2story="(cd modules/org.openbravo.core2/web-jspack/org.openbravo.core2 && npm run storybook)"
alias c2build="(cd modules/org.openbravo.core2/ && ant build)"
alias c2gen="(cd modules/org.openbravo.core2/ && ant generate.app)"
alias c2bs="c2build && c2start"
alias c2cy="(cd modules/org.openbravo.core2/web-jspack/org.openbravo.core2/src-test && ../node_modules/.bin/cypress open)"
alias c2messages="(cd modules/org.openbravo.core2/ && ant generate.module.info)"
