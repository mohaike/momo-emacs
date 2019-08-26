#!/bin/sh

CURRENT_PATH="$(cd $(dirname ${BASH_SOURCE:-$0});pwd)"
target_path="${HOME}/Desktop"

archive_name="emacs-26.2"
archive_path="${target_path}/${archive_name}"
archive_emacs="${archive_path}/emacs.app"
archive_readme="${archive_path}/README.txt"
archive_path_zip="${archive_path}.zip"

emacs_path="${CURRENT_PATH}/../.."

log()
{
    log="${1}"

    log_tag="MOMO"
    echo
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] "${log_tag}" ${log}"
    echo
}

new_dir()
{
    d="${1}"
    if [[ -d "${d}" ]]
    then
        rm -rf "${d}"
    fi
    mkdir -p "${d}"
}

clean_path()
{
    log "clean ${target_path}"
    new_dir "${archive_path}"
    if [[ -f "${archive_path_zip}" ]] || [[ -d "${archive_path_zip}" ]]
    then
        rm -rf "${archive_path_zip}"
    fi
}

# 清理路径
clean_path

cp -R "${emacs_path}" "${archive_emacs}"

cat << MOMO > "${archive_readme}"
将这里面的emacs移动到安装路径比如说 /Applications
之后执行 emacs.app/Contents/MacOS/install_cmd.sh
就可以完成命令行emacs的安装
MOMO
# add bom不至于乱码
sed -i '1s/^/\xef\xbb\xbf/' "${archive_readme}"

cd "${target_path}"
zip -r "${archive_name}.zip" "${archive_name}"
rm -rf "${archive_name}"

log "ALL DONE!!!"


scp ~/Desktop/emacs-26.2.zip \
    eric@172.16.100.99:/Volumes/M/Users/eric/build/tool/mac/emacs
