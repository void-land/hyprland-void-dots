#!/bin/sh

file=$(echo $1 | cut -c 7-) 

mv $file ~/.local/share/Trash/files
