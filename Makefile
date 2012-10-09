DEPS := $(shell ls *.lua lua/*.lua)

all: release/PokemonXP.Windows.zip release/PokemonXP.love

release/PokemonXP.love: $(DEPS) release/data.zip
	zip -r9 -FS release/PokemonXP.love *.lua data lua
	
release/data.zip: data
	zip -r9 -FS release/data.zip data

# aprender a gerar rpm
#release/pokemonxp: release/PokemonXP.love
#	@echo Generating binaries...
#	@cat /usr/bin/love release/PokemonXP.love > release/pokemonxp

release/PokemonXP.Windows.zip: release/.tmp/PokemonXP.exe
	zip -j9 -FS release/PokemonXP.Windows.zip release/.tmp/*.dll release/.tmp/PokemonXP.exe readme.txt gpl.txt

release/.tmp/PokemonXP.exe: release/PokemonXP.love
	cat release/.tmp/love.exe release/PokemonXP.love > release/.tmp/PokemonXP.exe

.PHONY clean:
	rm -f release/PokemonXP.love
	rm -f release/PokemonXP.Windows.zip

