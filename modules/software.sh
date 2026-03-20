update_software() {
    log "Software update check"

    echo "System update module initiated."

    # Pacman update
    if confirm "Do you want to update the system packages (pacman)?"; then
        echo "Updating pacman packages..."
        pacman -Syu --noconfirm
    else
        echo "Pacman update skipped."
    fi

    # AUR update
    if command -v yay >/dev/null; then
        if confirm "Do you want to update AUR packages (yay)?"; then
            echo "Updating AUR packages..."
            yay -Syu --noconfirm
        else
            echo "AUR update skipped."
        fi
    else
        echo "No AUR helper found, skipping AUR update."
    fi

    # Config file differences
    if command -v pacdiff >/dev/null; then
        echo "Running pacdiff to review config changes..."
        echo "You will need to manually review and merge changes."
        pacdiff
    else
        echo "pacdiff not installed, skipping config review."
    fi

    echo "Software update complete."
}
