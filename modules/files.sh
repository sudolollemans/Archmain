big_files() {
    log "Listing biggest files and directories in home"

    local depth="${1:-4}"

    USER_HOME="$(eval echo ~$SUDO_USER)"

    echo "Top 10 largest files/directories in $USER_HOME:"
    du -ah "$USER_HOME" --max-depth="$depth" 2>/dev/null | sort -hr | head -n 10

}
