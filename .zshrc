plugins=(
  git zsh-autosuggestions zsh-syntax-highlighting auto-jump
)

export GO111MODULE=on
export GOPROXY=https://goproxy.io
export GOPATH="$HOME/go"

function rem {
  for b in "$@"
  do
    osascript -e "tell app \"Finder\" to delete POSIX file \"${PWD}/$b\""
  done
}
alias rm="rem"

function wc2() {
 find . -path ./src/$(basename $(pwd))/vendor -prune -o  -name "*.go" -print | xargs wc -l
}
function wc3() {
fd -E vendor .go |xargs wc -l
}

alias grep-dir="find .|xargs grep -ri"
alias grep-dir2="fd -E vendor -E node_modules .|xargs grep -ri"
alias emulator1="emulator -avd $1 -dns-server $(cat /etc/resolv.conf | awk  '/^nameserver/ {print $2}')"
alias go-proxy='http_proxy=127.0.0.1:1080 https_proxy=127.0.0.1:1080 go'
alias go2='export GO111MODULE=on && go'
alias man2='tldr'
alias redis-local="redis-cli -a toor"
alias mycli-local="mycli -u root -p toor"
alias ftp-server='python -m SimpleHTTPServer $((8000+$RANDOM))'
