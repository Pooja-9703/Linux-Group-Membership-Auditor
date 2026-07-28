#!/bin/bash

# ============================================================
# Group Audit Module
# ============================================================

group_audit() {

    print_section "GROUP AUDIT"

    # --------------------------------------------------------
    # Total Groups
    # --------------------------------------------------------
    total_groups=$(wc -l < /etc/group)

    print_info "Total Groups : $total_groups"

    # --------------------------------------------------------
    # All Groups
    # --------------------------------------------------------
    print_subsection "All Groups"

    cut -d: -f1 /etc/group

    # --------------------------------------------------------
    # Members of Each Group
    # --------------------------------------------------------
    print_subsection "Group Membership"

    while IFS=: read -r group _ gid members
    do
        if [[ -z "$members" ]]
        then
            printf "%-20s : No Members\n" "$group"
        else
            printf "%-20s : %s\n" "$group" "$members"
        fi
    done < /etc/group

    # --------------------------------------------------------
    # Empty Groups
    # --------------------------------------------------------
    print_subsection "Groups With No Members"

    empty_found=0

    while IFS=: read -r group _ gid members
    do
        if [[ -z "$members" ]]
        then
            echo "$group"
            empty_found=1
        fi
    done < /etc/group

    if [[ "$empty_found" -eq 0 ]]
    then
        print_success "No empty groups found."
    fi

    # --------------------------------------------------------
    # GID 0 Groups
    # --------------------------------------------------------
    print_subsection "GID 0 Groups"

    gid_zero_count=0

    while IFS=: read -r group _ gid members
    do
        if [[ "$gid" -eq 0 ]]
        then
            echo "$group"
            ((gid_zero_count++))
        fi
    done < /etc/group

    if [[ "$gid_zero_count" -gt 1 ]]
    then
        print_finding \
            "HIGH" \
            "Multiple groups with GID 0 were detected." \
            "Ensure only the root group uses GID 0."

    else
        print_success "Only the root group has GID 0."
    fi

    # --------------------------------------------------------
    # Duplicate GIDs
    # --------------------------------------------------------
    print_subsection "Duplicate GID Check"

    duplicates=$(cut -d: -f3 /etc/group | sort | uniq -d)

    if [[ -z "$duplicates" ]]
    then
        print_success "No duplicate GIDs found."
    else

        print_finding \
        "MEDIUM" \
        "Duplicate Group IDs (GIDs) were detected." \
        "Assign unique GIDs to each group to prevent permission conflicts."

        while read -r gid
        do
            [[ -z "$gid" ]] && continue

            echo
            echo "GID : $gid"

            awk -F: -v id="$gid" '$3==id {print "  - " $1}' /etc/group

        done <<< "$duplicates"

    fi

    echo
    print_success "Group Audit Completed."
    print_separator
}
