# Test Cases

## User Audit

### Test Cases

- [x] Verify total number of system users is displayed.
- [x] Verify all system users are listed from `/etc/passwd`.
- [x] Verify interactive login accounts are identified correctly.
- [x] Verify system accounts (UID < 1000) are displayed.
- [x] Verify detection of multiple UID 0 accounts.
- [x] Verify detection of duplicate UIDs.
- [x] Verify detection of passwordless accounts (requires root privileges).
- [x] Verify warning is displayed when `/etc/shadow` cannot be accessed.
- [x] Verify audit completion message is displayed.

---

## Group Audit

### Test Cases

- [x] Verify total number of groups is displayed.
- [x] Verify all system groups are listed.
- [x] Verify members of each group are displayed.
- [x] Verify empty groups are identified.
- [x] Verify detection of multiple GID 0 groups.
- [x] Verify detection of duplicate GIDs.
- [x] Verify audit completion message is displayed.

---

## Privilege Audit

### Test Cases

- [x] Verify users with sudo privileges are displayed.
- [x] Verify detection of multiple UID 0 accounts.
- [x] Verify world-writable files are detected.
- [x] Verify SUID binaries are detected.
- [x] Verify SGID binaries are detected.
- [x] Verify audit completion message is displayed.

---

## Filesystem Security Audit

### Test Cases

- [x] Verify detection of world-writable directories.
- [x] Verify detection of world-writable files.
- [x] Verify detection of orphaned files.
- [x] Verify detection of orphaned groups.
- [x] Verify hidden files in `/home` are listed.
- [x] Verify permissions of critical system files are displayed.
- [x] Verify audit completion message is displayed.

---

## SSH Configuration Audit

### Test Cases

- [x] Verify detection when OpenSSH is installed.
- [x] Verify behaviour when OpenSSH is not installed.
- [x] Verify behaviour when `sshd_config` is unavailable.
- [x] Verify SSH service status.
- [x] Verify PermitRootLogin configuration.
- [x] Verify PasswordAuthentication configuration.
- [x] Verify PubkeyAuthentication configuration.
- [x] Verify PermitEmptyPasswords configuration.
- [x] Verify X11Forwarding configuration.
- [x] Verify MaxAuthTries configuration.
- [x] Verify configured SSH port is displayed.
- [x] Verify audit completion message is displayed.

---

## Password Policy Audit

### Test Cases

- [x] Verify PASS_MAX_DAYS configuration.
- [x] Verify PASS_MIN_DAYS configuration.
- [x] Verify PASS_WARN_AGE configuration.
- [x] Verify password hashing algorithm detection.
- [x] Verify expired password detection.
- [x] Verify account lockout policy detection.
- [x] Verify audit completion message is displayed.

---

## Large File Finder Utility

### Test Cases

- [x] Verify user is prompted for a minimum file size.
- [x] Verify empty input is handled correctly.
- [x] Verify files larger than the specified size are listed.
- [x] Verify file permissions, owner, size and path are displayed.
- [x] Verify success message is shown when no matching files are found.
- [x] Verify utility completion message is displayed.

---

## Boot History Utility

### Test Cases

- [x] Verify availability of the `last` command.
- [x] Verify recent boot history is displayed.
- [x] Verify handling when no boot history exists.
- [x] Verify utility completion message is displayed.

---

## Main Menu

### Test Cases

- [x] Verify each menu option launches the correct module.
- [x] Verify Full Security Audit executes all audit modules.
- [x] Verify System Utilities menu opens correctly.
- [x] Verify invalid menu options are handled gracefully.
- [x] Verify Exit option terminates the application successfully.
