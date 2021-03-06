#!/bin/bash

#https://github.com/pjhades/bash-snake

#About
#---------------
#A simple snake game written in Bash.
#
#
#How to Play
#---------------
#Direction control: vim-style keys h, j, k and l;
#Quit: q
#Accept both upper- and lower-case.
#
#
#Some Implementation Details
#---------------
# * Bash-snake has two processes, the foreground one responds to 
#   user's control commands, the background one draws the board.
#   `kill` and `trap` are used to enable communication between the two processes.
#   
#   The foreground process `getchar()` ignores `SIGINT` and `SIGQUIT`, and
#   replies to the signal of death `SIG_HEAD` by returning from the function `getchar()`.
#
#   The background process `game_loop()` traps direction control signals from the keyboard,
#   and self-defined signal `SIG_QUIT` which indicates the press of Q button.
#
# * Use $! to grasp the PID of the latest created background process.
#
# * When setting up several traps, it's necessary to guarantee that 
#   the normal execution will not be interrupted by the signal handling 
#   if the handlers envolve modification of some variables it depends on.
#
# * The snake is represented by the coordinate $head\_r and $head\_c indicating
#   the row and column on which the snake head is, and a string $body which
#   stores the directions from the head to tail. 
#   e.g. a snake with this shape (@ is the head):
#
#        @
#        oooo
#           o
#
#   will have a $body with value '21112', meaning 'down,right,right,right,down'.
#   
#   With the above scheme and the coordinates of the snake head, we can figure out
#   the position the the entire snake body, without storing every part of its body.
#
# * The board is represented by a "2D array", which is actually implemented by
#   a bunch of bash arrays and the `eval` command. For example, assigning 123 to the
#   array entry `arr[5][6]` is done with `eval "arr$i[$j]=123"`.
#
# * The board is re-drawn in each iteration, which happens every 0.03 seconds.
#
# * Coloring is implemented with the escaped sequences of the terminal.

IFS=''

declare -i height=30 width=60

# row and column number of head
declare -i head_r head_c tail_r tail_c

declare -i alive  
declare -i length
declare body

declare -i direction delta_dir
declare -i score=0

border_color="\E[30;43m"
snake_color="\E[32;42m"
food_color="\E[34;44m"
text_color="\E[31;43m"
no_color="\E[0m"

# signals
SIG_UP=35
SIG_RIGHT=36
SIG_DOWN=37
SIG_LEFT=38
SIG_QUIT=39
SIG_DEAD=40

# direction arrays: 0=up, 1=right, 2=down, 3=left
move_r=([0]=-1 [1]=0 [2]=1 [3]=0)
move_c=([0]=0 [1]=1 [2]=0 [3]=-1)

init_game() {
    clear
    echo -ne "\033[?25l"
    stty -echo
    for ((i=0; i<height; i++)); do
        for ((j=0; j<width; j++)); do
            eval "arr$i[$j]=' '"
        done
    done
}

move_and_draw() {
    echo -ne "\E[${1};${2}H$3" 
}

# print everything in the buffer
draw_board() {
    move_and_draw 1 1 "$border_color+$no_color"
    for ((i=2; i<=width+1; i++)); do
        move_and_draw 1 $i "$border_color-$no_color"
    done
    move_and_draw 1 $((width + 2)) "$border_color+$no_color"
    echo

    for ((i=0; i<height; i++)); do
        move_and_draw $((i+2)) 1 "$border_color|$no_color"
        eval echo -en "\"\${arr$i[*]}\""
        echo -e "$border_color|$no_color"
    done

    move_and_draw $((height+2)) 1 "$border_color+$no_color"
    for ((i=2; i<=width+1; i++)); do
        move_and_draw $((height+2)) $i "$border_color-$no_color"
    done
    move_and_draw $((height+2)) $((width + 2)) "$border_color+$no_color"
    echo
}

# set the snake's initial state
init_snake() {
    alive=0
    length=10
    direction=0
    delta_dir=-1

    head_r=$((height/2-2))
    head_c=$((width/2))

    body=''
    for ((i=0; i<length-1; i++)); do
        body="1$body"
    done

    local p=$((${move_r[1]} * (length-1)))
    local q=$((${move_c[1]} * (length-1)))

    tail_r=$((head_r+p))
    tail_c=$((head_c+q))

    eval "arr$head_r[$head_c]=\"${snake_color}o$no_color\""

    prev_r=$head_r
    prev_c=$head_c

    b=$body
    while [ -n "$b" ]; do
        # change in each direction
        local p=${move_r[$(echo $b | grep -o '^[0-3]')]}
        local q=${move_c[$(echo $b | grep -o '^[0-3]')]}

        new_r=$((prev_r+p))
        new_c=$((prev_c+q))

        eval "arr$new_r[$new_c]=\"${snake_color}o$no_color\""

        prev_r=$new_r
        prev_c=$new_c

        b=${b#[0-3]}
    done
}

is_dead() {
    if [ "$1" -lt 0 ] || [ "$1" -ge "$height" ] || \
        [ "$2" -lt 0 ] || [ "$2" -ge "$width" ]; then
        return 0
    fi

    eval "local pos=\${arr$1[$2]}"

    if [ "$pos" == "${snake_color}o$no_color" ]; then
        return 0
    fi

    return 1
}

give_food() {
    local food_r=$((RANDOM % height))
    local food_c=$((RANDOM % width))
    eval "local pos=\${arr$food_r[$food_c]}"

    while [ "$pos" != ' ' ]; do
        food_r=$((RANDOM % height))
        food_c=$((RANDOM % width))
        eval "pos=\${arr$food_r[$food_c]}"
    done

    eval "arr$food_r[$food_c]=\"$food_color@$no_color\""
}

move_snake() {
    local newhead_r=$((head_r + move_r[direction]))
    local newhead_c=$((head_c + move_c[direction]))

    eval "local pos=\${arr$newhead_r[$newhead_c]}"

    if $(is_dead $newhead_r $newhead_c); then
        alive=1
        return
    fi

    if [ "$pos" == "$food_color@$no_color" ]; then
        length+=1
        eval "arr$newhead_r[$newhead_c]=\"${snake_color}o$no_color\""
        body="$(((direction+2)%4))$body"
        head_r=$newhead_r
        head_c=$newhead_c

        score+=1
        give_food;
        return
    fi

    head_r=$newhead_r
    head_c=$newhead_c

    local d=$(echo $body | grep -o '[0-3]$')

    body="$(((direction+2)%4))${body%[0-3]}"

    eval "arr$tail_r[$tail_c]=' '"
    eval "arr$head_r[$head_c]=\"${snake_color}o$no_color\""

    # new tail
    local p=${move_r[(d+2)%4]}
    local q=${move_c[(d+2)%4]}
    tail_r=$((tail_r+p))
    tail_c=$((tail_c+q))
}

change_dir() {
    if [ $(((direction+2)%4)) -ne $1 ]; then
        direction=$1
    fi
    delta_dir=-1
}

getchar() {
    trap "" SIGINT SIGQUIT
    trap "return;" $SIG_DEAD

    while true; do
        read -s -n 1 key
        case "$key" in
            [qQ]) kill -$SIG_QUIT $game_pid
                  return
                  ;;
            [kK]) kill -$SIG_UP $game_pid
                  ;;
            [lL]) kill -$SIG_RIGHT $game_pid
                  ;;
            [jJ]) kill -$SIG_DOWN $game_pid
                  ;;
            [hH]) kill -$SIG_LEFT $game_pid
                  ;;
       esac
    done
}

game_loop() {
    trap "delta_dir=0;" $SIG_UP
    trap "delta_dir=1;" $SIG_RIGHT
    trap "delta_dir=2;" $SIG_DOWN
    trap "delta_dir=3;" $SIG_LEFT
    trap "exit 1;" $SIG_QUIT

    while [ "$alive" -eq 0 ]; do
        echo -e "\n${text_color}           Your score: $score $no_color"

        if [ "$delta_dir" -ne -1 ]; then
            change_dir $delta_dir
        fi
        move_snake
        draw_board
        sleep 0.03
    done
    
    echo -e "${text_color}Oh, No! You 0xdead$no_color"

    # signals the input loop that the snake is dead
    kill -$SIG_DEAD $$
}

clear_game() {
    stty echo
    echo -e "\033[?25h"
}

init_game
init_snake
give_food
draw_board

game_loop &
game_pid=$!
getchar

clear_game
exit 0
