#!/bin/zsh

function ask_for_homebrew {
    echo "Missing hombebrew"
    echo "Please isntall it"
    echo ""
    echo "https://brew.sh/"
    echo ""
    exit 1
}

brew --version || ask_for_homebrew

brew install dialog
