
#-------------------------------------------------------------
# Handy bash stuff

cdd() {
    cd $1
    ls -la
}

# Browser
alias chrome='/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe'

stackoverflow() {
    chrome --args "https://www.google.com/search?q=site:stackoverflow.com $*"
}

#-------------------------------------------------------------
# Git Aliases (based on https://kurtdowswell.com/software-development/git-bash-aliases/)

alias g='git'

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
    . /usr/share/bash-completion/completions/git
fi

function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}

for al in `__git_aliases`; do
    alias g$al="git $al"

    complete_func=_git_$(__git_aliased_command $al)
    function_exists $complete_fnc && __git_complete g$al $complete_func
done

#-------------------------------------------------------------
# Conda

# !! Contents within this block are managed by 'conda init' !!
conda_start() {

    __conda_setup="$('/home/naicigam/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"

    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/home/naicigam/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/home/naicigam/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/home/naicigam/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
}

conda_env() {
    conda env list | grep \* | cut -d ' ' -f 1
}

#-------------------------------------------------------------
# Salesforce DX

dx_start() {
    sfdx autocomplete:script bash

    export BROWSER="/c/Sync/Coding/.files/Bash/chrome-launcher"

    # Workaround for limited WSL2 support:
    # https://github.com/forcedotcom/cli/issues/597#issuecomment-698380702
    export PATH=$PATH:/c/WINDOWS/System32/WindowsPowerShell/v1.0/
}

alias dxpush='sfdx force:source:push'
alias dxpull='sfdx force:source:pull'

alias dxretrieve='sfdx force:source:retrieve'
alias dxdeploy='sfdx force:source:deploy'

alias dxopen='sfdx force:org:open'
alias dxlist='sfdx force:org:list'

alias dxlogin=' sfdx force:auth:device:login'
alias dxtest='sfdx force:apex:test:run --synchronous'
alias dxlastlog='sfdx force:apex:log:get --number 1 --color | grep --line-buffered "USER_DEBUG"'

dxswitch() {
  sfdx force:config:set defaultusername="$1"
}

#-------------------------------------------------------------
