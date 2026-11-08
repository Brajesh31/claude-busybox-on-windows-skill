---
name: busybox-on-windows
description: Use a Win32 build of BusyBox to run common UNIX command-line utilities on Windows. Use when a Windows task needs tools such as grep, sed, awk, find, sort, head, tail, or other BusyBox applets, especially when WSL or a full Unix-like environment is unavailable.
license: MIT
---

# BusyBox on Windows

BusyBox packages many common Unix command-line utilities into one executable. On Windows, the Win32 builds published by [Frippery](https://frippery.org/busybox/) can provide a lightweight set of familiar command-line tools without installing WSL.

## Scope and platform check

- Use this skill only on Windows.
- If the current environment is Linux, macOS, WSL, or another Unix-like system, stop. Use the native tools available there instead.
- Do not assume that every GNU utility or option is implemented. BusyBox applets can differ from GNU, BSD, and Windows commands.
- Do not download or execute a binary without the user's authorization when the task or environment requires confirmation.

## When to use

Use this skill when the user:
- Needs common Unix-style text, file, or stream utilities in Windows PowerShell or Command Prompt.
- Wants to run a BusyBox applet without installing WSL.
- Needs help selecting the correct Windows BusyBox build for x86, x64, or ARM64.
- Needs to troubleshoot a missing executable, unsupported applet, or command invocation issue.

Do not use it to:
- Replace PowerShell or Windows-native commands when those are the better fit.
- Run Linux ELF binaries or Linux-only software.
- Claim full POSIX, GNU coreutils, or shell compatibility.
- Bypass Windows security controls, application restrictions, or execution policy.

## Workflow

### 1. Check the environment

Confirm that the host is Windows before proceeding. To inspect the system from PowerShell:

```powershell
Get-CimInstance -ClassName Win32_OperatingSystem |
  Select-Object Caption, Version, OSArchitecture

Get-CimInstance -ClassName Win32_Processor |
  Select-Object Name, NumberOfCores, MaxClockSpeed
```

For a concise report, run:

```powershell
.\scripts\get-windows-system-info.ps1
```

### 2. Check whether BusyBox is already available

Look for `busybox.exe` beside the project or in a known tools directory:

```powershell
Test-Path .\busybox.exe
Get-Command busybox.exe -ErrorAction SilentlyContinue
```

If it exists, inspect it before downloading another copy:

```powershell
.\busybox.exe --help
.\busybox.exe --list
```

### 3. Select and obtain the matching build

The Frippery distribution provides separate builds. Choose the build that matches the Windows machine:

| Build | Intended target |
| --- | --- |
| `x86-ansi` | 32-bit x86 Windows |
| `x64-ansi` | 64-bit x86 Windows |
| `x64-unicode` | 64-bit x86 Windows with Unicode support |
| `arm64-unicode` | 64-bit ARM Windows with Unicode support |

The installer script downloads only when explicitly run. Review its source and the publisher's download page first:

```powershell
Get-Content .\scripts\install-busybox.ps1
```

Example for 64-bit x86 Unicode:

```powershell
.\scripts\install-busybox.ps1 -Architecture x64-unicode -DestinationPath .\tools\busybox.exe
```

The script does not silently overwrite an existing destination. Add `-Force` only when replacement is intentional.

Official distribution information: https://frippery.org/busybox/

### 4. Run applets

BusyBox uses a single executable. Invoke an applet by placing its name after the executable:

```powershell
.\tools\busybox.exe ls -la
.\tools\busybox.exe grep -n "TODO" .\README.md
.\tools\busybox.exe find . -name "*.md"
.\tools\busybox.exe sed -n "1,20p" .\README.md
.\tools\busybox.exe sort .\names.txt
```

List the applets included in the downloaded build:

```powershell
.\tools\busybox.exe --list
```

Check an applet's own help before relying on a particular option:

```powershell
.\tools\busybox.exe grep --help
```

### 5. Run from another working directory

Use an absolute path to the executable if the current directory is elsewhere:

```powershell
$BusyBox = (Resolve-Path .\tools\busybox.exe).Path
& $BusyBox grep -n "pattern" "C:\work\project\input.txt"
```

In PowerShell, use the call operator `&` when invoking an executable whose path is stored in a variable.

### 6. Handle output and exit codes

BusyBox is a native executable, not a PowerShell cmdlet. PowerShell pipelines and object semantics do not automatically apply to its output. Treat its output as text and check `$LASTEXITCODE` after execution:

```powershell
.\tools\busybox.exe grep -n "needle" .\input.txt
if ($LASTEXITCODE -ne 0) {
    Write-Error "BusyBox grep exited with code $LASTEXITCODE"
}
```

For applet-specific syntax, consult the applet help and the BusyBox documentation.

## Safety and reliability

- Download only from the publisher's documented distribution location: https://frippery.org/busybox/.
- Review the downloaded executable and follow your organization's malware-scanning and software-approval process before running it.
- The installer script does not claim to verify a publisher checksum or digital signature. Do not infer authenticity from a successful download.
- Do not run downloaded binaries with elevated privileges unless the task genuinely requires it and the user authorizes it.
- Avoid putting downloaded executables in source control. The repository's `.gitignore` excludes common BusyBox binary filenames.
- Do not pipe untrusted files or network responses into shell commands.
- Confirm applet availability with `--list`; not every build contains every expected command.

## Supporting resources

- [Command usage reference](references/command-usage.md)
- [Troubleshooting guide](docs/troubleshooting.md)
- [Windows system information script](scripts/get-windows-system-info.ps1)
- [BusyBox installer script](scripts/install-busybox.ps1)

## Upstream references

- Frippery Windows builds: https://frippery.org/busybox/
- BusyBox project: https://busybox.net/
- Upstream skill source: https://github.com/sickn33/antigravity-awesome-skills
