
################################################################################
hexo_local() {
  hexo clean && hexo g && hexo s
}
hexo_remote() {
  hexo clean && hexo g && hexo d && hexo clean
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
  	echo "echo 13 > /sys/class/backlight/acpi_video0/brightness"
  else
    echo "echo $1 > /sys/class/backlight/acpi_video0/brightness"
  fi
}

function rem {
  for b in "$@"
  do
    osascript -e "tell app \"Finder\" to delete POSIX file \"${PWD}/$b\""
  done
}
alias rm="rem"

alias grep-dir="find .|xargs grep -ri"
alias grep-dir2="fd -E vendor -E node_modules .|xargs grep -ri"

function wc2() {
 find . -path ./src/$(basename $(pwd))/vendor -prune -o  -name "*.go" -print | xargs wc -l
}
function wc3() {
fd -E vendor .go |xargs wc -l
}


alias emulator1="emulator -avd $1 -dns-server $(cat /etc/resolv.conf | awk  '/^nameserver/ {print $2}')"

alias go-proxy='http_proxy=127.0.0.1:1080 https_proxy=127.0.0.1:1080 go'
alias man2='tldr'
