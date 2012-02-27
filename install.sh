#!/bin/bash

exclude=`basename $0`
dir=`pwd`
cd $dir

ls | grep -v $exclude | while read file; do
    dest=~/.$file
    if [[ -e $dest ]]; then
	echo "skipping - $dest (dest exists)"
    else
	echo "linking  - $file"
	ln -s $dir/$file $dest
    fi
done
