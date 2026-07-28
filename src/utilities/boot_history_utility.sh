#!/bin/bash

# ============================================================
# Boot History Utility
# ============================================================

boot_history() {

    print_section "BOOT HISTORY"

    if ! command -v last &>/dev/null; then
        print_error "'last' command is not available on this system."
        return
    fi

    print_info "Displaying recent system boot records..."
    echo

    boots=$(last reboot -F | head -10)

    if [[ -z "$boots" ]]; then
        print_info "No boot history found."
    else
        echo "Recent Boot Records:"
        print_separator
        echo "$boots"
    fi

    echo
    print_success "Boot History Utility Completed."
    print_separator
}
