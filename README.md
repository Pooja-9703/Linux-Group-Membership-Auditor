#Group-Membership-Auditor
A Bash-based Linux system enumeration tool that audits group memberships by parsing /etc/group, providing structured output with GIDs, members, and reporting features for security analysis.

<img width="1772" height="794" alt="group_membership_auditor" src="https://github.com/user-attachments/assets/f7c6e6d8-ab2b-449a-a891-6ead4e41f8fd" />

--------------------------------------------------------------------------------
                                 README
--------------------------------------------------------------------------------

Script Name   : group_membership_auditor.sh  
Author        : Pooja Dheeraj Sindhu  
Date          : 25/03/26  

--------------------------------------------------------------------------------
                                 DESCRIPTION
--------------------------------------------------------------------------------
This script audits all system groups listed in `/etc/group` and displays or saves
their group name, GID, and members in a clean tabular format.

It provides an interactive menu for the user to:

   - Save the report to a file (`group_membership_report.txt`)  
   - View the report on screen  
   - Display the total number of groups on the system  
   - Exit the tool

--------------------------------------------------------------------------------
                                 REQUIREMENTS
--------------------------------------------------------------------------------
 - Shell: Bash  
 - File: Must have read permissions for `/etc/group`  
 - Runs as a normal user (no root needed)  

--------------------------------------------------------------------------------
                         FEATURES & ENHANCEMENTS
--------------------------------------------------------------------------------
 - Interactive and menu-based navigation  
 - Color-coded output for improved readability  
 - Option to view or save the report  
 - Graceful error handling if `/etc/group` is unreadable  
 - Shows total number of groups (extra feature)  
 - Uses temporary files for clean screen display  
 - Neatly formatted columns (Group Name, GID, Members)

--------------------------------------------------------------------------------
                                HOW TO RUN
--------------------------------------------------------------------------------

1. Give execute permission:

   chmod +x group_membership_auditor.sh

2. Run the script:

    ./group_membership_auditor.sh

3. Choose an option from the menu:
    
                GROUP MEMBERSHIP AUDIT TOOL
-------------------------------------------------------------------------
1. Save report to file (group_membership_report.txt)
2. Display report on screen
3. Show total number of groups
4. Exit
-------------------------------------------------------------------------
Enter your choice [1-4]:

4. Once complete, open the file

    group_membership_report.txt
