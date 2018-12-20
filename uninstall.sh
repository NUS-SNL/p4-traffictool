#!/bin/bash

target_file="$HOME/.bashrc"
# target_file="p4-traffictool/test.txt"
echo "$target_file will be restored to $target_file.p4-traffictool.bak"

restore_bak(){
	ls "$target_file.p4-traffictool.bak" > /dev/null 2>&1
	if [[ $? != "0" ]]; then
		echo "$target_file.p4-traffictool.bak not found!"
		echo "You can remove the alias manually by searching for p4-traffictool in $target_file"
	else
		mv "$target_file.p4-traffictool.bak" "$target_file"
	fi
}

while true; do
    read -p "Do you wish to continue (y/n)?" yn
    case $yn in
        [Yy]* ) restore_bak; break;;
        [Nn]* ) echo "You can remove the alias manually by searching for p4-traffictool in $target_file";exit;;
        * ) echo "Please answer yes or no.";;
    esac
done