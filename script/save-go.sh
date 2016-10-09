#
# script made by jaguillo in:
# https://github.com/Julow/env
#
# Save Go
#
# Create 'bookmark' for working directories
#
# Can store unlimited save + one unamed save
#
# save [save name]
# (save a directory)
#
# go [save name]
# (cd to this directory)
#
# (save --help) for more commands
#

SAVE_FILE="$_CONF_DIR/script/save_go_dirlist"

function save()
{
	if [[ "$1" == "-g" ]]; then
		cd "`save -i "$2"`"
	elif [[ "$1" == "-i" ]]; then
		if [[ -f $SAVE_FILE ]]; then
			cat $SAVE_FILE | grep -m 1 -i '^'"$2"'=' | cut -d '=' -f 2
		fi
	elif [[ "$1" == "-s" ]]; then
		if [[ -f $SAVE_FILE ]]; then
			if [[ "$2" == "" ]]; then
				_SAVE="`pwd`"
			else
				_SAVE="$2"
			fi
			cat $SAVE_FILE | grep -m 1 -i '='"$_SAVE"'$' | cut -d '=' -f 1
		fi
	elif [[ "$1" == "-l" ]]; then
		if [[ "$2" == "" ]]; then
			if [[ -f $SAVE_FILE ]]; then
				grep -v '^$' $SAVE_FILE
			fi
		else
			save -i "$2"
		fi
	elif [[ "$1" == "-r" ]]; then
		if [[ -f $SAVE_FILE ]]; then
			if [[ "$2" == "" ]]; then
				_SAVE="`save -s`"
			else
				_SAVE="$2"
			fi
			grep -iv '^'"$_SAVE"'=' $SAVE_FILE > $SAVE_FILE.tmp
			mv $SAVE_FILE.tmp $SAVE_FILE 2> /dev/null
		fi
	elif [[ "$1" == "--help" ]]; then
		save -h
	elif [[ "$1" == "-h" ]]; then
		echo "Save/Go"
		echo "    save -g <save>            Go to <save>"
		echo "    save -i <save>            Print the path of <save>"
		echo "    save -s                   Search the save with the current dir"
		echo "    save -s <dir>             Search the save with <dir>"
		echo "    save -l                   Print the list of saves"
		echo "    save -l <save>            Alias for 'save -i'"
		echo "    save -r                   Search and remove the save with the current dir"
		echo "    save -r <save>            Remove <save>"
		echo "    save -h"
		echo "    save --help               Print this message"
		echo
		echo "    save <save>               Create <save> with the current dir"
		echo "    go <save>                 Alias for 'save -g'"
		echo "    saved                     Alias for 'save -l'"
		echo
		echo "A save can have any name"
		echo "If <save> is blank, it refer to a save with no name."
		echo "All the saves are stored in '$SAVE_FILE'"
	else
		save -r "$1"
		echo >> $SAVE_FILE
		echo -n "$1"'=' >> $SAVE_FILE
		pwd >> $SAVE_FILE
		grep -v '^$' $SAVE_FILE > $SAVE_FILE.tmp
		mv $SAVE_FILE.tmp $SAVE_FILE 2> /dev/null
	fi
};

alias go="save -g"
alias saved="save -l"
