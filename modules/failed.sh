log_inspect() {
    log "Inspecting failed services and errors"

    echo "===== JOURNAL ERRORS (last 50) ====="
    journalctl -p 3 -xb -n 50

    echo -e "\n===== FAILED SERVICES ====="
    systemctl --failed

    echo -e "\n===== KERNEL ERRORS (dmesg) ====="
    if [[ $EUID -ne 0 ]]; then
        echo "Warning: Root privileges needed for full dmesg output"
        dmesg --level=err
    else
        dmesg --level=err
    fi

    echo "Check complete!"
}
