#!/bin/sh

CURRENT_PATH="$(cd $(dirname ${BASH_SOURCE:-$0});pwd)"

# 函数库
source  "${CURRENT_PATH}/../.tool/public_fun.sh"


# 现在的话只要实现每隔5秒检测，看看状态是不是running，是的话就继续接下来的操作
ec2_current_state_running="false"

# 在这里只能是true或者false
until "${ec2_current_state_running}" == "true"
do

    echo -n "请输入密码:"
    read -s password
    # echo -e "\nyou password is:$password"

    evm_password="${password}"             # 机器的密码

    echo "${evm_password}" | sudo -S pwd > /dev/null
    if [[ "$?" == "0" ]]
    then
        ec2_current_state_running="true"
    else
        echo -n "密码输入错误!"
    fi

done

alias evm_sudo="echo \"${evm_password}\" | sudo -S "






########################################
# tmux配置
########################################
origin_tmux="${HOME}/.tmux"
origin_tmux_conf="${HOME}/.tmux.conf"
origin_tmux_conf_local="${HOME}/.tmux.conf.local"

t="$(date '+%Y-%m-%d_%H:%M:%S')"

origin_tmux_old="${HOME}/.tmux.${t}"
origin_tmux_conf_old="${HOME}/.tmux.conf.${t}"
origin_tmux_conf_local_old="${HOME}/.tmux.conf.local.${t}"


tmux_conf="${origin_tmux}/.tmux.conf"
tmux_conf_local="${origin_tmux}/.tmux.conf.local"

if [[ -d "${origin_tmux}" ]]
then
    evm_sudo mv "${origin_tmux}" "${origin_tmux_old}"
fi

# 非连接
if [[ ! -L "${origin_tmux_conf}" ]]
then
    # 是文件
    if [[ -f "${origin_tmux_conf}" ]]
    then
        evm_sudo mv "${origin_tmux_conf}" "${origin_tmux_conf_old}"
    fi
fi


# 非连接
if [[ ! -L "${origin_tmux_conf_local}" ]]
then
    # 是文件
    if [[ -f "${origin_tmux_conf_local}" ]]
    then
        evm_sudo mv "${origin_tmux_conf_local}" "${origin_tmux_conf_local_old}"
    fi
fi

cp -R "${CURRENT_PATH}" "${origin_tmux}"

ln -sfn "${tmux_conf}" "${origin_tmux_conf}"
ln -sfn "${tmux_conf_local}" "${origin_tmux_conf_local}"





########################################
# 环境检测
########################################
momo_check_tool="${CURRENT_PATH}/momo_check_tool.sh"

alias evm_brew="sh ${momo_check_tool} ${evm_password} brew "
alias evm_gem="sh ${momo_check_tool} ${evm_password} gem "
alias evm_pip="sh ${momo_check_tool} ${evm_password} pip "


########################################
# brew
########################################
evm_brew tmux
evm_brew reattach-to-user-namespace
evm_brew wget
evm_brew mutt
evm_brew msmtp
evm_brew mpg123
evm_brew xmlstarlet
evm_brew jq
evm_brew gawk
evm_brew pcre # pcregrep
evm_brew xz # xz for unzip coreutils
evm_brew coreutils # coreutils 
evm_brew gnu-sed --default-names # gsed
evm_brew the_silver_searcher

########################################
# gem
########################################
evm_gem cocoapods
evm_gem fir-cli
evm_gem fastlane

########################################
# pip
########################################

evm_pip matplotlib
evm_pip matplotlib
evm_pip xlrd
evm_pip xlwt

pip install --user pandas
evm_sudo easy_install nose
evm_sudo easy_install tornado

evm_pip awscli
evm_pip boto3




evm_log "ALL DONE!!!"

