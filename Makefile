SIZE := $(shell ./size)

all:
	zip -r9 -FS PokemonXD.love *.lua data lua
	@ echo $(SIZE) "->"
	@ ./size

clean:
	rm PokemonXD.love

