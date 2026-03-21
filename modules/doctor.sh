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

    # Journal errors
    log_section "JOURNAL ERRORS (last 50)"
    journalctl -p 3 -xb -n 50 | tee -a "$HEALTHFILE"

    # Updates
    log_section "AVAILABLE PACMAN UPDATES"
    pacman -Qu | tee -a "$HEALTHFILE" || true

    log_section "AVAILABLE AUR UPDATES"
    case "$AUR_HELPER" in
        yay|paru|pikaur|trizen|aurman)
            cmd=("$AUR_HELPER" -Qu)
            ;;
        pamac)
            cmd=(pamac checkupdates)
            ;;
        None)
            echo "No AUR helper configured."
            return
            ;;
        *)
            echo "Unknown AUR helper."
            return
            ;;
    esac

    warn_fail --user "${cmd[@]}" 2>&1 | tee -a "$HEALTHFILE" || true

    # Firmware
    log_section "FIRMWARE UPDATES"
    warn_fail fwupdmgr get-devices | tee -a "$HEALTHFILE"
    warn_fail fwupdmgr get-updates | tee -a "$HEALTHFILE"

    echo "Check complete! Report saved to: $HEALTHFILE"
}
