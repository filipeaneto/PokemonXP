all:
	zip -r9 -FS PokemonXP.love *.lua data lua
	@ ls -lha PokemonXP.love
	@ echo $(SIZE) "->"
	@ ls -lha PokemonXP.love

clean:
	rm PokemonXP.love

