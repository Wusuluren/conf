#!/bin/sh

#usage:
#
#do this:
#wget https://github.com/Wusuluren/conf/blob/master/system_init.sh
#bash system_init.sh
#
#or this:
#git clone git@github.com:wusuluren/conf.git
#bash ./conf/system_init.sh -no-clone


NO_CLONE="$1"
BAK_DIR='~/.rm_bak'

# bakup
if [ ! -e $BAK_DIR ]
then
	mkdir $BAK_DIR
fi


# git
sudo apt-get -y install git
git config --global user.name post
git config --global user.email weixiaoyiri@gmail.com
git config --global core.editor vim

if [ "-no-clone" != "$NO_CLONE" ]
then
    git clone git@github.com:wusuluren/conf.git
fi


# zsh & oh-my-zah
sudo apt-get -y install zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
cat ./conf/.zshrc >> ~/.zshrc

sudo cp /etc/passwd "$BAK_DIR"
sudo sed -i '$s/bin\/bash/usr\/bin\/zsh/g' /etc/passwd

# vim
sudo apt-get -y install vim
if [ ! -e ~/.vimrc ]
then
	touch ~/.vimrc
fi
cat ./conf/.vimrc >> ~/.vimrc 


# tmux
sudo apt-get -y install tmux
if [ ! -e ~/.tmux.conf ]
then
	touch ~/.tmux.conf
fi
cat ./conf/.tmux.conf >> ~/.tmux.conf


# wiznote
sudo add-apt-repository ppa:wiznote-team
sudo apt-get -y install wiznote


# python
sudo apt-get -y install python-pip
pip install virtualenv
virtualenv --no-site-packages ~/pytest

sudo apt-get -y install python-pip3
pip3 install virtualenv
virtualenv --no-site-packages ~/py3test


# docker(on Ubuntu 16.04 LTS)
sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual
sudo apt-get update
sudo apt-get -y install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee	/etc/apt/sources.list.d/docker.list
sudo apt-get update

sudo apt-get -y install docker-engine
sudo systemctl enable docker
sudo systemctl start docker
sudo groupadd docker
sudo usermod -aG docker $USER
