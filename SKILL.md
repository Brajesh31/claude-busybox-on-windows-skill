---
name: busybox-on-windows
description: Plan, install, configure, and troubleshoot BusyBox on Windows environments.
---

# BusyBox on Windows

## Purpose
Help users choose and operate BusyBox on Windows for portable Unix-like command-line utilities. Treat Windows version, shell, architecture, and installation method as explicit inputs.

## Workflow
1. Identify the environment: Windows 10/11 or Server, PowerShell or CMD, x64 or ARM64, and whether WSL is available.
2. Clarify the goal: a few utilities, a portable shell, scripting compatibility, or a CI runner.
3. Prefer the least invasive installation. Explain the difference between a standalone BusyBox executable, a package manager, and WSL.
4. Verify the executable path and version before relying on commands.
5. Check command availability with `busybox --list`; invoke applets as `busybox <applet> ...` when no applet symlink exists.
6. Explain Windows path translation and quoting when mixing PowerShell, CMD, and BusyBox syntax.
7. Validate the result with a harmless command and show how to undo PATH changes or remove the installation.

## Safety and reliability
- Never recommend downloading executables from an unverified mirror.
- Do not tell users to overwrite system binaries or replace Windows utilities.
- Distinguish BusyBox applet behavior from GNU coreutils behavior; flags are not always interchangeable.
- Avoid assuming that Unix permissions, symlinks, pipes, or signal behavior match Linux exactly.
- For scripts that depend on Linux semantics, recommend WSL or a Linux CI environment instead of pretending BusyBox on native Windows is identical.

## Troubleshooting checklist
Check file integrity, CPU architecture, execution policy, PATH order, antivirus quarantine, missing DLLs, shell quoting, and whether the required applet was compiled into the binary. Ask for the exact command and full error before guessing.

## Output
Give copy-pasteable PowerShell commands first. State which shell each command belongs to and include a verification and rollback step for system changes.
