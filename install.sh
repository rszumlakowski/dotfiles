#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

install() {
  source=$1
  target=$2

  if [[ -f $source ]]; then
    if [[ -f $target ]]; then
      if [[ ! -L $target ]]; then
        read -r -p "'$target' already exists.  Replace it with a symbolic link? (y/n) " choice
        choice_first_char=${choice:0:1}
        if [[ $choice_first_char = y || $choice_first_char = Y ]]; then
          echo "Deleting '$target'."
          rm "$target"
        else
          echo "Skipping installation of '$target'."
          return
        fi
      else
        echo "'$target' is already installed as a symbolic link."
        return
      fi
    fi
  elif [[ -d $source ]]; then
    if [[ -d $target ]]; then
      if [[ ! -L $target ]]; then
        echo "Error: '$target' already exists and is a directory.  I'm too chicken to run 'rm -rf' on it. Exiting."
        exit 1
      fi
    fi
  else
    echo "Error: '$source' must be a file or directory."
    return
  fi

  source_with_dir="$SCRIPT_DIR/$source"
  echo "Creating symbolic link from '$source_with_dir' to '$target'."

  ln -s "$source_with_dir" "$target"
}

install "bash_profile" "$HOME/.bash_profile"
install "tmux.conf" "$HOME/.tmux.conf"
install "bin/imgcat" "$HOME/bin/imgcat"
install "bin/imgls" "$HOME/bin/imgls"
install "bin/rotate_video_ccw" "$HOME/bin/rotate_video_ccw"
install "bin/rotate_video_cw" "$HOME/bin/rotate_video_cw"
install "bin/Mount Network Drives.app" "$HOME/bin/Mount Network Drives.app"
