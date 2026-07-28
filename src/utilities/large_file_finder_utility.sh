#!/bin/bash

# ============================================================
# Large File Finder Utility
# ============================================================

large_file_finder() {

    print_section "LARGE FILE FINDER"

    local size
    local results

    read -rp "Enter minimum file size (e.g., 100M, 1G): " size
    echo

    if [[ -z "$size" ]]; then
        print_error "File size cannot be empty."
        return
    fi

    print_info "Searching for files larger than $size ..."
    echo

    results=$(find / -xdev -type f -size +"$size" -exec ls -lh {} \; 2>/dev/null)

    if [[ -z "$results" ]]; then
        print_success "No files larger than $size were found."
    else
        echo "Largest Matching Files:"
        print_separator
        echo "$results"
    fi

    echo
    print_success "Large File Finder Completed."
    print_separator
}
