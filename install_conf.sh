
#!/bin/bash

CONF_DIR="$HOME/_conf"

declare -A FILES=(
  ["$CONF_DIR/zshrc"]="$HOME/.zshrc"
  ["$CONF_DIR/bashrc"]="$HOME/.bashrc"
  ["$CONF_DIR/tmux.conf"]="$HOME/.tmux.conf"
  ["$CONF_DIR/vimrc"]="$HOME/.vimrc"
)

for SRC in "${!FILES[@]}"; do
  DEST="${FILES[$SRC]}"
  if [ -e "$DEST" ] || [ -L "$DEST" ]; then
    echo "Skipping: $DEST already exists"
  else
    ln -s "$SRC" "$DEST"
    echo "Linked: $SRC → $DEST"
  fi
done

if [ -n "$ZSH_VERSION" ]; then
    source ~/.zshrc
    echo "source ~/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    source ~/.bashrc
    echo "source ~/.bashrc"
fi
