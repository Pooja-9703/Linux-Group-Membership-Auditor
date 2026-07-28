#!/bin/bash

# ============================================================
# Privilege Audit Module
# ============================================================

privilege_audit() {

    print_section "PRIVILEGE AUDIT"

    # --------------------------------------------------------
    # Users in sudo group
    # --------------------------------------------------------
    print_subsection "Users with Sudo Privileges"

    if getent group sudo >/dev/null; then
        sudo_members=$(getent group sudo | cut -d: -f4)

        if [[ -z "$sudo_members" ]]; then
            print_info "No supplementary sudo users found."
        else
            echo "$sudo_members" | tr ',' '\n'
        fi
    else
        print_warning "sudo group not found."
    fi

    # --------------------------------------------------------
    # UID 0 Accounts
    # --------------------------------------------------------
    print_subsection "UID 0 Accounts"

    awk -F: '$3==0 {print $1}' /etc/passwd

    uid_zero_count=$(awk -F: '$3==0' /etc/passwd | wc -l)

    if [[ "$uid_zero_count" -gt 1 ]]; then
        print_finding \
            "HIGH" \
            "Multiple UID 0 accounts were detected." \
            "Ensure only the root account has UID 0."

    else
        print_success "Only root has UID 0."
    fi

    # --------------------------------------------------------
    # World Writable Files
    # --------------------------------------------------------
    print_subsection "World Writable Files (First 20)"

    world_writable=$(find / -xdev -type f -perm -0002 2>/dev/null | head -20)

    if [[ -z "$world_writable" ]]; then
        print_success "No world writable files found."
    else
        print_finding \
            "HIGH" \
            "World writable files were detected." \
            "Review the files below and remove unnecessary write permissions."

        echo "$world_writable"
    fi

    # --------------------------------------------------------
    # SUID Files
    # --------------------------------------------------------
    print_subsection "SUID Binaries (First 20)"

    suid_files=$(find / -xdev -type f -perm -4000 2>/dev/null | head -20)

    if [[ -z "$suid_files" ]]; then
        print_success "No SUID binaries found."
    else
        print_finding \
            "LOW" \
            "SUID binaries were found." \
            "Review the binaries below to ensure they are legitimate."

        echo "$suid_files"
    fi

    # --------------------------------------------------------
    # SGID Files
    # --------------------------------------------------------
    print_subsection "SGID Binaries (First 20)"

    sgid_files=$(find / -xdev -type f -perm -2000 2>/dev/null | head -20)

    if [[ -z "$sgid_files" ]]; then
        print_success "No SGID binaries found."
    else
        print_finding \
            "LOW" \
            "SGID binaries were found." \
            "Review the binaries below to ensure they are legitimate."

        echo "$sgid_files"
    fi

    echo
    print_success "Privilege Audit Completed."

    print_separator
}
