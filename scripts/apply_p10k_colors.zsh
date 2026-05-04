#!/usr/bin/env zsh
set -e

P10K_CONFIG="$HOME/.p10k.zsh"
P10K_LOCAL="$HOME/.p10k.local.zsh"

if [[ ! -f "$P10K_CONFIG" ]]; then
  echo "ERROR: $P10K_CONFIG not found"
  exit 1
fi

cat <<'LOCAL_EOF' > "$P10K_LOCAL"
# Custom p10k prompt colors
# Directory: slightly bright muted green
typeset -g POWERLEVEL9K_DIR_FOREGROUND=78
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=78
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=78

# Prompt char: deep blue
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=32
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND=32
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIVIS_FOREGROUND=32
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIOWR_FOREGROUND=32

# Error prompt char: red
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND=196
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND=196
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIVIS_FOREGROUND=196
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIOWR_FOREGROUND=196
LOCAL_EOF

SOURCE_LINE='[[ -f ~/.p10k.local.zsh ]] && source ~/.p10k.local.zsh'

if ! grep -Fxq "$SOURCE_LINE" "$P10K_CONFIG"; then
  {
    echo ""
    echo "# Load local p10k overrides"
    echo "$SOURCE_LINE"
  } >> "$P10K_CONFIG"
fi

echo "Applied p10k colors:"
echo "  DIR          = 78"
echo "  PROMPT_CHAR  = 32"
echo "  Local config = $P10K_LOCAL"