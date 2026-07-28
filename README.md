# Linux Security Audit Toolkit

A modular Bash-based Linux Security Audit Toolkit that performs automated security checks on Linux systems. The toolkit helps administrators and security enthusiasts identify common security misconfigurations, review user and privilege settings, inspect filesystem permissions, and analyse SSH and password policies through an easy-to-use menu-driven interface.

---

## Features

### Security Audits

- User Audit
  - List all system users
  - Detect multiple UID 0 accounts
  - Detect duplicate UIDs
  - Identify passwordless accounts

- Group Audit
  - List system groups
  - Display group memberships
  - Detect duplicate GIDs
  - Detect multiple GID 0 groups

- Privilege Audit
  - Display users with sudo privileges
  - Detect world-writable files
  - List SUID binaries
  - List SGID binaries

- Filesystem Security Audit
  - Detect world-writable directories
  - Detect world-writable files
  - Find orphaned files
  - Find orphaned groups
  - Detect hidden files in home directories
  - Display permissions of critical system files

- SSH Configuration Audit
  - Check SSH service status
  - Verify PermitRootLogin
  - Verify PasswordAuthentication
  - Verify PubkeyAuthentication
  - Verify PermitEmptyPasswords
  - Check X11 Forwarding
  - Check MaxAuthTries
  - Display configured SSH port

- Password Policy Audit
  - Password expiration policy
  - Password warning age
  - Password hash algorithm
  - Expired password detection
  - Account lockout policy

---

## Utilities

- Large File Finder
- Boot History Viewer

---

## Project Structure

```
Linux-Security-Audit-Toolkit/
│
├── audits/
│   ├── user_audit.sh
│   ├── group_audit.sh
│   ├── privilege_audit.sh
│   ├── filesystem_audit.sh
│   ├── ssh_audit.sh
│   └── password_policy_audit.sh
│
├── core/
│   └── report_generator.sh
│
├── utilities/
│   ├── large_file_finder_utility.sh
│   └── boot_history_utility.sh
│
├── common.sh
├── main.sh
└── README.md
```

---

## Requirements

- Linux Operating System
- Bash Shell
- Standard Linux utilities

The toolkit uses common Linux commands including:

- awk
- cut
- find
- grep
- stat
- systemctl
- last
- chage
- getent

Some security checks require root privileges.

---

## Installation

Clone the repository:

```bash
git clone https://github.com/your-username/Linux-Security-Audit-Toolkit.git

cd Linux-Security-Audit-Toolkit
```

Make the scripts executable:

```bash
chmod +x main.sh
chmod +x common.sh
chmod +x audits/*.sh
chmod +x utilities/*.sh
```

---

## Running the Toolkit

Run as a normal user:

```bash
./main.sh
```

For complete security checks:

```bash
sudo ./main.sh
```

---

## Main Menu

```
1. User Audit
2. Group Audit
3. Privilege Audit
4. Filesystem Security Audit
5. SSH Configuration Audit
6. Password Policy Audit
7. Full Security Audit
8. System Utilities
9. Exit
```

---

## Sample Output

```
============================================================
                Linux Security Audit Toolkit
============================================================

[INFO] Total Users : 28

[SUCCESS] Only root has UID 0.

[HIGH]

Finding:
  World writable files were detected.

Recommendation:
  Review the files below and remove unnecessary write permissions.
```

---

## Future Improvements

- HTML report generation
- PDF report export
- Cron audit
- Firewall audit
- Docker security audit
- Log analysis
- CIS Benchmark checks

---

## Author

**Pooja Dheeraj Sindhu**

---

## License

This project is intended for educational and learning purposes.
