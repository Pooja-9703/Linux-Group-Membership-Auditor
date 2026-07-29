# SSH Configuration Audit

## Overview

The **SSH Configuration Audit** module evaluates the configuration of the OpenSSH server to identify settings that may weaken the security of remote administration. It examines the SSH service status, authentication methods, root login policy, X11 forwarding, authentication limits, and the configured listening port.

Secure Shell (SSH) is the standard protocol for remote administration on Linux systems. Since SSH often provides direct access to production servers, securing its configuration is essential to reduce the risk of unauthorized access and brute-force attacks.

---

## Learning Objectives

After reading this document, you should be able to:

- Understand the purpose of SSH.
- Explain common SSH authentication methods.
- Understand why root login should be restricted.
- Explain the security impact of various SSH configuration options.
- Perform manual SSH configuration verification.
- Understand how the Linux Security Audit Toolkit evaluates SSH security.

---

# What is SSH?

**Secure Shell (SSH)** is a cryptographic network protocol that allows users to securely access and manage remote systems.

Unlike older protocols such as Telnet, SSH encrypts all communication between the client and server, protecting credentials and data from interception.

Common uses include:

- Remote system administration
- Secure file transfer (SCP/SFTP)
- Remote command execution
- Port forwarding
- Secure tunneling

---

# SSH Configuration File

The primary OpenSSH server configuration file is:

```text
/etc/ssh/sshd_config
```

This file defines how the SSH server behaves, including authentication methods, listening ports, and security restrictions.

Changes to this file typically require restarting or reloading the SSH service.

---

# Authentication Methods

SSH supports multiple authentication methods.

### Password Authentication

Users authenticate by providing their account password.

Advantages:

- Easy to configure

Disadvantages:

- Vulnerable to brute-force attacks
- Susceptible to password reuse
- Dependent on password strength

---

### Public Key Authentication

Users authenticate using a cryptographic key pair.

```text
Private Key
        │
        ▼
SSH Client
        │
Encrypted Authentication
        │
        ▼
SSH Server
        │
        ▼
Authorized Public Key
```

Advantages:

- Strong authentication
- Resistant to password guessing attacks
- Widely recommended for server administration

---

# Security Checks Performed

| Check | Why It Matters | Risk |
|--------|----------------|------|
| SSH service status | Ensures the SSH server is available and manageable. | INFO |
| PermitRootLogin | Direct root login increases attack surface. | High |
| PasswordAuthentication | Password logins may enable brute-force attacks. | Medium |
| PubkeyAuthentication | Stronger authentication method. | Medium |
| PermitEmptyPasswords | Empty passwords allow unauthorized access. | High |
| X11 Forwarding | May increase attack surface if unnecessary. | Medium |
| MaxAuthTries | Limits password guessing attempts. | Medium |
| SSH Port | Alternative ports reduce automated scanning noise (not a security control by themselves). | Low |

---

## 1. SSH Service Status

The toolkit verifies whether the OpenSSH service is installed and running.

**Purpose**

- Confirm SSH availability.
- Verify remote administration capability.
- Detect stopped or missing SSH services.

---

## 2. PermitRootLogin

The toolkit checks the value of:

```text
PermitRootLogin
```

Allowing direct root logins means attackers only need to compromise one privileged account.

Disabling direct root login encourages administrators to authenticate as standard users before using `sudo`.

---

## 3. PasswordAuthentication

The toolkit checks whether password-based authentication is enabled.

Although password authentication is common, many organizations prefer public key authentication because it significantly reduces the effectiveness of brute-force attacks.

---

## 4. PubkeyAuthentication

The toolkit verifies whether public key authentication is enabled.

Public key authentication is considered more secure than password authentication and is widely recommended for production environments.

---

## 5. PermitEmptyPasswords

The toolkit checks whether accounts with empty passwords are allowed to authenticate.

This option should normally remain disabled.

---

## 6. X11 Forwarding

The toolkit checks whether X11 forwarding is enabled.

Unless graphical applications must be forwarded remotely, administrators often disable this feature to reduce unnecessary functionality and minimize the attack surface.

---

## 7. MaxAuthTries

The toolkit reviews the maximum number of failed authentication attempts permitted before disconnecting the client.

Restricting authentication attempts helps slow password guessing attacks.

---

## 8. SSH Listening Port

The toolkit identifies the configured SSH port.

Although changing the default port from **22** may reduce automated scanning noise, it should **not** be considered a replacement for proper authentication, firewall rules, or intrusion prevention.

---

# Common Attack Scenarios

## Brute-Force Password Attack

An attacker repeatedly attempts different passwords against exposed SSH services.

Weak passwords combined with unlimited authentication attempts may eventually result in unauthorized access.

---

## Direct Root Login

If root login is permitted and the root password is compromised, an attacker immediately gains unrestricted control over the system.

---

## Empty Password Authentication

A misconfigured SSH server permits accounts with empty passwords.

An attacker can authenticate without providing credentials.

---

## Public Key Theft

If a user's private SSH key is stolen and is not protected with a passphrase, an attacker may authenticate without knowing the account password.

---

# Manual Verification

### Check SSH service status

```bash
systemctl status ssh
```

or

```bash
systemctl status sshd
```

---

### View SSH configuration

```bash
sudo cat /etc/ssh/sshd_config
```

---

### Check root login policy

```bash
grep "^PermitRootLogin" /etc/ssh/sshd_config
```

---

### Check password authentication

```bash
grep "^PasswordAuthentication" /etc/ssh/sshd_config
```

---

### Check public key authentication

```bash
grep "^PubkeyAuthentication" /etc/ssh/sshd_config
```

---

### Check empty password policy

```bash
grep "^PermitEmptyPasswords" /etc/ssh/sshd_config
```

---

### Check X11 forwarding

```bash
grep "^X11Forwarding" /etc/ssh/sshd_config
```

---

### Check authentication attempts

```bash
grep "^MaxAuthTries" /etc/ssh/sshd_config
```

---

### Check configured SSH port

```bash
grep "^Port" /etc/ssh/sshd_config
```

---

# Commands Used in This Audit

| Command | Purpose |
|---------|---------|
| `systemctl` | Check whether the SSH service is installed and running. |
| `grep` | Retrieve configuration directives from `sshd_config`. |
| `awk` | Process configuration output where required. |

---

# How the Toolkit Implements These Checks

High-level workflow:

```text
Check SSH Service

        │

        ▼

Read sshd_config

        │

        ▼

Verify Authentication Settings

        │

        ▼

Verify Root Login Policy

        │

        ▼

Review Additional Security Options

        │

        ▼

Generate Findings
```

The toolkit performs read-only inspections of the SSH configuration and does not modify any server settings.

---

# Expected Findings

A securely configured SSH server should typically have:

- SSH service running (if remote administration is required).
- Root login restricted.
- Public key authentication enabled.
- Empty password authentication disabled.
- Reasonable authentication attempt limits.
- Only required SSH features enabled.

---

# Severity Levels

| Severity | Meaning |
|----------|---------|
| **INFO** | Informational finding requiring no action. |
| **LOW** | Minor configuration issue. |
| **MEDIUM** | Configuration should be reviewed. |
| **HIGH** | Significant security risk requiring prompt attention. |

---

# Security Best Practices

- Prefer public key authentication over passwords.
- Disable direct root login where practical.
- Disable empty password authentication.
- Limit failed authentication attempts.
- Disable unnecessary SSH features.
- Keep OpenSSH updated with security patches.
- Monitor SSH authentication logs for suspicious activity.

---

# References

- `man ssh`
- `man sshd`
- `man sshd_config`
- OpenSSH Documentation
- CIS Benchmarks for Linux
- NIST SP 800-53 IA-2 (Identification and Authentication)
- Red Hat Enterprise Linux Security Guide
- Ubuntu Server Guide
