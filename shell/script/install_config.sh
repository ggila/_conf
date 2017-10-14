#!/bin/bash

CONF_FILE="
vimrc
bashrc
zshrc
gitconfig
tmux.conf
"

#if [[ ! -d "_conf" || ! -f "_conf/shell/var_env" ]]; then 
#  echo 'non'
#  exit 1
#fi

source "$HOME/_conf/var_env.sh"

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
    rm -f "$HOME/.$conf_file"
    ln -s "$_CONF_DIR/$conf_file" "$HOME/.$conf_file"
done

#for conf_file in $CONF_FILE
#do
#    if is_set $conf_file; then
#        echo "overwrite $conf_file ([y]/n) ?"
#        if get_answer $conf_file; then
#            set_conf $conf_file
#        fi
#    fi
#done

exit
