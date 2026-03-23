Maintenance script I wrote as a personal project to learn Bash (and Arch). 

------------------------------------------------------------------------------------

# Archmain

A modular Arch Linux maintenance script for backups, updates, cleanup, and system diagnostics.

# --- Project Structure ---

archmain/
  archmain (main script)
  modules/
  ├── backup.sh
  ├── clean.sh
  ├── software.sh
  ├── doctor.sh
  ├── firmware.sh
  ├── orphaned.sh
  ├── journal.sh
  ├── files.sh
  └── failed.sh

# --- Requirements ---

- Arch Linux (or Arch-based distro)
- Root privileges (must be run with `sudo`)
- Required tools:
  - `pacman`
  - `rsync`
  - `fwupdmgr`
  - `pacdiff`

Optional:
- AUR helper (auto-detected):
  - `yay`, `paru`, `pikaur`, `trizen`, `pamac`, or `aurman`

# --- Features ---

- Backup system:
  - Home directory (with exclusions)
  - `/etc` configuration
  - Installed packages + AUR list (to $HOME by default)
  - Enabled services (to $HOME by default)

- System updates:
  - Pacman + AUR helper support (yay, paru, pikaur, trizen, pamac, aurman)
  - Config diff checking with `pacdiff`

- Cleanup tools:
  - Package cache cleaning (safe/full)
  - Journal cleanup
  - Orphaned package removal

- Diagnostics:
  - Full system health report
  - Failed services inspection
  - Journal error logs
  - Firmware update checks

- Utilities:
  - File manager

- Modular design:
  - Features split into `/modules`
  - Dynamically loaded when needed


# --- Usage ---

Without arguments you'll get a menu:

1 Backup files and services
2 Update software
3 Upgrade firmware
4 List and remove orphaned packages
5 Clean package cache
6 Inspect failed services and errors
7 Clean journal logs
8 File manager
d System health check
q Quit

CLI mode (non-interactive) with one arg maximum

You can run specific actions directly:

sudo ./archmain backup
sudo ./archmain update
sudo ./archmain clean
sudo ./archmain orphaned
sudo ./archmain syscheck


# --- Safety Features ---

Prevents running as root directly (requires sudo)
Validates home directory
Prevents dangerous paths like /
Confirms destructive operations
Uses dry-run previews for backups
Error logging with trap handling


# --- Configuration ---

Environment variables can be used to override defaults:

Variable	Default	Description
ARCHMAIN_REC	$HOME	Backup metadata location
ARCHMAIN_DEST	/mnt/backup	Backup destination
ARCHMAIN_LOGFILE	$HOME/archmain-log.txt	Log file
ARCHMAIN_HEALTHFILE	$HOME/archmain-health.txt	Health report output

Example:

ARCHMAIN_DEST=/run/media/user/backup sudo ./archmain backup

# --- Backup Details ---

Home backup excludes as default:
.cache/
Downloads/
.local/
.steam/

Additional saved data (default in $HOME)
Installed packages (pkglist.txt)
AUR packages (aurlist.txt)
System services (services-state.txt)

# --- AUR Helper Support ---

Automatically detects:
yay
paru
pikaur
trizen
pamac
aurman

If none is found, AUR-related features are skipped.

# --- System Health Report Includes ---

Disk usage
Failed services
Orphaned packages
Journal errors
Available updates
Firmware status

# --- Disclaimer ---

This script performs potentially destructive operations such as:
Deleting files during backups (using rsync --delete)
Removing packages
Cleaning logs

Always review prompts carefully and ensure backups are correct before proceeding. Prompts are plenty and dangerous operations are not performed automatically.

