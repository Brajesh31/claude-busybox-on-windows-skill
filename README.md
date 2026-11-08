# BusyBox on Windows

A practical Claude skill for using a Win32 build of [BusyBox](https://busybox.net/) to run common Unix-style command-line utilities on Windows.

BusyBox combines many small command-line tools into one executable. The Windows builds documented here are useful when a task needs familiar applets such as `grep`, `sed`, `awk`, `find`, `sort`, or `head`, but installing WSL or a full Unix-like environment is unnecessary.

## Features

- Detect and inspect the Windows environment before selecting a binary.
- Explain the available x86, x64, and ARM64 Frippery builds.
- Provide an optional PowerShell installer with explicit architecture selection.
- Prevent accidental replacement of an existing executable unless `-Force` is supplied.
- Demonstrate applet invocation from PowerShell.
- Explain how to list available applets and inspect applet-specific help.
- Include troubleshooting guidance for common Windows execution problems.

## Scope

This skill is for **Windows only**. It does not install WSL, provide a full POSIX environment, or guarantee GNU utility compatibility. BusyBox applets and options vary by build.

## Repository contents

```text
.
├── SKILL.md
├── README.md
├── LICENSE
├── .gitignore
├── docs/
│   └── troubleshooting.md
├── references/
│   └── command-usage.md
└── scripts/
    ├── get-windows-system-info.ps1
    └── install-busybox.ps1
```

## Installation

### 1. Review the publisher and build

The scripts download a Windows executable from the Frippery BusyBox distribution page:

https://frippery.org/busybox/

Review the publisher's current information and your organization's software policies before downloading or running a binary. This repository does not bundle `busybox.exe`.

### 2. Inspect your Windows architecture

Run in PowerShell:

```powershell
.\scripts\get-windows-system-info.ps1
```

### 3. Download a selected build

For 64-bit x86 Windows with Unicode support:

```powershell
.\scripts\install-busybox.ps1 -Architecture x64-unicode -DestinationPath .\tools\busybox.exe
```

Supported values:

- `x86-ansi`
- `x64-ansi`
- `x64-unicode`
- `arm64-unicode`

The script creates the destination directory if needed. It refuses to overwrite an existing destination unless `-Force` is supplied.

### 4. Verify and use BusyBox

```powershell
.\tools\busybox.exe --help
.\tools\busybox.exe --list
.\tools\busybox.exe ls -la
.\tools\busybox.exe grep -n "TODO" .\README.md
```

See [the command usage reference](references/command-usage.md) for more examples.

## Scripts

### `scripts/get-windows-system-info.ps1`

Read-only system inventory for Windows. Reports OS details, OS architecture, PowerShell version, and processor information. It does not download or change anything.

Run:

```powershell
.\scripts\get-windows-system-info.ps1
```

### `scripts/install-busybox.ps1`

Downloads the explicitly selected BusyBox build from Frippery. It writes to a temporary file first, checks that the download is non-empty, then moves it to the destination. It does not silently overwrite an existing file.

Run:

```powershell
.\scripts\install-busybox.ps1 -Architecture x64-unicode -DestinationPath .\tools\busybox.exe
```

Replace an existing file only when intentional:

```powershell
.\scripts\install-busybox.ps1 -Architecture x64-unicode -DestinationPath .\tools\busybox.exe -Force
```

**Integrity limitation:** the script does not validate a cryptographic checksum or Authenticode signature. A successful download is not proof that a binary is authentic. Review and scan the binary before execution.

## Dependencies

- Windows.
- Windows PowerShell 5.1 or PowerShell 7+ for the helper scripts.
- Network access to `https://frippery.org` only when downloading BusyBox.
- No third-party PowerShell modules are required.

BusyBox itself is a separately downloaded native executable. It is not a dependency of the system-information script.

## Testing and validation

The PowerShell scripts are intended to run on Windows. This repository does not claim that they have been executed on a Windows host as part of publication.

Basic static checks can be performed by reviewing the scripts and parsing them with PowerShell:

```powershell
$files = Get-ChildItem .\scripts\*.ps1
foreach ($file in $files) {
    $tokens = $null
    $errors = $null
    [System.Management.Automation.Language.Parser]::ParseFile(
        $file.FullName,
        [ref]$tokens,
        [ref]$errors
    ) | Out-Null

    if ($errors.Count -gt 0) {
        $errors | ForEach-Object { Write-Error $_ }
        throw "Syntax errors found in $($file.Name)"
    }
}
```

No automated integration test downloads or executes a third-party binary.

## Troubleshooting

See [docs/troubleshooting.md](docs/troubleshooting.md) for architecture mismatches, execution failures, missing applets, path handling, and download issues.

## References

- [Frippery BusyBox for Windows](https://frippery.org/busybox/)
- [BusyBox official project](https://busybox.net/)
- [BusyBox documentation](https://busybox.net/downloads/BusyBox.html)
- [PowerShell documentation](https://learn.microsoft.com/powershell/)

## Attribution

This skill is based on the community BusyBox-on-Windows skill published in [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills). The upstream skill identifies its license as MIT. This repository expands the instructions with independently authored documentation and PowerShell helper scripts. See [LICENSE](LICENSE).

## License

MIT. See [LICENSE](LICENSE).
