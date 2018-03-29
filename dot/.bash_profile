source ~/.private_vars
source ~/.git-completion.bash

# Env vars
export HISTCONTROL=ignoredups # When going through command history, ignore the same command run multiple times in a row

## Misc
export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export PYTHONPATH=/usr/local/lib/python3.6/site-packages
export NVM_DIR=~/.nvm
export EDITOR=vim

## Path mods
export PATH="/usr/local/mysql/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$PATH:/usr/local/jmeter/bin"
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export PATH=$PATH:$HOME/golang/bin
export PATH=$PATH:$PYTHONPATH
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting 
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/repos/multitasking/bin"

# Powerline
. $PYTHONPATH/powerline/bindings/bash/powerline.sh
export XDG_CONFIG_HOME=~/.config

# Aliases
alias mci="mvn clean install"
alias vi="vim"
alias bim="vim"
alias nv="nvim"

# Git aliases
alias gcm="git commit"
__git_complete gcm _git_commit
alias gad="git add"
__git_complete gad _git_add
alias gpu="git push"
__git_complete gpu _git_push
alias gpl="git pull"
__git_complete gpl _git_pull
alias gco="git checkout"
__git_complete gco _git_checkout
alias gst="git status"
__git_complete gst _git_status
alias gbr="git branch"
__git_complete gbr _git_branch
alias grm="git rm"
__git_complete grm _git_rm
alias grb="git rebase"
__git_complete grb _git_rebase
alias glg="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
__git_complete glg _git_log
alias grs="git reset"
__git_complete glg _git_log
alias gmr="git merge"
__git_complete gmr _git_merge
alias gdf="git diff"
__git_complete gdf _git_diff
alias gcp="git cherry-pick"
__git_complete gcp _git_cherry-pick
alias gcl="git clean"
__git_complete gcl _git-clean


function git_get_current_branch {
	CURR_BRANCH=$(git symbolic-ref --short HEAD)
}

function gplom {
	git_get_current_branch
	git checkout master
	git pull origin master
	git checkout $CURR_BRANCH
}

function gpucb {
	if [ -z $1 ]
	then
		if [ "" == `git remote | grep dmadeira` ] 
		then
			REMOTE="origin"
		else
			REMOTE="dmadeira"
		fi
	else 
		REMOTE=$1
	fi
	git_get_current_branch
	git push $REMOTE $CURR_BRANCH
}

# Thanks Thomas Marshall!
function gmpr {
	  repo=`git remote -v | grep -m 1 "(push)" | sed -e "s/.*github.medallia.com[:/]\(.*\)\.git.*/\1/"`
	  branch=`git name-rev --name-only HEAD`
	  echo "... creating pull request for branch \"$branch\" in \"$repo\""
	  open https://github.medallia.com/$repo/pull/new/$branch
}

function gfpr {
	git checkout master
	git fetch origin pull/$1/head:$2
	git checkout $2
}

# Bulk delete git branches
# Pass branches you want to KEEP as arguments, script deletes the rest
# Will ask you for confirmation before deleting
function gdbr {
	local ALWAYS_IGNORE="master *"
	local DELETE_BRANCHES=$(git branch | awk -v IGNORE_WORDS="$ALWAYS_IGNORE $*" '
	BEGIN { split(IGNORE_WORDS, IGNORE, " ") }
	{ FOUND=0; for(I in IGNORE) { if($1 == IGNORE[I]) { FOUND=1; break } } if(FOUND==0) print $1; }
	')
	if [[ -z "$DELETE_BRANCHES" ]]
	then
		echo "No branches to delete"
		return
	fi
	read -p "Are you sure you want to delete these branches? (y/n) 
	$DELETE_BRANCHES" -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		git branch -D $DELETE_BRANCHES
	fi
}

# Job control aliases
alias kterm="kill -s SIGTERM"
alias kquit="kill -s SIGQUIT"

function mkcd {
	mkdir -p $1
	cd $1
}

function ptouch {
	mkdir -p `dirname $1`
	touch $1
}

# Fix output issues
function st {
	stty sane
}

function cdrr {
	cd ~/repos/reporting
}

# TMUX configurations
function tx_prj {
	PROJECT_NAME=$(basename $1)
	SESSION_NAME=$USER
	tmux new-session -c $1 -s $SESSION_NAME  -n $PROJECT_NAME vim
	tmux split-window -t $SESSION_NAME -v -p 40
	tmux attach-session -t $SESSION_NAME
}

function ctags_extra {
	# ctags doesn't handle negative look behinds so instead this script
	# strips false positives out of a tags file.

	ctags -R --fields=+lS "$@"

	FILE="tags"

	while [[ $# > 1 ]]
	do
		key="$1"

		case $key in
			-f)
				FILE="$2"
				shift
				;;
		esac
		shift
	done

	# Filter out false matches from class method regex
	sed -i '' -E '/^(if|switch|function|module\.exports|it|describe)	.+language:js$/d' $FILE

	# Filter out false matches from object definition regex
	sed -i '' -E '/var[ 	]+[a-zA-Z0-9_$]+[ 	]+=[ 	]+require\(.+language:js$/d' $FILE
}

# FZF options
set rtp+=/usr/local/opt/fzf
export FZF_DEFAULT_COMMAND='ag --hidden -g ""'

source $(brew --prefix nvm)/nvm.sh
source <(npm completion)
[[ -r ~/.bashrc ]] && . ~/.bashrc

# Medallia stuff
alias d1qa="d1 --baseUrl ec2-54-241-34-79.us-west-1.compute.amazonaws.com:8080"
