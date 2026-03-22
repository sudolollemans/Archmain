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
            pacman_cmd=(pacman -Sc)
            ;;
        2)
            echo "WARNING: This will remove ALL cached packages."
            echo "You will not be able to downgrade easily."
            pacman_cmd=(pacman -Scc)
            ;;
        *)
            echo "Invalid option."
            return
            ;;
    esac

    # Run pacman
    if confirm "Proceed with ${pacman_cmd[*]}?"; then
        warn_fail "${pacman_cmd[@]}"
    else
        echo "Aborted."
        return
    fi

    # AUR helper logic
    case "$choice:$AUR_HELPER" in

        1:yay)      cmd=(yay -Sc) ;;
        2:yay)      cmd=(yay -Scc) ;;

        1:paru)     cmd=(paru -Sc) ;;
        2:paru)     cmd=(paru -Scc) ;;

        1:pikaur)   cmd=(pikaur -Sc) ;;
        2:pikaur)   cmd=(pikaur -Scc) ;;

        1:trizen)   cmd=(trizen -Sc) ;;
        2:trizen)   cmd=(trizen -Scc) ;;

        1:aurman)   cmd=(aurman -Sc) ;;
        2:aurman)   cmd=(aurman -Scc) ;;

        1:pamac)    cmd=(pamac clean) ;;
        2:pamac)    cmd=(pamac clean --build-files) ;;

        *:None)
            echo "No AUR helper configured."
            return
            ;;

        *)
            echo "Unknown AUR helper."
            return
            ;;
    esac

    if confirm "Proceed with ${cmd[*]}?"; then
        warn_fail --user "${cmd[@]}"
    else
        echo "Aborted."
    fi
}


