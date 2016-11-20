#!/bin/sh

BAKUP_DIR='~/.bakup'

# bakup
if [ ! -e $BAKUP_DIR ]
then
	mkdir $BAKUP_DIR
fi


# git
sudo apt-get install git
git config --global user.name post
git config --global user.email weixiaoyiri@gmail.com
git config --global core.editor vim

git clone git@github.com:wusuluren/conf.git


# zsh & oh-my-zah
sudo apt-get install zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
cat ./conf/.zshrc >> ~/.zshrc

sudo cp /etc/passwd $BAKUP_DIR
sudo sed -i '$s/bin\/bash/usr\/bin\/zsh/g' /etc/passwd


# vim
sudo apt-get install vim
if [ ! -e ~/.vimrc ]
then
	touch ~/.vimrc
fi
cat ./conf/.vimrc >> ~/.vimrc 


# tmux
sudo apt-get install tmux
if [ ! -e ~/.tmux.conf ]
then
	touch ~/.tmux.conf
fi
cat ./conf/.tmux.conf >> ~/.tmux.conf


# wiznote
sudo add-apt-repository ppa:wiznote-team
sudo apt-get install wiznote


# python
sudo apt-get install python-pip
pip install virtualenv
virtualenv --no-site-packages ~/pytest

sudo apt-get install python-pip3
pip3 install virtualenv
virtualenv --no-site-packages ~/py3test


# docker(on Ubuntu 16.04 LTS)
sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee	/etc/apt/sources.list.d/docker.list
sudo apt-get update

sudo apt-get install docker-engine
sudo systemctl enable docker
sudo systemctl start docker
sudo groupadd docker
sudo usermod -aG docker $USER