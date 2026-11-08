# claude-busybox-on-windows-skill

A Claude Code skill for installing, configuring, and using BusyBox utilities on Windows without requiring a full Linux environment.

## Overview

BusyBox packages many familiar Unix-style command-line utilities into a compact executable. On Windows, it can provide commands such as grep, sed, awk, find, sort, head, and tail for workflows where those tools are useful.

This skill focuses on Windows-specific setup, command invocation, applet availability, and troubleshooting.

## When to Use It

Use this skill when:

- A Windows task needs common Unix-style text or file utilities.
- You want BusyBox commands in PowerShell or Command Prompt.
- WSL is unavailable or unnecessary for the task.
- A command fails because an applet or executable is missing.
- You need to choose a suitable build for x86, x64, or ARM64.

Do not use this skill on Linux, macOS, or WSL when native tools are already available.

## Installation

Clone the skill into the Claude Code skills directory:

```powershell
git clone https://github.com/Brajesh31/claude-busybox-on-windows-skill.git "$env:USERPROFILE\.claude\skills\busybox-on-windows"
```

The BusyBox executable is a separate runtime component. Follow the installation instructions in `SKILL.md` and verify the selected binary before use.

## Usage

Invoke the skill for Windows command-line tasks:

```text
/busybox-on-windows
```

Include the Windows version, shell, command, error output, and target architecture.

## Typical Workflow

1. Confirm that the environment is Windows.
2. Determine whether BusyBox is actually needed.
3. Identify the system architecture.
4. Select an appropriate Windows build.
5. Verify the downloaded executable.
6. Configure the executable path.
7. Check which applets are included.
8. Test the required command with a harmless input.
9. Integrate it into scripts only after confirming behavior.

## Command Compatibility

BusyBox applets do not always support every option available in GNU or BSD utilities. Check the applet's help output before copying complex command lines from a Linux environment.

Examples of common utilities include:

| Utility | Typical use |
|---|---|
| `grep` | Search text |
| `sed` | Transform text streams |
| `awk` | Process structured text |
| `find` | Locate files |
| `sort` | Sort lines |
| `head` / `tail` | Inspect output ranges |

## Troubleshooting

- **Command not found:** Check the executable path and PATH configuration.
- **Applet unavailable:** Confirm the build includes the required applet.
- **Unsupported option:** Check BusyBox-specific help and adjust the command.
- **Architecture mismatch:** Verify the binary matches the Windows system architecture.
- **Execution blocked:** Review file origin, security controls, and permissions.

## Repository Contents

- `SKILL.md`: Main Windows BusyBox instructions.
- `docs/`: Troubleshooting and command guidance.
- `scripts/`: Installation and system information helpers.
- `README.md`: Setup and usage documentation.

## Safety Notes

Do not download or execute binaries without authorization. Review scripts before running them, and avoid using elevated privileges unless a task requires them.

## Practical Principle

BusyBox is a lightweight compatibility tool, not a complete Linux environment. Use PowerShell or native Windows tools when they are the safer and more reliable option.
