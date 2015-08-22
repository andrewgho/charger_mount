# Makefile - create STL files from OpenSCAD source
# Andrew Ho (andrew@zeuscat.com)

ifeq ($(shell uname), Darwin)
  OPENSCAD = /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
else
  OPENSCAD = openscad
endif

TARGETS = charger_mount.stl

all: $(TARGETS)

charger_mount.stl: charger_mount.scad
	$(OPENSCAD) -o charger_mount.stl charger_mount.scad

clean:
	@rm -f $(TARGETS)
