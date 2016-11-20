#!/bin/sh

# bakup
mkdir ~/.bakup

# git
sudo apt-get install git
git clone git://github.com/wusuluren/conf.git

# zsh & oh-my-zah
sudo apt-get install zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
cp /etc/passwd ~/.bakup
sed -i '$s/bin\/bash/usr\/bin\/zsh/g' /etc/passwd

cat ./conf/.zshrc >> ~/.zshrc

# vim
sudo apt-get install vim
touch ~/.vimrc
cat ./conf/.vimrc >> ~/.vimrc 

# tmux
sudo apt-get install tmux
touch ~/.tmux.conf
cat ./conf/.tmux.conf >> ~/.tmux.conf
