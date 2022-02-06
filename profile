export QT_QPA_PLATFORMTHEME="qt5ct"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# blog.packagecloud.io/eng/2017/02/21/set-environment-variable-save-thousands-of-system-calls/
export TZ=:/etc/localtime

export GOPATH="$HOME/go"
export PATH="$PATH:$HOME/.cabal/bin"
export PATH="$PATH:$HOME/lib/scripts/"
export PATH="$PATH:$HOME/.cargo/bin/"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$GOPATH/bin"

# Trim prompt directory
export PROMPT_DIRTRIM=2

export ALTERNATE_EDITOR=""
export EDITOR="emacs"
export VISUAL="emacs"
export GIT_EDITOR="nano"
export LEDGER_FILE="$HOME/Documentos/finance/2020.journal"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
