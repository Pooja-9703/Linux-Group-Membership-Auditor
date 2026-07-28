#!/bin/bash

# ============================================================
# Linux Security Audit Toolkit
# Main Controller
# Author  : Pooja Dheeraj Sindhu
# Version : 1.0.0
# ============================================================

# -------------------------
# Determine Project Root
# -------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# -------------------------
# Load Shared Files
# -------------------------
source "$SCRIPT_DIR/common.sh"
source "$SCRIPT_DIR/core/report_generator.sh"

# -------------------------
# Load Audit Modules
# -------------------------
source "$SCRIPT_DIR/audits/user_audit.sh"
source "$SCRIPT_DIR/audits/group_audit.sh"
source "$SCRIPT_DIR/audits/privilege_audit.sh"
source "$SCRIPT_DIR/audits/filesystem_audit.sh"
source "$SCRIPT_DIR/audits/ssh_audit.sh"
source "$SCRIPT_DIR/audits/password_policy_audit.sh"

# -------------------------
# Load Utility Modules
# -------------------------
source "$SCRIPT_DIR/utilities/large_file_finder.sh"
source "$SCRIPT_DIR/utilities/boot_history.sh"

# ============================================================
# Display Application Banner
# ============================================================
show_banner() {

    clear

    local current_user
    current_user=$(whoami)

    local hostname
    hostname=$(hostname)

    local privileges

    if [[ $EUID -eq 0 ]]; then
        privileges="Root"
    else
        privileges="Standard User"
    fi

    echo "============================================================"
    echo "            Linux Security Audit Toolkit"
    echo "============================================================"
    echo
    echo "Version      : $VERSION"
    echo "Author       : $AUTHOR"
    echo
    echo "Host         : $hostname"
    echo "User         : $current_user"
    echo "Privileges   : $privileges"
    echo "Date         : $(date)"
    echo
    echo "============================================================"
    echo
}

# ============================================================
# Display Main Menu
# ============================================================
show_menu() {

    echo "1. User Audit"
    echo "2. Group Audit"
    echo "3. Privilege Audit"
    echo "4. Filesystem Security Audit"
    echo "5. SSH Configuration Audit"
    echo "6. Password Policy Audit"
    echo "7. Full Security Audit"
    echo "8. Utilities"
    echo "9. Exit"
    echo
}

# ============================================================
# Utilities Menu
# ============================================================
utilities_menu() {

    while true
    do
        clear

        echo "================ Utilities ================"
        echo
        echo "1. Large File Finder"
        echo "2. Boot History"
        echo "3. Back"
        echo

        read -rp "Enter your choice: " utility_choice

        case "$utility_choice" in

            1)
                large_file_finder
                read -rp "Press Enter to continue..."
                ;;

            2)
                boot_history
                read -rp "Press Enter to continue..."
                ;;

            3)
                break
                ;;

            *)
                echo "Invalid option."
                sleep 1
                ;;
        esac
    done
}

# ============================================================
# Execute User Choice
# ============================================================
handle_choice() {

    case "$1" in

        1)
            user_audit
            ;;

        2)
            group_audit
            ;;

        3)
            privilege_audit
            ;;

        4)
            filesystem_audit
            ;;

        5)
            ssh_audit
            ;;

        6)
            password_policy_audit
            ;;

        7)
            user_audit
            group_audit
            privilege_audit
            filesystem_audit
            ssh_audit
            password_policy_audit
            ;;

        8)
            utilities_menu
            return
            ;;

        9)
            echo
            echo "Thank you for using Linux Security Audit Toolkit."
            exit 0
            ;;

        *)
            print_error "Invalid menu option."
            ;;
    esac

    echo
    read -rp "Press Enter to return to the main menu..."
}

# ============================================================
# Main Program Loop
# ============================================================
main() {

    while true
    do
        show_banner
        show_menu

        read -rp "Enter your choice: " choice

        handle_choice "$choice"
    done
}

# ============================================================
# Start Application
# ============================================================
main
