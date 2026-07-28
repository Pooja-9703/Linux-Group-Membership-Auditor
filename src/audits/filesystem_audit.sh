#!/bin/bash

# ============================================================
# Filesystem Security Audit Module
# ============================================================

filesystem_audit() {

    print_section "FILESYSTEM SECURITY AUDIT"

    # --------------------------------------------------------
    # World Writable Directories
    # --------------------------------------------------------
    print_subsection "World Writable Directories (First 20)"

    directories=$(find / -xdev -type d -perm -0002 2>/dev/null | head -20)

    if [[ -z "$directories" ]]; then
        print_success "No world writable directories found."
    else
        echo "$directories"
    fi

    # --------------------------------------------------------
    # World Writable Files
    # --------------------------------------------------------
    print_subsection "World Writable Files (First 20)"

    files=$(find / -xdev -type f -perm -0002 2>/dev/null | head -20)

    if [[ -z "$files" ]]; then
        print_success "No world writable files found."
    else
        echo "$files"
    fi

    # --------------------------------------------------------
    # Files Without Owner
    # --------------------------------------------------------
    print_subsection "Files Without Valid Owner"

    orphan_owner=$(find / -xdev -nouser 2>/dev/null | head -20)

    if [[ -z "$orphan_owner" ]]; then
        print_success "No orphaned owner files found."
    else
        echo "$orphan_owner"
    fi

    # --------------------------------------------------------
    # Files Without Group
    # --------------------------------------------------------
    print_subsection "Files Without Valid Group"

    orphan_group=$(find / -xdev -nogroup 2>/dev/null | head -20)

    if [[ -z "$orphan_group" ]]; then
        print_success "No orphaned group files found."
    else
        echo "$orphan_group"
    fi

    # --------------------------------------------------------
    # Hidden Files
    # --------------------------------------------------------
    print_subsection "Hidden Files in /home (First 20)"

    hidden=$(find /home -type f -name ".*" 2>/dev/null | head -20)

    if [[ -z "$hidden" ]]; then
        print_success "No hidden files found."
    else
        echo "$hidden"
    fi

    # --------------------------------------------------------
    # Sensitive File Permissions
    # --------------------------------------------------------
    print_subsection "Critical File Permissions"

    for file in /etc/passwd /etc/shadow /etc/group /etc/sudoers
    do
        if [[ -e "$file" ]]; then
            stat -c "%A %U:%G %n" "$file"
        fi
    done

    echo
    print_success "Filesystem Security Audit Completed."

    print_separator
}
