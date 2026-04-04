big_files() {

    TMP_DIR="/tmp"

    clear
    echo "Select an action:"
    echo
    echo "1 List 10 largest files in $USER_HOME"
    echo "2 Temporary file management"
    echo "3 View cache size"
    echo "4 Broken symlinks management"
    echo "q Quit"
    echo

    read -rp "Your choice: " choice

    case "$choice" in

        1)
            log "Listing biggest files and directories in home"
            local depth="${1:-4}"
            echo "Top 10 largest entries in $USER_HOME:"
            du -h -x --max-depth="$depth" "$USER_HOME" 2>/dev/null | sort -hr | head -n 10
            ;;

        2)
            log "Temporary file management"

            cmd=(find "$TMP_DIR" -xdev -type f -mtime +2)

            echo "Files to be deleted:"
            "${cmd[@]}" -print

            if confirm "Delete these files?"; then
                "${cmd[@]}" -delete
            else
                echo "Aborted."
                return
            fi
            ;;

        3)
            log "Cache size listing"
            echo "Cache size:"
            du -sh "$USER_HOME/.cache" 2>/dev/null || echo "No cache directory"
            ;;

        4)
            log "Checking broken symlinks"

            cmd=(find /path -type l ! -exec test -e {} \;)

            echo "Broken symlinks:"
            results="$("${cmd[@]}" -print)"

            if [[ -z "$results" ]]; then
                echo "None found."
                return
            fi

            echo "$results"

            if confirm "Delete these broken symlinks?"; then
                "${cmd[@]}" -delete
            else
                echo "Aborted."
                return
            fi
            ;;

        q)
            quit
            ;;

        *)
            echo "Invalid option."
            return
            ;;
    esac
}
