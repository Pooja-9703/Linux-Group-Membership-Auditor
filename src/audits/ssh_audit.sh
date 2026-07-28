#!/bin/bash

# ============================================================
# SSH Configuration Audit Module
# ============================================================

ssh_audit() {

    print_section "SSH CONFIGURATION AUDIT"

    local SSH_CONFIG="/etc/ssh/sshd_config"
    local value
    local port

    # --------------------------------------------------------
    # Check if SSH is installed
    # --------------------------------------------------------
    if ! command -v ssh >/dev/null 2>&1; then
        print_warning "OpenSSH is not installed."
        return
    fi

    print_success "OpenSSH is installed."

    # --------------------------------------------------------
    # Check SSH Service Status
    # --------------------------------------------------------
    print_subsection "SSH Service Status"

    if systemctl is-active --quiet ssh 2>/dev/null || systemctl is-active --quiet sshd 2>/dev/null; then
        print_success "SSH service is running."
    else
    print_finding \
        "LOW" \
        "SSH service is not running." \
        "Start the SSH service if remote administration is required."
    fi

    # --------------------------------------------------------
    # Check Configuration File
    # --------------------------------------------------------
    if [[ ! -f "$SSH_CONFIG" ]]; then
	print_info "OpenSSH Server is not configured on this system."
	echo
	print_success "SSH Configuration Audit Completed."
	print_separator
        return
    fi

    # --------------------------------------------------------
    # PermitRootLogin
    # --------------------------------------------------------
    print_subsection "PermitRootLogin"

    value=$(grep -Ei '^\s*PermitRootLogin' "$SSH_CONFIG" | awk '{print $2}')

    if [[ "$value" == "no" ]]; then
        print_success "Root login is disabled."
    else
    print_finding \
        "HIGH" \
        "Root SSH login is enabled or not explicitly disabled." \
        "Set 'PermitRootLogin no' in /etc/ssh/sshd_config."
    fi

    # --------------------------------------------------------
    # PasswordAuthentication
    # --------------------------------------------------------
    print_subsection "PasswordAuthentication"

    value=$(grep -Ei '^\s*PasswordAuthentication' "$SSH_CONFIG" | awk '{print $2}')

    if [[ "$value" == "no" ]]; then
        print_success "Password authentication is disabled."
    else
    print_finding \
        "MEDIUM" \
        "Password authentication is enabled." \
        "Disable password authentication and use SSH key authentication."
    fi

    # --------------------------------------------------------
    # PubkeyAuthentication
    # --------------------------------------------------------
    print_subsection "PubkeyAuthentication"

    value=$(grep -Ei '^\s*PubkeyAuthentication' "$SSH_CONFIG" | awk '{print $2}')

    if [[ "$value" == "yes" ]]; then
        print_success "Public key authentication is enabled."
    else
    print_finding \
        "MEDIUM" \
        "Public key authentication is disabled." \
        "Enable 'PubkeyAuthentication yes' in the SSH configuration."
    fi

    # --------------------------------------------------------
    # PermitEmptyPasswords
    # --------------------------------------------------------
    print_subsection "PermitEmptyPasswords"

    value=$(grep -Ei '^\s*PermitEmptyPasswords' "$SSH_CONFIG" | awk '{print $2}')

    if [[ "$value" == "no" ]]; then
        print_success "Empty passwords are not allowed."
    else
    print_finding \
        "HIGH" \
        "Empty passwords may be allowed for SSH logins." \
        "Set 'PermitEmptyPasswords no' in /etc/ssh/sshd_config."
    fi

    # --------------------------------------------------------
    # X11Forwarding
    # --------------------------------------------------------
    print_subsection "X11Forwarding"

    value=$(grep -Ei '^\s*X11Forwarding' "$SSH_CONFIG" | awk '{print $2}')

    if [[ "$value" == "no" ]]; then
        print_success "X11 forwarding is disabled."
    else
        print_info "X11 forwarding is enabled."
    fi

    # --------------------------------------------------------
    # MaxAuthTries
    # --------------------------------------------------------
    print_subsection "MaxAuthTries"

    value=$(grep -Ei '^\s*MaxAuthTries' "$SSH_CONFIG" | awk '{print $2}')

    if [[ -z "$value" ]]; then
        print_info "Using default value."
    elif [[ "$value" -le 4 ]]; then
        print_success "MaxAuthTries = $value"
    else
    print_finding \
        "LOW" \
        "MaxAuthTries is set to $value." \
        "Reduce MaxAuthTries to 4 or fewer to limit brute-force attempts."
    fi

    # --------------------------------------------------------
    # SSH Port
    # --------------------------------------------------------
    print_subsection "SSH Port"

    port=$(grep -Ei '^\s*Port' "$SSH_CONFIG" | awk '{print $2}')

    if [[ -z "$port" ]]; then
        port="22 (default)"
    fi

    print_info "Configured Port: $port"

    echo
    print_success "SSH Configuration Audit Completed."

    print_separator
}
