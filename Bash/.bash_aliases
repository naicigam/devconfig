
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

alias dxcreate='sfdx force:project:create --template empty --projectname'

alias dxlogin='sfdx force:auth:device:login'
alias dxloginsbx='sfdx force:auth:device:login -r https://test.salesforce.com'
alias dxtest='sfdx force:apex:test:run --synchronous'
alias dxlastlog='sfdx force:apex:log:get --number 1 --color | grep --line-buffered "USER_DEBUG"'

dxswitch() {
  sfdx force:config:set defaultusername="$1"
}

#-------------------------------------------------------------
# Cumulus CI

alias ccistart='conda_start && conda activate cumulusci'
alias ccidev='cci flow run dev_org --org dev && dxswich SFC-Package__dev'
alias cciinfo='cci org info --json'
alias ccibeta='cci flow run ci_beta'

#-------------------------------------------------------------
# AWS

login_aws () {
  export AWS_PROFILE=
  unset AWS_PROFILE
  # check if an argument is given, if so assume it's a otp and skip asking 1pass
  if [ -z "$1" ]; then
    mfa_code="$(op item get --account CPJBZ244VNGFXACBSBQIC6VUI4 4vi75vaccsleyemkczkepdmje4 --field type=otp --format json | jq -r .totp)"
  else
    mfa_code="$1"
  fi

  session=$(aws sts get-session-token --serial-number 'arn:aws:iam::573927883898:mfa/juan@chapterspot.com' --duration-seconds=129600 --token-code="$mfa_code")

  if [ $? -eq 0 ]; then
    export AWS_PROFILE=mfa

    aws configure set aws_access_key_id "$(echo $session | jq -r '.Credentials.AccessKeyId')"
    aws configure set aws_secret_access_key "$(echo $session | jq -r '.Credentials'.SecretAccessKey)"
    aws configure set aws_session_token "$(echo $session | jq -r '.Credentials.SessionToken')"
  else
    echo "FAILED!"
    false
  fi
}