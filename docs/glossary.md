# Linux Security Glossary

## Overview

This glossary provides brief definitions of common Linux and cybersecurity terms used throughout the Linux Security Audit Toolkit documentation. It serves as a quick reference for readers who may be unfamiliar with Linux administration or security concepts.

---

## A

### ACL (Access Control List)

An extension to the traditional Linux permission model that allows administrators to grant specific permissions to individual users or groups beyond the standard owner, group, and others permissions.

---

## B

### Boot History

A record of previous system startups, shutdowns, and reboots. Boot history helps administrators troubleshoot unexpected restarts and verify system uptime.

---

## C

### chmod

A Linux command used to change file and directory permissions.

Example:

```bash
chmod 755 script.sh
```

---

### chown

A Linux command used to change the owner or group ownership of a file or directory.

Example:

```bash
chown user:group file.txt
```

---

## D

### Disk Usage

The amount of storage space consumed by files and directories on a filesystem.

---

## F

### Filesystem

The method used by an operating system to organize and manage files and directories on storage devices.

Examples include:

- ext4
- XFS
- Btrfs

---

## G

### GID (Group ID)

A unique numeric identifier assigned to a Linux group.

---

### Group

A collection of users that share common permissions and access rights.

---

## H

### Hash

A fixed-length value generated from data using a mathematical algorithm. Passwords are stored as hashes rather than plaintext.

---

## L

### Least Privilege

A security principle stating that users and applications should receive only the permissions necessary to perform their intended tasks.

---

## P

### PAM (Pluggable Authentication Modules)

A framework used by Linux to provide authentication services for applications such as SSH and login.

---

### Password Hash

The encrypted representation of a user's password stored in `/etc/shadow`.

---

### Permission

Rules that determine who can read, write, or execute a file or directory.

---

## R

### Root User

The administrative account with unrestricted access to the Linux system.

---

## S

### SGID (Set Group ID)

A special permission bit that allows an executable to run with the permissions of its group owner. When applied to directories, new files inherit the directory's group ownership.

---

### SSH (Secure Shell)

A secure protocol used for remote administration of Linux systems.

---

### SUID (Set User ID)

A special permission bit that allows an executable to run with the permissions of its owner rather than the user executing it.

---

### sudo

A command that allows authorized users to execute commands with elevated privileges.

Example:

```bash
sudo apt update
```

---

## U

### UID (User ID)

A unique numeric identifier assigned to each Linux user account.

---

### User Account

An identity used to access a Linux system. Each account has its own UID, home directory, shell, and permissions.

---

## W

### World-Writable

A file or directory that grants write permission to all users on the system. Such permissions should be reviewed carefully because they may introduce security risks.

---

### wtmp

A binary log file located at:

```text
/var/log/wtmp
```

It stores historical information about system boots, shutdowns, logins, and logouts.

---

## X

### X11 Forwarding

An SSH feature that allows graphical Linux applications to be displayed on a remote system.

If not required, it is often disabled to reduce the attack surface.

---

## References

- `man chmod`
- `man chown`
- `man sudo`
- `man ssh`
- `man shadow`
- `man passwd`
- `man last`
- Linux Filesystem Hierarchy Standard (FHS)
- Red Hat Enterprise Linux Documentation
