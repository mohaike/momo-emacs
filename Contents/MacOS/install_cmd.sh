#!/bin/sh
CURRENT_PATH="$(cd $(dirname ${BASH_SOURCE:-$0});pwd)"
go="${CURRENT_PATH}/go"
local_config="${CURRENT_PATH}/.emacs.d.zip"

log()
{
    log="${1}"

    log_tag="MOMO"
    echo
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] "${log_tag}" ${log}"
    echo
}


cat <<  MOMO > "${go}"
#!/bin/sh

# 拼接所有的参数做变量
all=""
for var in "\$@"
do
    # echo "\$var"
    if [[ "\${all}" = "" ]]
    then
        all="\"\${var}\""
    else
        all="\${all} \"\${var}\""
    fi
done

# echo "\${all}"
alias go="${CURRENT_PATH}/Emacs \${all} -nw"
go
MOMO

chmod 777 "${go}"

local_cellar="/usr/local/Cellar"
local_bin="/usr/local/bin"
local_bin_emacs="${local_bin}/emacs"

log "rm old emacs"
mkdir -p "${local_bin}"
rm -rf "${local_bin_emacs}"

log "link new emacs"
ln -s "${go}" "${local_bin_emacs}"


log "cp emacs config"

t="$(date '+%Y-%m-%d_%H:%M:%S')"
old_config="${HOME}/.emacs.d.${t}"
config="${HOME}/.emacs.d"

if [[ -d "${config}" ]]
then
    mv "${config}" "${old_config}"
fi

unzip "${local_config}" -d "${HOME}"


install_ag()
{
    
    sh "${CURRENT_PATH}/evm_environment/install_ag.sh"
}
install_ag



log "all done"
