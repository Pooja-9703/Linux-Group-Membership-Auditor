#!/bin/bash
# ----------------------------------------------------------------------
# Script Name : task47_group_membership_auditor.sh
# Description : Audits all system groups and lists their members in a report
# Author      : Pooja Dheeraj Sindhu
# Date        : 09/07/25
# ----------------------------------------------------------------------

#Creation of output file
REPORT_FILE="group_membership_report.txt"

# Define colour codes
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;95m'
BG_BLUE='\033[44m'
NC='\033[0m' # No colour

# Check for /etc/group
if [ ! -r /etc/group ]; then
    echo -e "${RED} Error: Cannot read /etc/group. Make sure the file exists and you have permissions. ${NC}"
    exit 1
fi

# Function to generate report
generate_report() {
    local destination="$1"

    echo -e "${MAGENTA}		Group Membership Audit Report	 ${NC}" > "$destination"
    echo -e "${BLUE}	Generated on: $(date)	${NC}" >> "$destination"
    echo "----------------------------------------------------------------" >> "$destination"
    printf "%-20s | %-6s | %s\n" "Group Name" "GID" "Members" >> "$destination"
    echo "----------------------------------------------------------------" >> "$destination"

    while IFS=: read -r group_name _ gid members; do
        [ -z "$members" ] && members="None"
        printf "%-20s | %-6s | %s\n" "$group_name" "$gid" "$members" >> "$destination"
    done < /etc/group

    echo "----------------------------------------------------------------" >> "$destination"
}

# Interactive Menu

while true; do
    echo -e "\n${BG_BLUE}	GROUP MEMBERSHIP AUDIT TOOL	${NC}"
    echo "-------------------------------------------------------------------------"
    echo "1. Save report to file ($REPORT_FILE)"
    echo "2. Display report on screen"
    echo "3. Show total number of groups"
    echo "4. Exit"
    echo "-------------------------------------------------------------------------"
    read -p "Enter your choice [1-4]: " choice

    case "$choice" in
        1)
            generate_report "$REPORT_FILE"
            echo -e "${GREEN}  Report saved to $REPORT_FILE ${NC}"
            ;;
        2)
            TMPFILE=$(mktemp)
            generate_report "$TMPFILE"
            cat "$TMPFILE"
            rm "$TMPFILE"
            ;;
        3)
            total_groups=$(wc -l < /etc/group)
            echo -e "${MAGENTA} Total groups on system: ${MAGENTA} $total_groups ${NC}"
            ;;
        4)
            echo -e "${YELLOW} Exiting. Goodbye! ${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED} Invalid choice. Please choose any number between 1-4. ${NC}"
            ;;
    esac
done