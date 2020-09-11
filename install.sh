#!/bin/bash

target_file="$HOME/.bash_aliases"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 
echo "alias p4-traffictool=$DIR/p4-traffictool.sh" >> "$target_file"
echo "Added alias for p4-traffictool to $target_file"

source "$HOME/.bashrc"