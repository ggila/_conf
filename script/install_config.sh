#!/bin/bash

HOME=~
CONF_DIR=$HOME/config
CONF_FILE="
vimrc
bashrc
zshrc
"


get_answer () {
  while :
  do
    read answer
    if [[ $answer == 'y' ||\
          $answer == 'n' ||\
          $answer == '' ]]; then
      [[ $answer == 'n' ]]
      return
    fi
  done
}

set_conf () {
    echo $1 installed
}


for conf_file in $CONF_FILE
do
    echo "overwrite $conf_file ? (\[y\]/n)"
    get_answer $conf_file
    action=$
    if [[ $action == 0 ]]; then
        continue
    fi
    set_conf $conf_file
done

exit
