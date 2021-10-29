#!/bin/bash

SVGO=$(command -v svgo)
if [ ! -e "${SVGO}" ]; then
		echo "ERROR - SVGO not found. Install with npm."
		echo "    npm install -g svgo"
		exit 1
fi

SVGEXPORT=$(command -v svgexport)
if [ ! -e "${SVGEXPORT}" ]; then
		echo "ERROR - svgexport not found. Install with npm."
		echo "    npm install -g svgexport"
		exit 1
fi

PROJECT_ROOT=$(pwd)
OUTPUT_DIR="$PROJECT_ROOT/build"

FILES=""
OUTPUT_FILES=""

if [ ! -d "$OUTPUT_DIR" ]; then
		mkdir $OUTPUT_DIR
fi

if [ -d "$OUTPUT_DIR/svg" ]; then
		rm -r "$OUTPUT_DIR/svg"
fi
mkdir $OUTPUT_DIR/svg

if [ -d "$OUTPUT_DIR/png" ]; then
		rm -r "$OUTPUT_DIR/png"
fi
mkdir $OUTPUT_DIR/png

for i in $PROJECT_ROOT/src/*.svg; do
		FILES="$FILES$i "
		SVG_OUTPUT=${i/src/build\/svg}
		OUTPUT_FILES="$OUTPUT_FILES$SVG_OUTPUT "
		PNG_OUTPUT=${i/src/build\/png}
		PNG_OUTPUT=${PNG_OUTPUT/.svg/.png}
		${SVGEXPORT} "$i" $PNG_OUTPUT 512
done

${SVGO} $FILES -o $OUTPUT_FILES

cd $PROJECT_ROOT/build/
echo "Creating archive"
tar cvzf quickemu-icons.tar.gz *
echo "Done - quickemu-icons.tar.gz created in build/"
