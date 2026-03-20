orphaned_pkg() {
    log "Orphaned packages check"

    USER_HOME="$(eval echo ~$SUDO_USER)"
    local output_file="${REC:-$USER_HOME}/orphaned_packages.txt"
    mkdir -p "$(dirname "$output_file")"

    echo "Listing orphaned pacman packages..."
    pacman_orphans=$(pacman -Qtdq 2>/dev/null || true)

    if [[ -z "$pacman_orphans" ]]; then
        echo "No orphaned pacman packages found."
    else
        echo "$pacman_orphans" > "$output_file"
        echo "Orphaned pacman packages saved to $output_file"
        if confirm "Do you want to remove these orphaned pacman packages?"; then
            pacman -Rns --noconfirm $pacman_orphans
        else
            echo "Pacman orphan removal skipped."
        fi
    fi

    # Optional AUR helper cleanup
    if command -v yay >/dev/null; then
        echo "Checking AUR orphans..."
        yay_orphans=$(yay -Qtdq 2>/dev/null || true)
        if [[ -z "$yay_orphans" ]]; then
            echo "No AUR orphaned packages found."
        else
            echo "$yay_orphans" >> "$output_file"
            if confirm "Do you want to remove these orphaned AUR packages?"; then
                yay -Yc
            else
                echo "AUR orphan removal skipped."
            fi
        fi
    else
        echo "No supported AUR helper found, skipping AUR orphan cleanup."
    fi
}
