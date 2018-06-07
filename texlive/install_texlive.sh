#!/bin/bash

# Use sane version of bash
set -ueo pipefail

# Check if TexLive 2018 is already installed
if [ ! -x "$(command -v foo)" ]
then
    echo "Running TexLive 2018 installer."

    # Move to the home directory
    INITIAL_DIRECTORY="$PWD"
    cd || exit 1

    # Download and extract the TexLive 2018 Installer
    curl -sL http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar zxf -
    mv install-tl-2018* install-tl
    cd install-tl || exit 1 # Exit if any error occurs in cd

    # Generate an installation profile
    {
        echo "selected_scheme scheme-basic"
        echo "TEXDIR /tmp/texlive"
        echo "TEXMFCONFIG ~/.texlive/texmf-config"
        echo "TEXMFHOME ~/texmf"
        echo "TEXMFLOCAL /tmp/texlive/texmf-local"
        echo "TEXMFSYSCONFIG /tmp/texlive/texmf-config"
        echo "TEXMFSYSVAR /tmp/texlive/texmf-var"
        echo "TEXMFVAR ~/.texlive/texmf-var"
        echo "option_doc 0"
        echo "option_src 0"
    } > profile

    # Run installer
    ./install-tl -profile profile -repo http://ctan.mirrors.hoobly.com/systems/texlive/tlnet

    # Cleanup
    cd ..
    rm -rf install-tl

    # Update PATH
    export PATH="/tmp/texlive/bin/x86_64-linux:$PATH"

    # Initialize some data structure required for tlmgr
    tlmgr init-usertree

    # Restore initial directory
    cd "$INITIAL_DIRECTORY"
else
    echo "TexLive 2018 is already installed."

    # Check tlmgr version
    tlmgr version -v

    # Update tlmgr existing other packages
    tlmgr update --self --all --no-auto-install
fi

# List available Latex packages
tlmgr info --only-installed ||
        echo "Couldn't retrieve the texlive package list\!"
