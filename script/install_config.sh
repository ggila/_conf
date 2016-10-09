#!/bin/bash

CONF_DIR=$HOME/config
CONF_FILE="
vimrc
bashrc
zshrc
gitconfig
"

echo $HOME

get_answer () {
  while :
  do
    read answer
    if [[ $answer == '' || $answer == 'y' ]]; then
      return 0
    elif [[ $answer == 'n' ]]; then
      return 1
    fi
  done
}

set_conf () {
    echo $1 installed
}


for conf_file in $CONF_FILE
do
    echo "overwrite $conf_file ([y]/n) ?"
    if get_answer $conf_file; then
      set_conf $conf_file
    fi
done

exit
