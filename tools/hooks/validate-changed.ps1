<#
.SYNOPSIS
    Fast syntax gate for files an agent just edited.

.DESCRIPTION
    Intended as a Claude Code PostToolUse hook for Edit|Write. Reads the hook payload
    from stdin, picks the edited file and validates it cheaply:

      *.json  - must parse as JSON
      *.yaml  - must parse as YAML if a parser is available, otherwise tab/indent smell test
      *.yml
      *.ps1   - must parse as PowerShell

    Anything else is ignored. This is a syntax gate, not the schema validator:
    schema validation lives in sdk/Validator and runs in CI.

.OUTPUTS
    Exit 0 - nothing to check, or the file is fine.
    Exit 2 - the file is broken; the message on stderr goes back to the agent.

.NOTES
    Can also be run directly on a path, which is how you test it:
        pwsh -NoProfile -File ./tools/hooks/validate-changed.ps1 -Path ./content/pack.json
#>

[CmdletBinding()]
param(
    # Validate this file instead of reading the hook payload from stdin.
    [string]$Path
)

$ErrorActionPreference = 'Stop'

# Messages go back to an agent and into logs: English and UTF-8 regardless of the OS locale.
[System.Threading.Thread]::CurrentThread.CurrentUICulture = 'en-US'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Get-EditedPath {
    if ($Path) { return $Path }

    # The hook payload arrives on stdin as JSON. No payload means nothing to do.
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { return $null }

    try {
        $payload = $raw | ConvertFrom-Json
    } catch {
        # A payload we cannot read is not the edited file's fault.
        return $null
    }

    foreach ($candidate in @(
            $payload.tool_input.file_path,
            $payload.tool_input.filePath,
            $payload.tool_response.filePath)) {
        if ($candidate) { return [string]$candidate }
    }

    return $null
}

function Test-Json {
    param([string]$File)
    # ConvertFrom-Json accepts trailing commas and comments, which every other JSON reader
    # (the validator, CI, the launcher) rejects. System.Text.Json is strict.
    try {
        $text = Get-Content -LiteralPath $File -Raw -Encoding utf8
        [System.Text.Json.JsonDocument]::Parse($text).Dispose()
        return $null
    } catch {
        $inner = $_.Exception.InnerException
        if ($inner) { return $inner.Message }
        return $_.Exception.Message
    }
}

function Test-Yaml {
    param([string]$File)

    $text = Get-Content -LiteralPath $File -Raw -Encoding utf8

    # powershell-yaml is optional; without it fall back to the one mistake that
    # actually happens in hand-written YAML.
    if (Get-Module -ListAvailable -Name 'powershell-yaml') {
        try {
            Import-Module powershell-yaml -ErrorAction Stop
            ConvertFrom-Yaml $text | Out-Null
            return $null
        } catch {
            return $_.Exception.Message
        }
    }

    $lineNumber = 0
    foreach ($line in ($text -split "`r?`n")) {
        $lineNumber++
        if ($line -match '^\t' -or $line -match '^ *\t') {
            return "line ${lineNumber}: YAML does not allow tabs for indentation"
        }
    }
    return $null
}

function Test-PowerShell {
    param([string]$File)

    $errors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($File, [ref]$null, [ref]$errors) | Out-Null
    if ($errors -and $errors.Count -gt 0) {
        return ($errors | ForEach-Object { "line $($_.Extent.StartLineNumber): $($_.Message)" }) -join '; '
    }
    return $null
}

$target = Get-EditedPath
if (-not $target) { exit 0 }
if (-not (Test-Path -LiteralPath $target -PathType Leaf)) { exit 0 }

$problem = switch ([System.IO.Path]::GetExtension($target).ToLowerInvariant()) {
    '.json' { Test-Json        -File $target }
    '.yaml' { Test-Yaml        -File $target }
    '.yml'  { Test-Yaml        -File $target }
    '.ps1'  { Test-PowerShell  -File $target }
    default { $null }
}

if ($problem) {
    [Console]::Error.WriteLine("$target is not valid: $problem")
    exit 2
}

exit 0
