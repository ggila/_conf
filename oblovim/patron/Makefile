# **************************************************************************** #
#                __  __   _   _  _____ ___ ___ _    ___                        # 
#               |  \/  | /_\ | |/ / __| __|_ _| |  | __|                       #
#               | |\/| |/ _ \| ' <| _|| _| | || |__| _|                        # 
#               |_|  |_/_/ \_\_|\_\___|_| |___|____|___|                       #
#                                                                    ggilaber  #
# **************************************************************************** #

####
# Variables internes:
#    $@ -> nom cible
#    $< -> nom premiere dependance
#    $^ -> liste dependance
#    $? -> liste depandances plus recentes que cible
#    $* -> nom fichier sans suffixe
###

.PHONY: all clean fclean re

# Project name
NAME = hello

# Source
C_DIR = src
C_FILE = hello.c\
	main.c
SRC = $(addprefix $(C_DIR)/, $(C_FILE))

H_DIR = inc
INC = inc/hello.h

# Obj directory
O_DIR = obj

O_FILE = $(C_FILE:.c=.o)
OBJ = $(addprefix $(O_DIR)/, $(O_FILE))

# C compiler
CC = gcc

# C flags
FLAGS = -Wall -Wextra -Werror

# Linking flags
# LD_FLAGS =


all: $(NAME)

$(NAME): $(O_DIR) $(OBJ)
	$(CC) -o $@ $(OBJ) $(FLAGS)

$(O_DIR)/%.o : $(C_DIR)/%.c $(INC)
	$(CC) $(FLAGS) -I $(H_DIR) -c $< -o $@

$(O_DIR):
	mkdir -p $(O_DIR)

clean:
	rm -rf $(O_DIR)

fclean: clean
	rm -f $(NAME)

re: fclean all
