# ~/.bashrc: executed by bash(1) for non-login shells.
#
# Devis Lucato 
# http://lucato.it
#

echo 'Root Access on:' `date` `who` | mail -s "ALERT! Root Access from `who | awk '{print $5}'`" me@domain.tld

function my_ip() {
	MY_IP=$(/sbin/ifconfig eth0 | awk "/inet/ { print $2 } " | sed -e s/addr://)
	MY_ISP=$(/sbin/ifconfig eth0 | awk "/P-t-P/ { print $3 } " | sed -e s/P-t-P://)
}

function ii() {
	echo -e "\nYou are logged on ${RED}$HOST"
	echo -e "\nAdditionnal information:$NC " ; uname -a
	echo -e "\n${RED}Users logged on:$NC " ; w -h
	echo -e "\n${RED}Current date :$NC " ; date
	echo -e "\n${RED}Machine stats :$NC " ; uptime
	echo -e "\n${RED}Memory stats :$NC " ; free
	my_ip 2>&- ;
	echo -e "\n${RED}Local IP Address :$NC" ; echo ${MY_IP:-"Not connected"}
	echo -e "\n${RED}ISP Address :$NC" ; echo ${MY_ISP:-"Not connected"}
	echo
}

function my_ps() {
	ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ;
}

function pp() {
	my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ;
}

function parse_git_branch {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
}

function sshcopyid {
	KEY="$HOME/.ssh/id_dsa.pub"

	if [ ! -f $KEY ];then
		echo "private key not found at $KEY"
		echo '* please create it with "ssh-keygen -t dsa"'
		echo "* to login to the remote host without a password, don't give the key you create with ssh-keygen a password"
		return
	fi

	if [ -z $1 ];then
		echo "Please specify user@host.tld as the first switch to this script"
		return
	fi

	echo "Putting your public key on $1... "

	cat $KEY | ssh -q $1 "mkdir ~/.ssh 2>/dev/null; chmod 700 ~/.ssh; cat - >> ~/.ssh/authorized_keys; chmod 644 ~/.ssh/authorized_keys"

	echo "done!"
}

if [ "$TERM" != "dumb" ]; then

	# == prompt without git info ==
	#export PS1="\n\e[32;44;1m \h\e[37m - [\u] \e[0m\e[30;47m  (\t)  \e[0m\n\w :# "
	
	# == prompt with git branch name ==
	export PS1="\n\e[32;44;1m \h\e[37m - [\u] \e[\033[0;31m\$(parse_git_branch)\e[0m\e[30;47m  (\t)  \e[0m\n\w :# "
	
	export LS_OPTIONS='--color=auto'

	export HISTCONTROL=ignorespace
	#export HISTCONTROL=ignoredups
	export HISTTIMEFORMAT='%F %T '
	export HISTSIZE=32767
	export HISTFILESIZE=3276700
	# == append to the history file, don't overwrite it ==
	shopt -s histappend

	case $TERM in
		xterm*|screen)
			color_prompt=yes
			PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
			#PROMPT_COMMAND='tabname="\033]0;${HOSTNAME}\007";echo -ne "$tabname"'
			;;
		*)
			;;
	esac

	if [ -x /usr/bin/dircolors ]; then
		eval "`dircolors -b`"
	fi
	# == disable terminal annoying beep ==
	setterm -blength 0
	# == if necessary update LINES & COLUMNS after each command ==
	shopt -s checkwinsize

	alias ls='ls $LS_OPTIONS'
	alias rm='rm -i'
	alias cp='cp -ai'
	alias mv='mv -i'
	alias grep='grep --color=auto'
	alias df='df -h'
	alias l='ls -lAF'
	alias ll='l|less'
	#alias less='less -nS'
	alias screen='/usr/bin/screen -a -h 10000 -R'
	alias ded='mcedit -d -C editnormal=lightgray,black'
	alias ded2='diakonos'
	alias aee='aee -j'
	## requires ~/.gcalclirc
	alias agenda='gcalcli --cals all calw 2|less -r'
fi

umask 027

PATH="$HOME/bin:$PATH"

export TERM
