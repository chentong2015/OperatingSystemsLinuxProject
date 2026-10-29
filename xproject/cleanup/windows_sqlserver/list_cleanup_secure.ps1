$ErrorActionPreference = "Stop"

# --- Load credentials ---
$CRED_FILE = Join-Path $PWD ".sqlserver_creds"

if (-not (Test-Path -LiteralPath $CRED_FILE -PathType Leaf)) {
    Write-Error "Error: Credentials file '$CRED_FILE' not found."
    exit 1
}

$credentials = @{}
foreach ($line in Get-Content -LiteralPath $CRED_FILE) {
    $line = $line.Trim()
    if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith("#")) {
        continue
    }
    $separator = $line.IndexOf("=")
    if ($separator -lt 1) {
        continue
    }
    $key = $line.Substring(0, $separator).Trim()
    $value = $line.Substring($separator + 1).Trim()
    $credentials[$key] = $value
}

$sqlserver_user   = $credentials["sqlserver_user"]
$sqlserver_pass   = $credentials["sqlserver_pass"]
$sqlserver_db     = $credentials["sqlserver_db"]
$sqlserver_db_srv = $credentials["sqlserver_db_srv"]

# --- Check required variables ---
if ([string]::IsNullOrWhiteSpace($sqlserver_user) -or
    [string]::IsNullOrWhiteSpace($sqlserver_pass) -or
    [string]::IsNullOrWhiteSpace($sqlserver_db) -or
    [string]::IsNullOrWhiteSpace($sqlserver_db_srv) ) {
    Write-Error "Error: Missing credentials in $CRED_FILE"
    exit 2
}

# --- Check SQL file argument ---
if ($args.Count -lt 1) {
    Write-Host "Usage: .\list_cleanup_secure.ps1 <sql_script.sql>"
    exit 3
}

$SQL_FILE = $args[0]
$OUTPUT_FILE = "sql_output.log"
$DELETED_FILES_LOG = "deleted_files.log"

if (-not (Test-Path -LiteralPath $SQL_FILE -PathType Leaf)) {
    Write-Error "Error: SQL file '$SQL_FILE' not found."
    exit 4
}

# --- Check for sqlcmd ---
if (-not (Get-Command sqlcmd -ErrorAction SilentlyContinue)) {
    Write-Error "Error: sqlcmd is not installed or not in PATH."
    exit 5
}

# --- Convert custom port to sqlcmd server,port format ---
if ($sqlserver_db -match '^(.*):(\d+)$') {
    $SQL_SERVER = "$($Matches[1]),$($Matches[2])"
} else {
    $SQL_SERVER = "$sqlserver_db,1433"
}

Write-Host "SQL_SERVER = $SQL_SERVER"

# --- Run sqlcmd and save output ---
& sqlcmd -S $SQL_SERVER -d $sqlserver_db_srv -U $sqlserver_user -P $sqlserver_pass `
  -b -r 1  -i $SQL_FILE -o $OUTPUT_FILE

# --- Check SQL execution result ---
$sqlcmd_exit_code = $LASTEXITCODE
if ($sqlcmd_exit_code -ne 0) {
    Write-Error "sqlcmd failed with exit code $sqlcmd_exit_code"
    Write-Host "Check output file: $OUTPUT_FILE"
    exit $sqlcmd_exit_code
}

Write-Host "SQL script executed successfully. Output saved to $OUTPUT_FILE"
exit 0