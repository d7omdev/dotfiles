#!/bin/bash
################################################################################
# System Cleanup Script with Interactive Config Selector
# Description: Safely cleans system directories and allows selective config cleanup
# Author: D7OM (hello@d7om.dev)
# Usage: ./cleanup.sh [-p] [-h]
################################################################################

#===============================================================================
# INITIALIZATION AND SETUP
#===============================================================================

# Terminal colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BLACK='\033[0;30m'
NC='\033[0m' # No Color

# Script configuration
set -euo pipefail # Exit on error, undefined vars, and pipe failures
BACKUP_DIR="${HOME}/cleanup_backups"

# Help function - moved before it's used
show_help() {
	echo "Usage: $0 [-p] [-h]"
	echo "Options:"
	echo "  -p    Create a safety backup before cleaning"
	echo "  -h    Display this help message"
	echo
	echo "Description:"
	echo "  Performs system cleanup operations and allows selective"
	echo "  removal of configuration directories."
}

#===============================================================================
# UTILITY FUNCTIONS
#===============================================================================

create_backup() {
	local backup_name
	local backup_path

	backup_name="config-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
	backup_path="${BACKUP_DIR}/${backup_name}"

	mkdir -p "${BACKUP_DIR}"
	if tar -czf "${backup_path}" -C "$HOME" .config &>/dev/null; then
		echo -e "${BLUE}Created safety backup: ${backup_path}${NC}"
		return 0
	else
		echo -e "${RED}Failed to create backup!${NC}" >&2
		return 1
	fi
}

calculate_space() {
	df --output=avail / | tail -n 1
}

#===============================================================================
# ARGUMENT PARSING
#===============================================================================

create_backup=false

while getopts "ph" opt; do
	case ${opt} in
	p) create_backup=true ;;
	h)
		show_help
		exit 0
		;;
	*)
		show_help
		exit 1
		;;
	esac
done
shift $((OPTIND - 1))

#===============================================================================
# SYSTEM CLEANUP PHASE
#===============================================================================

echo -e "\n${YELLOW}=== Starting System Cleanup ===${NC}"

# Create initial backup if requested
if [ "$create_backup" = true ]; then
	create_backup || exit 1
fi

# Record initial space
space_before=$(calculate_space)

# Clean orphaned packages
echo -e "\n${BLUE}Checking for orphaned packages...${NC}"
if orphans=$(pacman -Qdtq 2>/dev/null); then
	if [ -n "$orphans" ]; then
		echo -e "${YELLOW}Found orphaned packages:${NC}"
		echo "$orphans"
		if sudo pacman -Rns "$orphans"; then
			echo -e "${GREEN}✓ Orphaned packages removed${NC}"
		fi
	else
		echo -e "${GREEN}✓ No orphaned packages found${NC}"
	fi
fi

# Clean system logs
echo -e "\n${BLUE}Cleaning system journals...${NC}"
if sudo journalctl --vacuum-time=2weeks; then
	echo -e "${GREEN}✓ Journal logs cleaned${NC}"
fi

# Clean temporary files
echo -e "\n${BLUE}Cleaning temporary files...${NC}"
sudo rm -rf /var/tmp/* /tmp/* 2>/dev/null || true
echo -e "${GREEN}✓ System temporary files cleaned${NC}"

# Clean user cache
echo -e "\n${BLUE}Cleaning user cache...${NC}"
rm -rf ~/.cache/* 2>/dev/null || true
echo -e "${GREEN}✓ User cache cleaned${NC}"

#===============================================================================
# CONFIG CLEANUP PHASE
#===============================================================================

echo -e "\n${YELLOW}=== Config Directory Cleanup ===${NC}"

# Define protected directories that should never be deleted
SAFE_DIRS=(
	"Code - OSS" "GitHub Desktop" "ags" "ags.bak"
	"hypr" "nvim" "tmux" "fish" "qt5ct" "qt6ct"
	"discord" "gh" "kitty" "yazi" "zsh" "npm"
)

# Find candidate directories for cleanup
candidate_dirs=()
while IFS= read -r -d $'\0' dir; do
	dir_name=$(basename "$dir")
	# Skip if directory is in SAFE_DIRS
	for safe_dir in "${SAFE_DIRS[@]}"; do
		if [ "$dir_name" = "$safe_dir" ]; then
			continue 2
		fi
	done
	# Only include directories with hyphens or underscores
	[[ "$dir_name" =~ [-_] ]] && candidate_dirs+=("$dir")
done < <(find ~/.config -maxdepth 1 -type d -print0)

# Check if there are any candidates
if [ ${#candidate_dirs[@]} -eq 0 ]; then
	echo -e "${GREEN}✓ No config directories to clean!${NC}"
	exit 0
fi

# Display candidates
echo -e "\n${BLUE}Potentially removable config directories:${NC}"
for i in "${!candidate_dirs[@]}"; do
	printf "%2d) %s\n" $((i + 1)) "$(basename "${candidate_dirs[$i]}")"
done | column

# Get user selection
echo -e "\n${YELLOW}Enter numbers to delete (e.g., 1 3 5-7), 'a' for all, or Enter to skip:${NC}"
read -r selection

# Process selection
delete_dirs=()
if [[ "${selection,,}" == "a" ]]; then
	delete_dirs=("${candidate_dirs[@]}")
elif [ -n "$selection" ]; then
	for item in $(echo "$selection" | tr ',' ' '); do
		if [[ $item =~ ^[0-9]+-[0-9]+$ ]]; then
			# Handle ranges (e.g., 1-3)
			start="${item%-*}"
			end="${item#*-}"
			for ((i = start; i <= end; i++)); do
				[ $((i - 1)) -lt ${#candidate_dirs[@]} ] &&
					delete_dirs+=("${candidate_dirs[$((i - 1))]}")
			done
		elif [[ $item =~ ^[0-9]+$ ]]; then
			# Handle single numbers
			[ $((item - 1)) -lt ${#candidate_dirs[@]} ] &&
				delete_dirs+=("${candidate_dirs[$((item - 1))]}")
		fi
	done
fi

# Confirm and execute deletion
if [ ${#delete_dirs[@]} -gt 0 ]; then
	echo -e "\n${RED}The following directories will be deleted:${NC}"
	printf "• %s\n" "${delete_dirs[@]/#/$HOME/.config/}"

	read -p $'\n'"Are you sure? (y/N) " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		rm -rf "${delete_dirs[@]}"
		echo -e "${GREEN}✓ Deleted ${#delete_dirs[@]} directories${NC}"
	else
		echo -e "${BLUE}✗ Deletion canceled${NC}"
	fi
else
	echo -e "${BLUE}✓ No directories selected for deletion${NC}"
fi

#===============================================================================
# FINAL REPORT
#===============================================================================

space_after=$(calculate_space)
space_freed=$((space_after - space_before))

echo -e "\n${YELLOW}=== Cleanup Complete ===${NC}"
echo -e "Total space freed: ${GREEN}$(numfmt --to=iec $space_freed)${NC}"
if [ "$create_backup" = true ]; then
	echo -e "Backup location: ${BLUE}${BACKUP_DIR}${NC}"
fi
