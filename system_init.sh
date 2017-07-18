#!/usr/bin/env bash

#usage: wget https://github.com/Wusuluren/conf/blob/master/system_init.sh -q -O- | sh

home=$HOME
NO_CLONE="$1"
sys_bak=$HOME"/.sys_bak"

# passwd
echo "Please input password"
read passwd
echo "password is $passwd"
test ! -n $passwd && echo "password not set" && exit -1
run_sudo() {
	echo "$passwd" | sudo -S $@
	test $? != 0 &&	echo "sudo failed: $@"
}

# system bakup
test ! -e $sys_bak &&	mkdir -p $sys_bak

# hosts
run_sudo cp /etc/hosts "$sys_bak"
run_sudo wget https://raw.githubusercontent.com/racaljk/hosts/master/hosts -O /etc/hosts
test $? != 0 && run_sudo cp "$sys_bak/hosts" /etc/hosts
run_sudo /etc/init.d/networking restart
while [ true ];do
	status=`/etc/init.d/networking status | grep Active | awk '{print($2)}'`
	test "$status" = "active" && break
done

# install software
software_list=('zsh' 'git' 'vim' 'python' 'python-pip' 'python3' 'python3-pip' 'virtualenv' 'htop' 'tmux' 'curl')
for software in ${software_list[*]};do
	echo "installing $software"
	help_info=`$software --help 2>&1`
	test "$help_info" = "" &&	run_sudo apt-get install -y $software
done

# oh-my-zsh
if [ ! -e "$home/.oh-my-zsh" ];then
	wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
	run_sudo cp /etc/passwd "$sys_bak"
	run_sudo sed -i '$s/bin\/bash/usr\/bin\/zsh/g' /etc/passwd
fi

# git
git config --global user.name wusuluren
git config --global user.email weixiaoyiri@gmail.com

# config file
conf_url="https://raw.githubusercontent.com/Wusuluren/conf/master"
conf_files=('.bashrc' '.zshrc' '.vimrc' '.tmux.conf')
for conf_file in ${conf_files[*]};do
	if [ -e "$sys_bak/$conf_file" ];then
		cp "$sys_bak/$conf_file" "$home/$conf_file"
	else
		cp "$home/$conf_file" "$sys_bak"
	fi
	wget "$conf_url/$conf_file" -q -O- >> "$home/$conf_file"
done

# daily punch in
punch_in_dir="$home/.punch_in"
if [ ! -e $punch_in_dir ];then
	mkdir $punch_in_dir
	cd $punch_in_dir
	git clone git@github.com:Wusuluren/punch_in.git
	bash punch_in.sh install
fi

# srm
run_sudo chmod a+x ./srm
run_sudo cp ./srm /bin/srm
srm init

# wiznote
#sudo add-apt-repository ppa:wiznote-team
#sudo apt-get -y install wiznote

# docker(on Ubuntu 16.04 LTS)
#sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual
#sudo apt-get update
#sudo apt-get -y install apt-transport-https ca-certificates
#sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
#echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee	/etc/apt/sources.list.d/docker.list
#sudo apt-get update

#sudo apt-get -y install docker-engine
#sudo systemctl enable docker
#sudo systemctl start docker
#sudo groupadd docker
#sudo usermod -aG docker $USER
