$CRED_FILE = Join-Path $PWD ".sqlserver_creds"

# Read key=value credentials file
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

Write-Host "User: [$sqlserver_user]"
Write-Host "pass: [$sqlserver_pass]"
Write-Host "Database: [$sqlserver_db]"
Write-Host "Database Srv: [$sqlserver_db_srv]"