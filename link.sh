#!/bin/bash

exclude=`basename $0`
dir=`pwd`

ls | grep -v $exclude | while read file; do
    dest=~/.$file
    if [[ -e $dest ]]; then
	echo "$dest exists, skipping"
    else
	echo "linking $file"
	ln -s $dir/$file $dest
    fi
done
