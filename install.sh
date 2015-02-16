#!/usr/bin/env bash

pushd $(dirname $0) &> /dev/null

for dot in $(ls); do
    if [[ ! $dot == "README.rst" ]] && [[ ! $dot == "install.sh" ]] && [[ ! $dot == "xinitrc" ]] && [[ ! $dot == "Xdefaults" ]] && [[ ! $dot == "terminfo" ]]; then
        target="$HOME/.$dot"

	# Make a .bak of a file or dir
	if [[ ! -h $target ]]; then
	    if [[ -d $target ]] || [[ -f $target ]]; then
		mv $target $target.bak
	    fi
	fi

	echo "Setting $dot"
	ln -sf "$PWD/$dot" "$target"
    fi
done


mkdir -p "$HOME/.vim/"{bundle}

if [[ ! -d "$HOME/.vim/bundle/vundle" ]]; then
    echo "Installing vundle"
    git clone https://github.com/gmarik/vundle.git "$HOME/.vim/bundle/vundle" &> /dev/null
    echo "Now start vim and run:"
    echo ":BundleInstall"
else
    echo "Vundle already installed"
fi

echo "Running bundle update"
vim -c BundleUpdate -c qa &> /dev/null

source ~/.bashrc

popd &> /dev/null
