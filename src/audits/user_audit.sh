#!/bin/bash

# ============================================================
# User Audit Module
# ============================================================

user_audit() {

    print_section "USER AUDIT"
    echo

    # --------------------------------------------------------
    # Total Users
    # --------------------------------------------------------
    total_users=$(wc -l < /etc/passwd)

    print_info "Total Users : $total_users"
    echo

    # --------------------------------------------------------
    # All Users
    # --------------------------------------------------------
    print_info "All System Users"

    cut -d: -f1 /etc/passwd
    echo

    # --------------------------------------------------------
    # Interactive Login Accounts
    # --------------------------------------------------------
    print_info "Interactive Login Accounts"

    awk -F: '
    $7 !~ /(nologin|false)$/ {
        printf "%-20s %s\n", $1, $7
    }
    ' /etc/passwd

    echo

    # --------------------------------------------------------
    # System Accounts
    # --------------------------------------------------------
    print_info "System Accounts (UID < 1000)"

    awk -F: '
    $3 < 1000 {
        printf "%-20s UID: %s\n", $1, $3
    }
    ' /etc/passwd

    echo

    # --------------------------------------------------------
    # UID 0 Accounts
    # --------------------------------------------------------
    print_info "UID 0 Accounts"

    uid_zero_count=0

    while IFS=: read -r username _ uid _ _ _ _
    do
        if [[ "$uid" -eq 0 ]]
        then
            echo "$username"
            ((uid_zero_count++))
        fi
    done < /etc/passwd

    if [[ "$uid_zero_count" -gt 1 ]]
    then
        print_finding \
            "HIGH" \
            "Multiple UID 0 accounts were detected." \
            "Ensure only the root account has UID 0."

    else
        print_success "Only root has UID 0."
    fi

    echo

    # --------------------------------------------------------
    # Duplicate UIDs
    # --------------------------------------------------------
    print_info "Duplicate UID Check"

    duplicates=$(cut -d: -f3 /etc/passwd | sort | uniq -d)

    if [[ -z "$duplicates" ]]
    then
        print_success "No duplicate UIDs found."
    else
        print_finding \
        "HIGH" \
        "Duplicate User IDs (UIDs) were detected." \
        "Assign a unique UID to every user account."

        while read -r uid
        do
            [[ -z "$uid" ]] && continue

            echo
            echo "UID: $uid"

            awk -F: -v id="$uid" '$3==id {print "  - " $1}' /etc/passwd

        done <<< "$duplicates"
    fi

    echo

    # --------------------------------------------------------
    # Passwordless Accounts
    # --------------------------------------------------------
    print_info "Passwordless Account Check"

    if [[ $EUID -ne 0 ]]
    then
        print_warning "Root privileges required to inspect /etc/shadow."
    else

        passwordless_found=0

        while IFS=: read -r username password_hash _
        do
            if [[ -z "$password_hash" ]]
            then
                if [[ "$passwordless_found" -eq 0 ]]; then
                    print_finding \
                        "HIGH" \
                        "One or more accounts have no password set." \
                        "Configure a strong password or disable unused accounts."
                fi

                echo "$username"
                passwordless_found=1
            fi
        done < /etc/shadow

        if [[ "$passwordless_found" -eq 0 ]]
        then
            print_success "No passwordless accounts found."
        fi

    fi

    echo
    print_success "User Audit Completed."
    print_separator
}
