# Makefile - create STL files from OpenSCAD source
# Andrew Ho (andrew@zeuscat.com)

ifeq ($(shell uname), Darwin)
  OPENSCAD = /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
else
  OPENSCAD = openscad
endif

TARGETS = bottom_bracket.stl top_bracket.stl

all: $(TARGETS)

bottom_bracket.stl: dimensions.scad charger.scad biarc_cutout.scad bottom_bracket.scad
	$(OPENSCAD) -o bottom_bracket.stl bottom_bracket.scad

top_bracket.stl: dimensions.scad charger.scad top_bracket.scad
	$(OPENSCAD) -o top_bracket.stl top_bracket.scad

clean:
	@rm -f $(TARGETS)
