LUA := $(shell ls *.lua lua/*.lua serial/*.lua)
SPRITE := $(shell ls data/sprite/*.spr data/sprite/*.spt)
IMAGES := $(shell ls data/image/*.png)

all: release/PokemonXP.Windows.zip release/PokemonXP.love

release/PokemonXP.love: $(LUA) release/data.zip
	zip -r9 -FS release/PokemonXP.love *.lua data lua serial

release/data.zip: $(SPRITE) $(IMAGES)
	zip -r9 -FS release/data.zip data

release/PokemonXP.Windows.zip: release/.tmp/PokemonXP.exe
	zip -j9 -FS release/PokemonXP.Windows.zip release/.tmp/*.dll release/.tmp/PokemonXP.exe readme.txt gpl.txt

release/.tmp/PokemonXP.exe: release/PokemonXP.love
	cat release/.tmp/love.exe release/PokemonXP.love > release/.tmp/PokemonXP.exe

.PHONY clean:
	rm -f release/PokemonXP.love
	rm -f release/PokemonXP.Windows.zip

