#!/bin/sh
cd src
dmd ../doc/mediainfo.ddoc -c -o- -wi -D -Dd../doc/generated/ -Dfc_mediainfo.html c/mediainfo.d
dmd ../doc/mediainfo.ddoc -c -o- -wi -D -Dd../doc/generated/ -Dfmediainfo.html mediainfo.d
cd ../
