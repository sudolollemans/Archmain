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

    echo "Checking for updates with your $AUR_HELPER"

   case "$AUR_HELPER" in

    yay|paru|pikaur|trizen|aurman)
        cmd=("$AUR_HELPER" -Syu)
        ;;

    pamac)
        cmd=(pamac upgrade)
        ;;

    None)
        echo "AUR helper set to None so no AUR helper commands used."
        return
        ;;

    *)
        echo "AUR helper checker made a mistake. Nothing happened."
        return
        ;;

    esac

    if confirm "Proceed with ${cmd[*]}?"; then
        warn_fail --user "${cmd[@]}"
    else
        echo "Aborted."
    fi


    # Config file differences
    if command -v pacdiff >/dev/null; then
        echo "Running pacdiff to review config changes..."
        echo "You will need to manually review and merge changes."
        warn_fail --user pacdiff
    else
        echo "pacdiff not installed, skipping config review."
    fi

    echo "Software update complete."
}
