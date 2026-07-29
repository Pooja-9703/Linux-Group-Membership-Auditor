# Large File Finder Utility

## Overview

The **Large File Finder** utility helps administrators identify files that exceed a specified size threshold. Large files can consume significant disk space, affect system performance, and in some cases indicate operational or security-related issues.

This utility prompts the user for a minimum file size and searches the filesystem for files larger than the specified threshold. It displays useful information such as file permissions, ownership, size, and file path to assist in storage management and system maintenance.

Although primarily designed as a system administration tool, reviewing unusually large files can also support incident response and forensic investigations.

---

## Learning Objectives

After reading this document, you should be able to:

- Understand why identifying large files is important.
- Explain how large files impact system performance.
- Recognize situations where large files may indicate security concerns.
- Perform manual searches for large files.
- Understand how the Linux Security Audit Toolkit locates large files.

---

# Purpose

Linux systems continuously generate and store data from applications, services, and users. Over time, files such as logs, backups, archives, and database dumps can consume significant storage space.

The Large File Finder utility helps administrators:

- Monitor disk usage
- Locate storage-intensive files
- Identify unnecessary files
- Troubleshoot storage-related issues
- Support routine system maintenance

---

# Common Use Cases

## Disk Space Investigation

A server unexpectedly runs out of available storage.

The utility quickly identifies the largest files consuming disk space, allowing administrators to determine whether cleanup or storage expansion is required.

---

## Log File Analysis

Application or system logs may grow unexpectedly because of software errors or excessive logging.

Finding unusually large log files helps administrators investigate underlying issues before storage becomes exhausted.

---

## Backup Verification

Administrators can verify the presence and size of backup archives or database dumps to ensure backup operations completed successfully.

---

## Incident Response

During a security investigation, administrators may search for unexpectedly large files that could contain:

- Memory dumps
- Compressed data archives
- Malware payloads
- Unauthorized backups
- Data staged for exfiltration

Although file size alone does not indicate malicious activity, unexpected large files should be reviewed as part of an investigation.

---

# Manual Verification

Search for files larger than **500 MB**:

```bash
find / -type f -size +500M 2>/dev/null
```

Search for files larger than **1 GB**:

```bash
find / -type f -size +1G 2>/dev/null
```

Display the size of a specific file in a human-readable format:

```bash
du -sh /path/to/file
```

Display detailed information about a file:

```bash
stat /path/to/file
```

---

# Commands Used in This Utility

| Command | Purpose |
|---------|---------|
| `find` | Search the filesystem for files larger than the specified size. |
| `stat` | Display detailed file metadata, including permissions, ownership, and timestamps. |
| `du` | Display disk usage for files or directories in a human-readable format. |

---

# How the Toolkit Implements This Utility

High-level workflow:

```text
Prompt User for Minimum File Size

            │

            ▼

Search Filesystem

            │

            ▼

Filter Matching Files

            │

            ▼

Retrieve File Metadata

            │

            ▼

Display Results
```

The utility performs a read-only search using standard Linux commands and does not modify any files or directories.

---

# Example Output

```text
Permissions    Owner     Size      File

-rw-r--r--     root      1.2G      /var/log/application.log

-rw-------     mysql     2.8G      /var/backups/database.sql

-rwxr-xr-x     user      650M      /home/user/archive.tar.gz
```

---

# Best Practices

- Monitor disk usage regularly.
- Archive or remove unnecessary large files.
- Rotate application and system logs.
- Secure backup files containing sensitive information.
- Investigate unexpected file growth.
- Monitor filesystem capacity to prevent storage exhaustion.

---

# References

- `man find`
- `man stat`
- `man du`
- GNU Core Utilities Documentation
- Linux Filesystem Hierarchy Standard (FHS)
