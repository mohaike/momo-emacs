#!/bin/sh

CURRENT_PATH="$(cd $(dirname ${BASH_SOURCE:-$0});pwd)"

# 函数库
# source  "${CURRENT_PATH}/../.tool/public_fun.sh"

# 传入工具的名称，如果没有就安装一个

########################################
# 密码检测
########################################
evm_password="${1}"             # 密码
alias evm_sudo="echo \"${evm_password}\" | sudo -S "

# 工具类型三种
# brew
# gem
# pip
tool_type="${2}"
alias momo_tool_check="check_tool_${tool_type}" # 

tool_name="${3}"              # 工具名称


evm_log()
{
    log="${1}"

    echo
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] EVM_LOG ${log}"
    echo
}


########################################
# 使用brew安装的工具
########################################
check_tool_brew()
{
    which brew > /dev/null      # 不输出
    # 安装brew使用国内的源
    if [[ $? != 0 ]]
    then
        evm_log "brew install"
        brew_install="${CURRENT_PATH}/momo_config/brew_install"
        /usr/bin/ruby -e "$(cat ${brew_install})"
    fi

    evm_log "${tool_name} check"

    tool_name="${1}"
    install_arg="${2}"

    brew list | grep -i "${tool_name}" > /dev/null # 不输出

    # 没有安装就安装它
    if [[ $? != 0 ]]
    then
        evm_log "install ${tool_name}"
        if [[ "${install_arg}" != "" ]]
        then
            brew install "${tool_name}" "${install_arg}"
        else
            brew install "${tool_name}"
        fi
    fi
}

########################################
# 使用gem安装的工具
########################################
export PATH=/usr/local/bin:$PATH
# gem的工具的安装
check_tool_gem()
{
    tool_name="${1}"
    evm_log "${tool_name} check"

    gem list | grep -i "${tool_name}" > /dev/null      # 不输出
    if [[ $? != 0 ]]
    then
        evm_log "${tool_name} install"
        evm_sudo gem install -n /usr/local/bin "${tool_name}"
   fi
}


########################################
# 使用pip安装的工具
########################################
check_tool_pip()
{
    which pip > /dev/null      # 不输出
    # 安装pip
    if [[ $? != 0 ]]
    then
        evm_log "pip install"
        evm_sudo /usr/bin/easy_install pip
    fi

    tool_name="${1}"
    evm_log "${tool_name} check"

    pip list | grep -i "${tool_name}" > /dev/null      # 不输出
    if [[ $? != 0 ]]
    then
        evm_log "${tool_name} install"
        evm_sudo pip install "${tool_name}"
   fi
}


# 开始检测，没有就安装一个
momo_tool_check "${tool_name}"
