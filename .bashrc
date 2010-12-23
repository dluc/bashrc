# ~/.bashrc: executed by bash(1) for non-login shells.
#
# Devis Lucato 
# http://lucato.it
#

echo 'Root Access on:' `date` `who` | mail -s "ALERT! Root Access from `who | awk '{print $5}'`" me@domain.tld

# skip setup if not an interactive shell
if [ -z "$PS1" ]; then
	return
fi

source $HOME/.bashrc.functions
source $HOME/.bashrc.history
source $HOME/.bashrc.aliases

# == prompt without git info ==
#export PS1="\n\e[32;44;1m \h\e[37m - [\u] \e[0m\e[30;47m  (\t)  \e[0m\n\w :# "
# == prompt with git branch name ==
export PS1="\n\e[32;44;1m \h\e[37m - [\u] \e[\033[0;31m\$(parse_git_branch)\e[0m\e[30;47m  (\t)  \e[0m\n\w :# "

case $TERM in
	xterm*|screen)
		color_prompt=yes
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
		#PROMPT_COMMAND='tabname="\033]0;${HOSTNAME}\007";echo -ne "$tabname"'
		;;
	*)
		;;
esac

# == disable terminal beep ==
setterm -blength 0

# == if necessary update LINES & COLUMNS after each command ==
shopt -s checkwinsize

umask 027

PATH="$HOME/bin:$PATH"

export TERM
