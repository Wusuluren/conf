
################################################################################
hexo_local() {
  hexo clean && hexo g && hexo s
}
hexo_remote() {
  hexo clean && hexo g && hexo d && hexo clean
}

run_sudo() {
	echo "$passwd" | sudo -S $@
	test $? != 0 &&	echo "sudo failed: $@"
}

export PATH=$PATH:/usr/local/go/bin
export GOPATH="$HOME/go"

bright() {
  if [ ! -n "$1" ];then
    cat << HELP
      usage: bright N(default)
        N   0-15
HELP
    return -1
  fi
  if [ "$1" = "default" ];then
  	echo 13 > /sys/class/backlight/acpi_video0/brightness
  else
    echo "$1" > /sys/class/backlight/acpi_video0/brightness
  fi
}
