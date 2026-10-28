# -------------------------------
# SQL Server configuration
# -------------------------------
$Server   = "localhost"
$Database = "MyDatabase"
$SqlFile  = "C:\Scripts\deploy.sql"
$LogFile  = "C:\Scripts\deploy.log"

# --- Check for sqlcmd ---
if (-not (Get-Command sqlcmd -ErrorAction SilentlyContinue)) {
    Write-Error "Error: sqlcmd is not installed or not in PATH."
    exit 5
}

# --- Check SQL file ---
if (-not (Test-Path -LiteralPath $SqlFile -PathType Leaf)) {
    Write-Error "Error: SQL file not found: $SqlFile"
    exit 6
}

# --- Execute SQL script ---
Write-Host "Executing SQL script: $SqlFile"

& sqlcmd -S $Server -d $Database -E -b -r 1 -i $SqlFile -o $LogFile

$ExitCode = $LASTEXITCODE

if ($ExitCode -ne 0) {
    Write-Error "SQL execution failed. Exit code: $ExitCode"
    Write-Host "Check log file: $LogFile"
    exit $ExitCode
}

Write-Host "SQL script executed successfully."
Write-Host "Log file: $LogFile"
exit 0