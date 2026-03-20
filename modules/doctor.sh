system_check() {
    log "System health check"

    mkdir -p "$(dirname "$HEALTHFILE")"
    : > "$HEALTHFILE"

    echo "Starting system check..."

    log_section() {
        echo
        echo -e "\n===== $1 =====" | tee -a "$HEALTHFILE"
        echo
    }

    # Disk space
    log_section "DISK SPACE"
    df -h | tee -a "$HEALTHFILE"

    # Failed services
    log_section "FAILED SERVICES"
    systemctl --failed | tee -a "$HEALTHFILE"

    # Orphaned packages (pacman)
    log_section "ORPHANED PACMAN PACKAGES"
    orphans=$(pacman -Qtdq 2>/dev/null || true)
    [[ -z "$orphans" ]] && echo "None" || echo "$orphans" | tee -a "$HEALTHFILE"

    # Orphaned AUR packages
    log_section "ORPHANED AUR PACKAGES"
    if command -v yay >/dev/null; then
        yay -Qtdq 2>/dev/null | tee -a "$HEALTHFILE" || true
    else
        echo "No supported AUR helper found" | tee -a "$HEALTHFILE"
    fi

    # Journal errors
    log_section "JOURNAL ERRORS (last 50)"
    journalctl -p 3 -xb -n 50 | tee -a "$HEALTHFILE"

    # Updates
    log_section "AVAILABLE PACMAN UPDATES"
    pacman -Qu | tee -a "$HEALTHFILE" || true

    log_section "AVAILABLE AUR UPDATES"
    if command -v yay >/dev/null; then
        yay -Qu | tee -a "$HEALTHFILE" || true
    else
        echo "No supported AUR helper found" | tee -a "$HEALTHFILE"
    fi

    # Firmware
    log_section "FIRMWARE UPDATES"
    warn_fail fwupdmgr get-devices | tee -a "$HEALTHFILE"
    warn_fail fwupdmgr get-updates | tee -a "$HEALTHFILE"

    echo "Check complete! Report saved to: $HEALTHFILE"
}
