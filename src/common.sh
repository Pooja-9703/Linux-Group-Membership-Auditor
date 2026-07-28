#!/bin/bash

# ==========================================================
# File: common.sh
# Project: Linux Security Audit Toolkit
# Description: Shared utility functions used throughout
# the Linux Security Audit Toolkit.
# Author: Pooja Dheeraj Sindhu
# ==========================================================

# ==========================================================
# Project Information
# ==========================================================

PROJECT_NAME="Linux Security Audit Toolkit"
VERSION="1.0.0"
AUTHOR="Pooja Dheeraj Sindhu"

# ==========================================================
# Audit Finding Counters
# ==========================================================

HIGH_COUNT=0
MEDIUM_COUNT=0
LOW_COUNT=0
INFO_COUNT=0

# ==========================================================
# Terminal Colors
# ==========================================================

COLOR_RED="\033[31m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_BLUE="\033[34m"
COLOR_RESET="\033[0m"

# ==========================================================
# Utility Functions
# ==========================================================

clear_screen() {
    clear
}

pause() {
    echo
    read -rp "Press Enter to continue..."
}

print_separator() {
    printf '%*s\n' 60 '' | tr ' ' '='
}

# ==========================================================
# Message Functions
# ==========================================================

print_info() {
    echo -e "${COLOR_BLUE}[INFO]${COLOR_RESET} $1"
}

print_success() {
    echo -e "${COLOR_GREEN}[SUCCESS]${COLOR_RESET} $1"
}

print_warning() {
    echo -e "${COLOR_YELLOW}[WARNING]${COLOR_RESET} $1"
}

print_error() {
    echo -e "${COLOR_RED}[ERROR]${COLOR_RESET} $1"
}

# ==========================================================
# Section Printing
# ==========================================================

print_section() {

    local title="$1"

    print_separator
    printf "%30s\n" "$title"
    print_separator
    echo
}

print_subsection() {

    local title="$1"

    echo
    print_info "$title"
}

# ==========================================================
# Security Finding
# ==========================================================

print_finding() {

    local severity="$1"
    local finding="$2"
    local recommendation="$3"

    case "$severity" in
        HIGH)
            ((HIGH_COUNT++))
            echo -e "${COLOR_RED}[HIGH]${COLOR_RESET}"
            ;;

        MEDIUM)
            ((MEDIUM_COUNT++))
            echo -e "${COLOR_YELLOW}[MEDIUM]${COLOR_RESET}"
            ;;

        LOW)
            ((LOW_COUNT++))
            echo -e "${COLOR_BLUE}[LOW]${COLOR_RESET}"
            ;;

        INFO)
            ((INFO_COUNT++))
            echo -e "${COLOR_GREEN}[INFO]${COLOR_RESET}"
            ;;

        *)
            echo "[$severity]"
            ;;
    esac

    echo
    echo "Finding:"
    echo "  $finding"
    echo

    echo "Recommendation:"
    echo "  $recommendation"
    echo

    print_separator
}

# ==========================================================
# Reset Audit Summary
# ==========================================================

reset_audit_summary() {

    HIGH_COUNT=0
    MEDIUM_COUNT=0
    LOW_COUNT=0
    INFO_COUNT=0
}

# ==========================================================
# Print Audit Summary
# ==========================================================

print_audit_summary() {

    print_section "AUDIT SUMMARY"

    printf "%-20s %d\n" "High Findings:" "$HIGH_COUNT"
    printf "%-20s %d\n" "Medium Findings:" "$MEDIUM_COUNT"
    printf "%-20s %d\n" "Low Findings:" "$LOW_COUNT"
    printf "%-20s %d\n" "Info Findings:" "$INFO_COUNT"

    echo

    if (( HIGH_COUNT > 0 )); then
        print_error "Overall Risk: HIGH"

    elif (( MEDIUM_COUNT > 0 )); then
        print_warning "Overall Risk: MEDIUM"

    elif (( LOW_COUNT > 0 )); then
        echo -e "${COLOR_BLUE}Overall Risk: LOW${COLOR_RESET}"

    else
        print_success "Overall Risk: INFORMATIONAL"
    fi

    print_separator
}

# ==========================================================
# Helper Functions
# ==========================================================

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

file_exists() {
    [[ -f "$1" ]]
}

directory_exists() {
    [[ -d "$1" ]]
}
