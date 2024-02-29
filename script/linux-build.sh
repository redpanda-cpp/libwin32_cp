#!/bin/sh

xmake f -p mingw -a i386 --mingw=/usr
xmake b
xmake i -o pkg/i686-w64-mingw32

xmake f -p mingw -a x86_64 --mingw=/usr
xmake b
xmake i -o pkg/x86_64-w64-mingw32

