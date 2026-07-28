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
    printf '%*s\n' "60" '' | tr ' ' '='
}

print_header() {
    local title="$1"

    print_separator
    echo "$title"
    print_separator
}

print_banner() {
    clear_screen

    print_separator
    echo "$PROJECT_NAME"
    echo "Version : $VERSION"
    echo "Author  : $AUTHOR"
    print_separator
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
# Finding Functions
# ==========================================================

print_finding() {

    local severity="$1"
    local finding="$2"
    local explanation="$3"
    local recommendation="$4"

    case "$severity" in
        HIGH)
            echo -e "${COLOR_RED}[HIGH]${COLOR_RESET}"
            ;;
        MEDIUM)
            echo -e "${COLOR_YELLOW}[MEDIUM]${COLOR_RESET}"
            ;;
        LOW)
            echo -e "${COLOR_BLUE}[LOW]${COLOR_RESET}"
            ;;
        INFO)
            echo "[INFO]"
            ;;
        *)
            echo "[$severity]"
            ;;
    esac

    echo "Finding       : $finding"
    echo "Explanation   : $explanation"
    echo "Recommendation: $recommendation"

    echo
    printf '%*s\n' "60" '' | tr ' ' '-'
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

# ============================================================
# Print Section Header
# ============================================================
print_section() {

    local title="$1"

    print_separator
    printf "%30s\n" "$title"
    print_separator
    echo
}

# ============================================================
# Print Subsection Header
# ============================================================
print_subsection() {

    local title="$1"

    echo
    print_info "$title"
}
