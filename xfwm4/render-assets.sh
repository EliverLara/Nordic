#! /bin/bash

INKSCAPE="/usr/bin/inkscape"
OPTIPNG="/usr/bin/optipng"

for  screen in '' '-hdpi' '-xhdpi'; do
    for i in assets/*; do  
        BASE_FILE_NAME=`basename -s .svg $i`
        ASSETS_DIR="Nordic-darker-standard-buttons${screen}/xfwm4"
        case "${screen}" in
        -hdpi)
            DPI='144'
            ;;
        -xhdpi)
            DPI='192'
            ;;
        *)
            DPI='96'
            ;;
        esac

        mkdir -p $ASSETS_DIR

        if [ -f $ASSETS_DIR/$BASE_FILE_NAME.png ]; then
            echo $ASSETS_DIR/$BASE_FILE_NAME.png exists.
        else
            echo
            echo Rendering $ASSETS_DIR/$BASE_FILE_NAME.png
            $INKSCAPE --export-dpi=$DPI \
                    --export-filename=$ASSETS_DIR/$BASE_FILE_NAME.png $i \
            && $OPTIPNG -o7 --quiet $ASSETS_DIR/$BASE_FILE_NAME.png
        fi
    done
done
exit 0
