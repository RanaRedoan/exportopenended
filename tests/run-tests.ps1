Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$tmpDir = Join-Path $PSScriptRoot "tmp"

if (-not (Test-Path $tmpDir)) {
    New-Item -ItemType Directory -Path $tmpDir | Out-Null
}

$stataCandidates = @(
    "C:\Program Files\Stata17\Stata\StataMP-64.exe",
    "C:\Program Files\Stata18\Stata\StataMP-64.exe",
    "C:\Program Files\Stata17\Stata\StataSE-64.exe",
    "C:\Program Files\Stata18\Stata\StataSE-64.exe"
)

$stataExe = $stataCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $stataExe) {
    throw "No Stata executable found in the standard install locations."
}

function Invoke-StataRegressionTest {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DoFileName,
        [Parameter(Mandatory = $true)]
        [string[]]$ExpectedPatterns
    )

    $testName = [System.IO.Path]::GetFileNameWithoutExtension($DoFileName)
    $runId = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
    $doFile = Join-Path $PSScriptRoot $DoFileName
    $logPath = Join-Path $tmpDir "${testName}_$runId.log"
    $xlsxPath = Join-Path $tmpDir "${testName}_$runId.xlsx"
    $markerPath = Join-Path $tmpDir "${testName}_$runId.ok"

    $argumentString = "/e do `"$doFile`" `"$logPath`" `"$xlsxPath`" `"$markerPath`""
    $process = Start-Process -FilePath $stataExe -ArgumentList $argumentString -WorkingDirectory $repoRoot -Wait -PassThru

    if ($process.ExitCode -ne 0) {
        throw "Stata regression test '$DoFileName' failed with exit code $($process.ExitCode)."
    }

    if (-not (Test-Path $logPath)) {
        throw "Expected test log was not created at $logPath."
    }

    if (-not (Test-Path $markerPath)) {
        throw "Regression test did not produce the success marker at $markerPath."
    }

    $logContent = Get-Content $logPath -Raw

    foreach ($pattern in $ExpectedPatterns) {
        if ($logContent -notmatch $pattern) {
            throw "Missing expected log output in '$DoFileName': $pattern"
        }
    }

    $unexpectedPatterns = @(
        "already defined",
        "saved as \.dta format"
    )

    foreach ($pattern in $unexpectedPatterns) {
        if ($logContent -match $pattern) {
            throw "Unexpected noisy log output detected in '$DoFileName': $pattern"
        }
    }
}

Invoke-StataRegressionTest -DoFileName "test_exportopenended_filter.do" -ExpectedPatterns @(
    "Exporting q_text\.\.\.",
    "q_text exported\.",
    "Exporting q_mixed\.\.\.",
    "q_mixed exported\.",
    "Export complete\.",
    "Variables exported: 2",
    "Responses exported: 4"
)

Invoke-StataRegressionTest -DoFileName "test_exportopenended_filter_unicode.do" -ExpectedPatterns @(
    "Exporting q_text\.\.\.",
    "q_text exported\.",
    "Exporting q_mixed\.\.\.",
    "q_mixed exported\.",
    "Export complete\.",
    "Variables exported: 2",
    "Responses exported: 4"
)

Invoke-StataRegressionTest -DoFileName "test_exportopenended_exclude_metadata.do" -ExpectedPatterns @(
    "Exporting q_text\.\.\.",
    "Exporting comments\.\.\.",
    "Variables exported: 2",
    "Responses exported: 4"
)

Invoke-StataRegressionTest -DoFileName "test_exportopenended_includeexcluded.do" -ExpectedPatterns @(
    "Exporting UID\.\.\.",
    "Exporting StartTime\.\.\.",
    "Exporting q_text\.\.\.",
    "Variables exported: 3",
    "Responses exported: 6"
)

Write-Host "All regression checks passed."
