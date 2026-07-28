#!/bin/bash

# ============================================================
# Password Policy Audit Module
# ============================================================

password_policy_audit() {

    print_section "PASSWORD POLICY AUDIT"

    LOGIN_DEFS="/etc/login.defs"

    if [[ ! -f "$LOGIN_DEFS" ]]; then
        print_error "/etc/login.defs not found."
        return
    fi

    # --------------------------------------------------------
    # PASS_MAX_DAYS
    # --------------------------------------------------------
    print_subsection "Maximum Password Age"

    max_days=$(grep -E "^PASS_MAX_DAYS" "$LOGIN_DEFS" | awk '{print $2}')

    if [[ -z "$max_days" ]]; then
        print_warning "PASS_MAX_DAYS not configured."
    elif [[ "$max_days" -gt 90 ]]; then
        print_warning "Passwords expire after $max_days days."
    else
        print_success "PASS_MAX_DAYS = $max_days"
    fi

    # --------------------------------------------------------
    # PASS_MIN_DAYS
    # --------------------------------------------------------
    print_subsection "Minimum Password Age"

    min_days=$(grep -E "^PASS_MIN_DAYS" "$LOGIN_DEFS" | awk '{print $2}')

    if [[ -z "$min_days" ]]; then
        print_warning "PASS_MIN_DAYS not configured."
    elif [[ "$min_days" -eq 0 ]]; then
        print_warning "Users can immediately change passwords."
    else
        print_success "PASS_MIN_DAYS = $min_days"
    fi

    # --------------------------------------------------------
    # PASS_WARN_AGE
    # --------------------------------------------------------
    print_subsection "Password Expiry Warning"

    warn_days=$(grep -E "^PASS_WARN_AGE" "$LOGIN_DEFS" | awk '{print $2}')

    if [[ -z "$warn_days" ]]; then
        print_warning "PASS_WARN_AGE not configured."
    else
        print_success "PASS_WARN_AGE = $warn_days"
    fi

    # --------------------------------------------------------
    # Password Hash Algorithm
    # --------------------------------------------------------
    print_subsection "Password Hash Algorithm"

    if grep -qi "yescrypt" /etc/pam.d/common-password 2>/dev/null; then
        print_success "yescrypt detected."
    elif grep -qi "sha512" /etc/pam.d/common-password 2>/dev/null; then
        print_success "SHA-512 detected."
    else
        print_info "Unable to determine password hashing algorithm."
    fi

    # --------------------------------------------------------
    # Accounts With Expired Passwords
    # --------------------------------------------------------
    print_subsection "Expired Password Check"

    if [[ $EUID -ne 0 ]]; then
        print_warning "Root privileges required to inspect password expiry."
    else

        expired_found=0

        while IFS=: read -r user _
        do
            status=$(chage -l "$user" 2>/dev/null | grep "Password expires")

            if echo "$status" | grep -qi "password must be changed"; then
                echo "$user"
                expired_found=1
            fi

        done < /etc/passwd

        if [[ "$expired_found" -eq 0 ]]; then
            print_success "No expired passwords detected."
        fi
    fi

    # --------------------------------------------------------
    # Password Lockout Support
    # --------------------------------------------------------
    print_subsection "Account Lockout Policy"

    if grep -Rq "pam_faillock.so" /etc/pam.d 2>/dev/null; then
        print_success "Account lockout policy detected."
    else
        print_warning "No account lockout policy detected."
    fi

    echo
    print_success "Password Policy Audit Completed."

    print_separator
}
