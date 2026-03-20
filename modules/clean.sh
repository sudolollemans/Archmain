# CLEAN CACHE

clean_cache() {
    log "Clean cache"

    echo "Package cache cleaning"
    echo "1) Safe clean (keep recent packages)"
    echo "2) Full clean (remove ALL cached packages)"
    echo

    read -rp "Choose an option [1/2]: " choice

    case "$choice" in

        1)
            echo "Running safe cache clean..."
            if confirm "Proceed with pacman -Sc?"; then
                warn_fail sudo pacman -Sc
            else
                echo "Aborted."
            fi
            ;;

        2)
            echo "WARNING: This will remove ALL cached packages."
            echo "You will not be able to downgrade easily."
            if confirm "Proceed with FULL cache clean?"; then
                warn_fail sudo pacman -Scc
            else
                echo "Aborted."
            fi
            ;;
        *)
            echo "Invalid option."
            ;;

    esac

    if command -v yay >/dev/null; then
        if confirm "Clean yay cache as well? (uses yay -Scc)"; then
            yay -Scc
        fi
    fi
}
