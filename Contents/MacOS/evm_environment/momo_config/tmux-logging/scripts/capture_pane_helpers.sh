# Variables in this helper should be set in the file sourcing the helper.
# Required variables:
# - path_option & default_path
# - name_option & default_name

# momo添加创建文件夹的函数
function createDirNoDel()
{
    # 输出文件夹
    if [ ! -d "${1}" ]; then
        # 没有的话创建一个
        mkdir -p "${1}"
    fi
}



momo_get_path() {
    # 在用户目录底下创建一个临时的 log 文件夹
    # 获取用户的目录
    user_path=$(eval echo ~$USER)
    log_path="${user_path}"/".momolog"

    log_path_normal="${user_path}"/".momolog/normal"
    createDirNoDel "${log_path_normal}"
    echo "${log_path_normal}"
}

get_path() {
	get_tmux_option "$path_option" "$default_path"
}

# `tmux save-buffer` command does not perform interpolation, so we're doing it
# "manually" with `display-message`
get_filename() {
	local name_template=$(get_tmux_option "$name_option" "$default_name")
	tmux display-message -p "$name_template"
}

capture_pane() {
	local file="$(momo_get_path)/$(get_filename)"
	local capture_scope=$1
	if [ $capture_scope == "History" ]; then
		local history_limit="$(tmux display-message -p -F "#{history_limit}")"
		tmux capture-pane -J -S "-${history_limit}" -p > "$file"
	elif [[ $capture_scope == "Screen capture" ]]; then
		tmux capture-pane -J -p > "$file"
	else
		# error
		exit 1
	fi
	remove_empty_lines_from_end_of_file "$file"
	display_message "$capture_scope saved to $file"
}


# momo添加创建文件夹的函数
function createDir()
{
    # 输出文件夹
    if [ ! -d "${1}" ]; then
        # 没有的话创建一个
        mkdir -p "${1}"
    else
        # 有的话直接去掉, 再创建一下那个文件夹
        rm -rf "${1}"
        mkdir -p "${1}"
    fi
}


momo_capture_pane() {
    # 在用户目录底下创建一个临时的 log 文件夹
    # 获取用户的目录
    user_path=$(eval echo ~$USER)
    log_path="${user_path}"/".momolog"
    log_path_tmp="${user_path}"/".momolog/__tmp"
    # 创建 log 文件夹
    createDir "${log_path_tmp}"
    # log 文件路径
    momo_log_path="${log_path_tmp}"/"momolog"

	local file="${momo_log_path}"
	local capture_scope=$1
	if [ $capture_scope == "History" ]; then
		local history_limit="$(tmux display-message -p -F "#{history_limit}")"
		tmux capture-pane -J -S "-${history_limit}" -p > "$file"
	elif [[ $capture_scope == "Screen capture" ]]; then
		tmux capture-pane -J -p > "$file"
	else
		# error
		exit 1
	fi
	remove_empty_lines_from_end_of_file "$file"
	display_message "$capture_scope saved to $file"


    # Sublime 所在的路径
    # subl="/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
    # if [ -f "${file}" ]; then
    #     # 假如文件存在的话, 我们就打开它
    #     open "${file}"
    # fi

    
    cmd_path="${log_path_tmp}"/"open_log.sh"
    cmd0="#!/bin/sh"
    # cmd1="alias s=""\"""open -a  /Applications/Sublime""\ ""Text.app/Contents/MacOS/Sublime""\ ""Text  "\$""@"""\""
    cmd1="alias s=""\"""open -a  /Applications/Sublime""\ ""Text.app/Contents/MacOS/Sublime""\ ""Text  "\$""@"""\""
    cmd2="file=""\"""${file}""\""
    # cmd3="s ""\"\${""file""}\""
    cmd3="s ""\"\${""file""}\""

    echo "${cmd0}" > "${cmd_path}"
    echo "" >> "${cmd_path}"
    echo "${cmd1}" >> "${cmd_path}"
    echo "${cmd2}" >> "${cmd_path}"
    echo "${cmd3}" >> "${cmd_path}"


    if [ -f "${file}" ]; then
        # 假如文件存在的话, 我们就打开它
        # 似乎无法再这里直接执行, 所以我们就写到拎一个脚本里面执行
        sh "${cmd_path}"
        # cat "${cmd_path}"
    fi

}
