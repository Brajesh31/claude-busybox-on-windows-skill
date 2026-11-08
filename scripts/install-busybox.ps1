[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('x86-ansi', 'x64-ansi', 'x64-unicode', 'arm64-unicode')]
    [string]$Architecture,

    [Parameter()]
    [string]$DestinationPath = (Join-Path -Path (Get-Location).Path -ChildPath 'busybox.exe'),

    [Parameter()]
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$downloadUrls = @{
    'x86-ansi'      = 'https://frippery.org/files/busybox/busybox.exe'
    'x64-ansi'      = 'https://frippery.org/files/busybox/busybox64.exe'
    'x64-unicode'   = 'https://frippery.org/files/busybox/busybox64u.exe'
    'arm64-unicode' = 'https://frippery.org/files/busybox/busybox64a.exe'
}

$resolvedDestination = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($DestinationPath)
$destinationDirectory = Split-Path -Path $resolvedDestination -Parent

if ([string]::IsNullOrWhiteSpace($destinationDirectory)) {
    throw "Could not determine a destination directory for '$DestinationPath'."
}

if ((Test-Path -LiteralPath $resolvedDestination) -and -not $Force) {
    throw "Destination already exists: $resolvedDestination. Use -Force to replace it intentionally."
}

if (-not (Test-Path -LiteralPath $destinationDirectory -PathType Container)) {
    New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
}

$uri = $downloadUrls[$Architecture]
$tempPath = Join-Path -Path $destinationDirectory -ChildPath ([System.IO.Path]::GetRandomFileName() + '.download')

try {
    if ($PSCmdlet.ShouldProcess($resolvedDestination, "Download BusyBox build '$Architecture' from $uri")) {
        Invoke-WebRequest -Uri $uri -OutFile $tempPath

        if (-not (Test-Path -LiteralPath $tempPath -PathType Leaf)) {
            throw 'The download did not produce a file.'
        }

        $download = Get-Item -LiteralPath $tempPath
        if ($download.Length -le 0) {
            throw 'The downloaded file is empty.'
        }

        if ((Test-Path -LiteralPath $resolvedDestination) -and -not $Force) {
            throw "Destination appeared during download: $resolvedDestination. Refusing to overwrite it."
        }

        Move-Item -LiteralPath $tempPath -Destination $resolvedDestination -Force:$Force
        Write-Output "Downloaded BusyBox ($Architecture) to $resolvedDestination"
        Write-Warning 'No checksum or digital-signature validation was performed. Review and scan the executable before running it.'
    }
}
finally {
    if (Test-Path -LiteralPath $tempPath) {
        Remove-Item -LiteralPath $tempPath -Force
    }
}
