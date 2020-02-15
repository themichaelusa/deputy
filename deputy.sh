#!/bin/bash

# DEPUTY HELPER FUNCS
#function get_vm_uname () {;}

# DEPUTY CLI FUNCS

# deputy register <vm_name> <uname> <proj_name>
function deputy_register () {
	cd /usr/local/share/deputy_cli

	mkdir $1
	touch md.txt

	vm_name_str='vm_name='
	vm_name_str+=$1
	uname_str='uname='
	uname_str+=$2

	vm_name_str >> md.txt
	uname_str >> md.txt
	mkdir $3

	# modify VM to work with ssh + 
	VBoxManage modifyvm $1 --natpf1 "ssh,tcp,,3022,,22"
	echo -e "\033[1;93m[PROMPT] ENTER $1 VM PASSWORD: \033[0m"
	ssh-copy-id -p 3022 $2@127.0.0.1
	echo -e "\033[1;93m[READY] DEPUTY TUNNEL UTIL FOR: $1\033[0m"
}

function deputy_connect () {
	echo -e "\033[1;93m[INIT] DEPUTY TUNNEL TO: $1\033[0m"
	VBoxManage startvm $1 --type headless
	sleep 2
	echo -e "\033[1;32m[READY] DEPUTY TUNNEL TO: $1 \033[0m"
}

function deputy_run () {
	cdir=${PWD##*/}
	echo "TEST CDIR: $cdir"
	dep_root="/home/mikeusa/Desktop/deputy"
	scp -P 3022 -r $PWD mikeusa@127.0.0.1:$dep_root
	ssh -p 3022 mikeusa@127.0.0.1 cd $dep_root && cd $cdir; $@
}

function deputy_exit () {	
	echo -e "\033[1;93m[INIT] KILL DEPUTY TUNNEL: $1\033[0m"
	VBoxManage controlvm $1 poweroff soft
	echo -e "\033[1;31m[KILLED] DEPUTY TUNNEL: $1\033[0m"
}

#echo "COMMAND: $1"
# deputy main logic 
CMD=$1
shift

if [ $CMD == "register" ]; then
	deputy_register $1 $2 $3 
elif [ $CMD == "connect" ]; then
	deputy_connect $1
elif [ $CMD == "exit" ]; then
	deputy_exit $1
elif [ $CMD == "run" ]; then
	deputy_run $@
fi


