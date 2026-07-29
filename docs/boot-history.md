# Boot History Utility

## Overview

The **Boot History** utility displays the system's boot history by retrieving records of previous system startups, shutdowns, and reboots. It provides administrators with a chronological view of system activity, helping them verify uptime, investigate unexpected restarts, and troubleshoot stability issues.

Reviewing boot history is an important part of system administration and incident response, as unexpected reboots may indicate hardware failures, software crashes, configuration changes, or unauthorized activity.

---

## Learning Objectives

After reading this document, you should be able to:

- Understand what boot history is.
- Explain why reviewing boot history is useful.
- Identify situations where boot history assists troubleshooting.
- Perform manual boot history verification.
- Understand how the Linux Security Audit Toolkit retrieves boot history.

---

# Purpose

Every time a Linux system starts or shuts down, the operating system records information about the event. These records provide administrators with a historical timeline of system activity.

Reviewing boot history helps administrators:

- Verify system uptime
- Troubleshoot unexpected reboots
- Identify frequent crashes
- Confirm scheduled maintenance
- Support incident response investigations

---

# Boot Records in Linux

Linux maintains login and boot records in system log files.

One commonly used source is:

```text
/var/log/wtmp
```

The `wtmp` file stores historical information about:

- System boots
- Shutdowns
- User logins
- User logouts
- System reboots

Because this file is stored in a binary format, it is typically viewed using the `last` command rather than opening it directly.

---

# Common Use Cases

## Troubleshooting Unexpected Reboots

A production server restarts unexpectedly during business hours.

Administrators can review the boot history to determine when the reboot occurred and correlate it with system logs or hardware events.

---

## Verifying Scheduled Maintenance

Following planned maintenance, administrators can confirm that the system restarted successfully and returned to normal operation.

---

## System Stability Analysis

Frequent reboots may indicate:

- Hardware failures
- Kernel panics
- Software crashes
- Power interruptions
- Misconfigured services

Reviewing boot history helps identify recurring patterns that may require further investigation.

---

## Incident Response

During a security investigation, boot history can help determine whether a system restarted unexpectedly after suspicious activity.

Although a reboot alone does not indicate malicious activity, correlating boot events with authentication logs and system logs may provide valuable context during an investigation.

---

# Manual Verification

Display previous system boots:

```bash
last reboot
```

Display shutdown history:

```bash
last shutdown
```

Display the complete login and reboot history:

```bash
last
```

View current system uptime:

```bash
uptime
```

Display the current boot time:

```bash
who -b
```

---

# Commands Used in This Utility

| Command | Purpose |
|---------|---------|
| `last` | Display historical boot, shutdown, and login records from the `wtmp` database. |
| `uptime` | Display current system uptime and load information. |
| `who` | Display the current system boot time using the `-b` option. |

---

# How the Toolkit Implements This Utility

High-level workflow:

```text
Read Boot Records

        │

        ▼

Retrieve Boot History

        │

        ▼

Format Output

        │

        ▼

Display Chronological Results
```

The utility retrieves historical boot information using standard Linux utilities and does not modify any system logs or configuration files.

---

# Example Output

```text
reboot   system boot  6.8.0-62-generic  Mon Jul 28 09:15   still running

reboot   system boot  6.8.0-62-generic  Fri Jul 25 18:42   down 2+14:33

reboot   system boot  6.8.0-60-generic  Tue Jul 22 08:10   down 3+10:32
```

---

# Best Practices

- Review boot history after unexpected outages.
- Correlate reboot events with system and application logs.
- Investigate frequent or unexplained system restarts.
- Verify successful reboots following maintenance activities.
- Monitor uptime to identify recurring stability issues.

---

# References

- `man last`
- `man uptime`
- `man who`
- `man wtmp`
- Linux Filesystem Hierarchy Standard (FHS)
- Linux System Administration Documentation
