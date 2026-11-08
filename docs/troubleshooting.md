# Troubleshooting BusyBox on Windows

## The operating system is not Windows

This skill and its Windows binaries are intended for Windows. On Linux, macOS, or inside WSL, use the native utilities instead.

## The executable will not start

1. Confirm that the downloaded build matches the machine architecture.
2. Check that the file exists and has a non-zero size.
3. Review Windows security notifications and your organization's application-control policy.
4. Scan the executable using your approved security tools.
5. Re-download only from the documented publisher location if the file is incomplete or corrupted.

Do not disable antivirus, SmartScreen, AppLocker, or other security controls to make the binary run.

## Architecture selection is unclear

Run:

```powershell
.\scripts\get-windows-system-info.ps1
```

Use the reported OS architecture to choose a matching build. Do not infer ARM64 support solely from the fact that Windows is 64-bit. If the device reports an architecture not listed by the publisher, stop and check the current Frippery documentation.

## PowerShell says the script cannot be run

The helper scripts are PowerShell scripts. Run them from PowerShell, not directly from Command Prompt:

```powershell
powershell.exe -NoProfile -File .\scripts\get-windows-system-info.ps1
```

If execution policy blocks a script, follow your organization's policy. Do not change machine-wide execution policy merely to run this repository's helper scripts.

## The download fails

- Confirm that the machine can reach `https://frippery.org`.
- Check proxy, firewall, and TLS configuration with your administrator.
- Retry after checking the publisher's current download page.
- Inspect any downloaded file before execution.

The installer does not retry automatically, validate a checksum, or verify an Authenticode signature. A non-empty file is only a basic download check.

## An applet is not found

List applets available in the exact executable:

```powershell
.\tools\busybox.exe --list
```

If the applet is absent, use another approved tool or a BusyBox build that documents support for it. Do not assume all builds contain identical applets.

## An option behaves differently from GNU or BSD

BusyBox provides compact implementations. Read the applet-specific help:

```powershell
.\tools\busybox.exe APPLET --help
```

Simplify the command and verify each option against BusyBox documentation. Rewrite the command for BusyBox rather than assuming GNU compatibility.

## Paths with spaces or backslashes fail

Quote Windows paths:

```powershell
.\tools\busybox.exe ls "C:\Program Files"
```

When invoking from a variable, use PowerShell's call operator:

```powershell
$BusyBox = (Resolve-Path .\tools\busybox.exe).Path
& $BusyBox ls "C:\Program Files"
```

## The installer reports that the destination exists

This is intentional protection against accidental replacement. Choose a different destination or explicitly confirm replacement with `-Force`:

```powershell
.\scripts\install-busybox.ps1 -Architecture x64-unicode -DestinationPath .\tools\busybox.exe -Force
```

## PowerShell pipeline output is unexpected

BusyBox is a native process, not a PowerShell cmdlet. Its output is text, and native pipeline behavior can vary between PowerShell versions. Test the command in the target environment and inspect `$LASTEXITCODE` after execution.

## Further help

- Frippery builds: https://frippery.org/busybox/
- BusyBox project: https://busybox.net/
- PowerShell documentation: https://learn.microsoft.com/powershell/
