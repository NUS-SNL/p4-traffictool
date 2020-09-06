#!/bin/bash

target_file="$HOME/.bash_aliases"

echo "The p4-traffictool alias will be removed from your bash configuration"
while true; do
    read -p "Do you wish to continue (y/n)?" yn
    case $yn in
        [Yy]* ) sed -i '/p4-traffictool/d' "$target_file"; break;;
        [Nn]* ) echo "You can remove the alias manually by searching for p4-traffictool in $target_file";exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

source "$HOME/.bashrc"