clean_journal() {
    log "Journal cleanup"

    local time="${1:-2weeks}"

    echo "Journal cleanup: removing logs older than $time"
    echo "This is destructive! Backup logs if needed."

    if confirm "Proceed with cleaning journal logs older than $time?"; then
        echo "Cleaning journal logs..."
        journalctl --vacuum-time="$time"
        echo "Journal cleanup complete."
    else
        echo "Journal cleanup skipped."
    fi
}
