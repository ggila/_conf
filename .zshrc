PATH=~/.brew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/texbin:$HOME/.brew/bin
HISTFILE=~/.zshrc_history
SAVEHIST=5000
HISTSIZE=5000


setopt inc_append_history
setopt share_history

if [[ -f ~/.myzshrc ]]; then
	source ~/.myzshrc
fi

USER=`/usr/bin/whoami`
export USER
GROUP=`/usr/bin/id -gn $user`
export GROUP
MAIL="$USER@student.42.fr"
export MAIL

#Color
autoload -U colors && colors

PS1="%{$fg[red]%}%m %{$fg[green]%}%~%{$reset_color%}|%"
#
##ALIAS
alias ..='cd ..'
alias ...='cd ../..'
alias dd='clear'
alias szsh='source ~/.zshrc'
alias gs='git status'
alias gss='git status --porcelain'

function ll
{
	ls -lbFhgo $@ | sed -E "s/([^ ]+)( +)([^ ]+)( +)([^ ]+)( +[^ ]+ +[^ ]+ +[^ ]+) (.+)/[\1] `printf "\033[1;30m"`\6  `printf "\033[0;36m"`(\5 +\3)`printf "\033[0m"` \4\2\7/" | sed "s/ +1)/)   /"
};

function la
{
	ls -lAbFhgo $@ | sed -E "s/([^ ]+)( +)([^ ]+)( +)([^ ]+)( +[^ ]+ +[^ ]+ +[^ ]+) (.+)/[\1] `printf "\033[1;30m"`\6  `printf "\033[0;36m"`(\5 +\3)`printf "\033[0m"` \4\2\7/" | sed "s/ +1)/)   /"
};

function gc
{
	dir="$1";
	git clone https://github.com/ggila/"$1".git;
}

man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
		man "$@"
}

# Get vim info in prompt
function _ps1_git_rev()
{
	if [[ "$4" -gt "0" ]]; then
		printf "%s" "$2-$4$3 "
	fi
	if [[ "$5" -gt "0" ]]; then
		printf "%s" "$1+$5$3 "
	fi
};

function _ps1_git()
{
	BRANCH=`git rev-parse --abbrev-ref HEAD 2> /dev/null` > /dev/null
	if [[ $? -eq 0 ]]; then
		if [[ ! "$BRANCH" == "master" ]]; then
			PRINT="[$BRANCH] "
		else
			PRINT=""
		fi
		STATUS=$(git status --porcelain)
		COLUM1=`echo "$STATUS" | cut -c 1-1`
		COLUM2=`echo "$STATUS" | cut -c 2-2`
		if [[ "$COLUM1" == *"A"* ]]; then
			PRINT=$PRINT"$1A"
		fi
		if [[ "$COLUM1" == *"D"* ]]; then
			PRINT=$PRINT"$1D"
		fi
		if [[ "$COLUM1" == *"M"* ]]; then
			PRINT=$PRINT"$1M"
		fi
		if [[ "$COLUM1" == *"R"* ]]; then
			PRINT=$PRINT"$1R"
		fi
		if [[ "$COLUM2" == *"D"* ]]; then
			PRINT=$PRINT"$2D"
		fi
		if [[ "$COLUM2" == *"M"* ]]; then
			PRINT=$PRINT"$2M"
		fi
		if [[ "$COLUM2" == *"?"* ]]; then
			PRINT=$PRINT"$2?"
		fi
		if [[ "${#PRINT}" -gt "0" ]]; then
			printf "|%s| " "$PRINT$3"
		fi
		_ps1_git_rev "$1" "$2" "$3" `git rev-list --left-right --count origin...HEAD 2> /dev/null || echo "0 0"`
	fi
};

function precmd()
{
	export PROMPT="%F{blue}%m%f%F{blue} @ %f%F{cyan}%~%f `_ps1_git "%F{blue}" "%F{cyan}" "%f"`"
};

# Save Go
# save --help

function save()
{
	if [[ "$1" == "-g" ]]; then
		cd "`save -i "$2"`"
	elif [[ "$1" == "-i" ]]; then
		if [[ -f ~/.save_go ]]; then
			cat ~/.save_go | grep -m 1 -i '^'"$2"'=' | cut -d '=' -f 2
		fi
	elif [[ "$1" == "-s" ]]; then
		if [[ -f ~/.save_go ]]; then
			if [[ "$2" == "" ]]; then
				_SAVE="`pwd`"
			else
				_SAVE="$2"
			fi
			cat ~/.save_go | grep -m 1 -i '='"$_SAVE"'$' | cut -d '=' -f 1
		fi
	elif [[ "$1" == "-l" ]]; then
		if [[ "$2" == "" ]]; then
			if [[ -f ~/.save_go ]]; then
				grep -v '^$' ~/.save_go
			fi
		else
			save -i "$2"
		fi
	elif [[ "$1" == "-r" ]]; then
		if [[ -f ~/.save_go ]]; then
			if [[ "$2" == "" ]]; then
				_SAVE="`save -s`"
			else
				_SAVE="$2"
			fi
			grep -iv '^'"$_SAVE"'=' ~/.save_go > ~/.save_go.tmp
			mv ~/.save_go.tmp ~/.save_go 2> /dev/null
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
		echo "All the saves are stored in '~/.save_go'"
	else
		save -r "$1"
		echo >> ~/.save_go
		echo -n "$1"'=' >> ~/.save_go
		pwd >> ~/.save_go
		grep -v '^$' ~/.save_go > ~/.save_go.tmp
		mv ~/.save_go.tmp ~/.save_go 2> /dev/null
	fi
};

alias go="save -g"
