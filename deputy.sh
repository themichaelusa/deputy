#!/bin/bash

# DEPUTY HELPER FUNCS
#function get_vm_uname () {;}

# DEPUTY CLI FUNCS

# deputy addvm <vm_name>
function deputy_addvm () {
	vm_str='"'
	vm_str+=$1
	vm_str+='"'
	VBoxManage modifyvm vm_str --natpf1 "ssh,tcp,,3022,,22" 
}

# deputy register <vm_name> <uname> <proj_name>
function deputy_register () {
	cd /usr/local/share/deputy_cli

	mkdir $1
	touch md.txt

	vm_name_str='vm_name='
	vm_name_str+=$1
	uname_str='uname='
	uname_str+=$2
	#proj_name_str='proj_name='
	#proj_name_str+=$3

	vm_name_str >> md.txt
	uname_str >> md.txt

	#$hashed >> $1
	#$hashed >> $2
	#$hashed >> $3
	mkdir $3

	deputy_addvm $1
}

function deputy_connect () {
	vm_str='"'
	vm_str+=$1
	vm_str+='"'
	VBoxManage startvm $(vm_str) --type headless
	echo -e "\033[1mConnecting to $1...\033[0m"
	sleep 2
	ssh -p 3022 mikeusa@127.0.0.1
	export deputy_vm_context=vm_str
}

#function deputy_exit () {;}

# deputy main logic 
if [ $1=="addvm" ]; then
	deputy_addvm $2
elif [ $1=="register" ]; then
	deputy_login $2 $3 $4 
elif [ $1=="connect" ]; then
	deputy_connect $1
fi


