# Test Results

## Test Environment

- Operating System: Ubuntu 22.04 LTS
- Shell: Bash 5.1
- User Privileges: Root and Standard User
- Test Date: 2026-07-28

---

## Results

### User Audit
✔ Listed all system users successfully.
✔ Identified interactive and system accounts.
✔ Correctly detected UID 0 accounts.
✔ Correctly detected duplicate UIDs.
✔ Correctly detected passwordless accounts.

**Status:** PASS

---

### Group Audit
✔ Listed all system groups.
✔ Displayed group members.
✔ Identified empty groups.
✔ Correctly detected duplicate GIDs.
✔ Correctly detected GID 0 groups.

**Status:** PASS

---

### Privilege Audit
✔ Listed users with sudo privileges.
✔ Detected world-writable files.
✔ Detected SUID binaries.
✔ Detected SGID binaries.

**Status:** PASS

---

### Filesystem Security Audit
✔ Detected world-writable directories.
✔ Detected world-writable files.
✔ Detected orphaned files and groups.
✔ Listed hidden files in `/home`.
✔ Verified permissions of critical system files.

**Status:** PASS

---

### SSH Configuration Audit
✔ Verified SSH installation status.
✔ Verified SSH service status.
✔ Checked SSH security configuration options.
✔ Correctly handled systems without OpenSSH Server.

**Status:** PASS

---

### Password Policy Audit
✔ Verified password aging policy.
✔ Verified password hashing algorithm.
✔ Checked expired passwords.
✔ Checked account lockout policy.

**Status:** PASS

---

### Large File Finder Utility
✔ Successfully searched for files above the specified size.
✔ Displayed file permissions, owner, size and location.
✔ Correctly handled cases where no matching files were found.

**Status:** PASS

---

### Boot History Utility
✔ Successfully displayed recent system boot history.
✔ Correctly handled systems with limited boot records.

**Status:** PASS

---

## Overall Status

**Result:** PASS

All audit modules and utilities executed successfully without runtime errors.
