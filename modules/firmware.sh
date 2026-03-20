update_firmware() {
    log "Firmware update check"

    echo "Checking firmware devices..."
    fwupdmgr get-devices

    echo -e "\nRefreshing firmware metadata..."
    warn_fail fwupdmgr refresh

    echo -e "\nChecking available firmware updates..."
    updates=$(fwupdmgr get-updates 2>/dev/null)
    if [[ -z "$updates" ]]; then
        echo "No firmware updates available."
        return
    fi
    echo "$updates"

    # Optional apply with confirmation
    if confirm "Firmware updates are available. Proceed with applying them? WARNING: may reboot or brick device"; then
        warn_fail sudo fwupdmgr update
        echo "Firmware update process finished. Check logs for details."
    else
        echo "Firmware update skipped."
    fi
}
