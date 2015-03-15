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

if [[ ! -d "$HOME/.bash-git-prompt" ]]; then
    git clone https://github.com/magicmonty/bash-git-prompt.git "$HOME/.bash-git-prompt"
fi

mkdir -p "$HOME/.vim/bundle"
mkdir -p "$HOME/.vim/indent"
mkdir -p "$HOME/.vim/ftplugin"
ln -sf "$PWD/indent/python.vim" "$HOME/.vim/indent/python.vim"
ln -sf "$PWD/ftplugin/python.vim" "$HOME/.vim/ftplugin/python.vim"

if [[ ! -d "$HOME/.vim/bundle/Vundle.vim" ]]; then
    echo "Installing vundle"
    git clone https://github.com/gmarik/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim" &> /dev/null
else
    echo "Vundle already installed"
fi

echo "Installing Vundle Plugins"
vim +PluginInstall +qall

if [[ ! -f "$HOME/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so" ]]; then
    echo "Compiling YouCompleteMe"
    sudo apt-get install build-essential cmake
    sudo apt-get install python-dev
    "$HOME/.vim/bundle/YouCompleteMe/install.sh"
fi

sudo apt-get install ctags

source ~/.bashrc

popd &> /dev/null
