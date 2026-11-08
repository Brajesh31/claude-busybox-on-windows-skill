# BusyBox Command Usage Reference

BusyBox is a multi-call executable. The command name follows the executable path.

## Discover available applets

Not every BusyBox build includes every applet. Always check the binary you actually downloaded:

```powershell
.\tools\busybox.exe --list
.\tools\busybox.exe --help
```

Check individual applet options:

```powershell
.\tools\busybox.exe grep --help
.\tools\busybox.exe sed --help
```

## Common examples

| Task | PowerShell invocation |
| --- | --- |
| List files | ` .\tools\busybox.exe ls -la ` |
| Search text | ` .\tools\busybox.exe grep -n "TODO" .\README.md ` |
| Find Markdown files | ` .\tools\busybox.exe find . -name "*.md" ` |
| Print first 20 lines | ` .\tools\busybox.exe head -n 20 .\README.md ` |
| Print last 20 lines | ` .\tools\busybox.exe tail -n 20 .\README.md ` |
| Sort lines | ` .\tools\busybox.exe sort .\names.txt ` |
| Count lines, words, bytes | ` .\tools\busybox.exe wc .\README.md ` |
| Print selected lines | ` .\tools\busybox.exe sed -n "1,20p" .\README.md ` |

The spaces inside the inline code examples are for readability; omit leading and trailing spaces when copying a command.

## Use an executable path stored in a variable

PowerShell requires the call operator when the executable path is stored in a variable:

```powershell
$BusyBox = (Resolve-Path .\tools\busybox.exe).Path
& $BusyBox grep -n "error" "C:\work\logs\application.log"
```

## Working directory

Relative paths are resolved from the process's current working directory, not necessarily the directory containing `busybox.exe`. Use absolute paths when running commands against files elsewhere.

## Pipelines and redirection

BusyBox writes text to standard output and standard error. PowerShell can redirect native process output, but behavior differs between PowerShell versions. For portable scripts, test the exact pipeline and quoting behavior in the target PowerShell version.

Example:

```powershell
.\tools\busybox.exe grep -n "warning" .\logs\app.log |
    Set-Content -Path .\logs\warnings.txt
```

## Exit status

After a native executable exits, PowerShell exposes its exit code through `$LASTEXITCODE`:

```powershell
.\tools\busybox.exe grep -n "not-found" .\README.md
$busyBoxExitCode = $LASTEXITCODE

if ($busyBoxExitCode -gt 1) {
    throw "BusyBox grep failed with exit code $busyBoxExitCode"
}
```

For grep, exit code 1 commonly means no lines matched; it is not necessarily an execution error. Check each applet's documented exit behavior.

## Compatibility cautions

- BusyBox applets are not guaranteed to match GNU or BSD implementations.
- Some options, regular-expression features, path conventions, and text encodings may differ.
- Windows paths containing spaces should be quoted.
- Do not assume a shell such as Bash is included. BusyBox applets are invoked through `busybox.exe`; an available shell applet is a separate matter.
