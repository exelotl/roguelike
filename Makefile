DIR=roguelike
NAME=roguelike

all:
	rock $(NAME).use --noclean -v -o=$(NAME) -g

release:
	rock $(NAME).use --noclean -v -o=$(NAME) +-O2

run:
	./$(NAME)

clean:
	rm -rf rock_tmp .libs
	
test: all
	gdb -ex run ./$(NAME)
	
package_win32: release
	rm -f $(NAME).zip
	cd .. && 7z a $(DIR)/$(NAME).zip $(DIR)/$(NAME).exe $(DIR)/SDL2.dll $(DIR)/assets
	