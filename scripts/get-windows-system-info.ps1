[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

if (-not [System.OperatingSystem]::IsWindows()) {
    throw 'This script is intended to run on Windows.'
}

$os = Get-CimInstance -ClassName Win32_OperatingSystem
$processors = @(Get-CimInstance -ClassName Win32_Processor)

[pscustomobject]@{
    OperatingSystem       = $os.Caption
    OSVersion             = $os.Version
    OSArchitecture        = $os.OSArchitecture
    PowerShellVersion     = $PSVersionTable.PSVersion.ToString()
    ProcessIs64Bit        = [Environment]::Is64BitProcess
    OperatingSystemIs64Bit = [Environment]::Is64BitOperatingSystem
    ProcessorNames        = ($processors | ForEach-Object { $_.Name }) -join '; '
    LogicalProcessorCount = ($processors | Measure-Object -Property NumberOfLogicalProcessors -Sum).Sum
    ComputerName          = $env:COMPUTERNAME
}
