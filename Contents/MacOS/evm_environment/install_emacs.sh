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

log "brew tap railwaycat/emacsmacport"
brew tap railwaycat/emacsmacport
log "brew install emacs-mac"
brew install emacs-mac
log "brew untap railwaycat/emacsmacport"
brew untap railwaycat/emacsmacport
