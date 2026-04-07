backup_files() {
    echo "Backing up files and services..."
    log "Backup files"

    mkdir -p "$REC"

    echo "Saving package and service lists..."
    warn_fail pacman -Qqe > "$REC/pkglist.txt"
    warn_fail pacman -Qqm > "$REC/aurlist.txt"
    warn_fail systemctl list-unit-files --type=service --no-legend > "$REC/services-state.txt"

    if ! mountpoint -q "$DEST"; then
        echo "Error: $DEST is not a mounted filesystem."
        return 1
    fi

    if [[ ! -w "$DEST" ]]; then
        echo "Error: No write permission on $DEST"
        return 1
    fi

    echo "Preview: Home backup (dry run)"
    rsync -aAXHv --delete --dry-run \
        --exclude=".cache/" \
        --exclude="Downloads/" \
        --exclude=".local/" \
        --exclude=".steam/" \
        "$USER_HOME/" "$DEST/home/"

    echo
    echo "Backing up home of: $SUDO_USER ($USER_HOME)"
    echo "WARNING: This will overwrite files in $DEST/home/"
    if ! confirm "Proceed with home backup?"; then
        echo "Backup cancelled."
        return
    fi

    rsync -aAXHv --delete \
        --exclude=".cache/" \
        --exclude="Downloads/" \
        --exclude=".local/" \
        --exclude=".steam/" \
        "$USER_HOME/" "$DEST/home/"

}
