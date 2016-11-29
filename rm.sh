

rm_shell()
{
    local RM_DIR="~/.rm_time_machine"
    local RM_LOG="$RM_DIR/rm_log"
    local RM_HISTORY="$RM_DIR/rm_history"

	if [ "$1" == "rm_init" ];then
	    if [ ! -e $RM_DIR ];then
			mkdir $RM_DIR
			touch $RM_LOG
			touch $RM_HISTORY
	    else
			echo "$RM_DIR already exits"
		exit
	    fi
	fi

	if [ "$1" == "do_rm" ];then
	    rm_time=expr(date +%y%m%d_%H%M%S)
	    mkdir "$RM_DIR/$rm_time"
	    mv -rf $@ "$RM_DIR/$rm_time"

	    echo "\033[33m $rm_time:\033[0m $*" >> $RM_HISTORY

	    echo "\033[33m time: $rm_time \033[0m" >> $RM_LOG
	    for file in $@
	    do
		echo "file: $file" >> $RM_LOG
		echo "orignl: expr(readlink -f $file)" >> $RM_LOG
	    done
	    echo "" >> $RM_LOG
	fi

	if [ "$1" == "rm_log" ];then
	    less $RM_LOG
	fi

	if [ "$1" == "rm_history" ];then
	    less $RM_HISTORY
	fi
}

alias rm_init='rm_shell rm_init'
alias rm='rm_shell do_rm'
alias rm_log='rm_shell rm_log'
alias rm_history='rm_shell rm_history'
