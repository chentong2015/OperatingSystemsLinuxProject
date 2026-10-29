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

# --- Run sqlcmd and save output ---
& sqlcmd -S $SQL_SERVER -d $sqlserver_db_srv -U $sqlserver_user -P $sqlserver_pass -b -r 1  -i $SQL_FILE -o $OUTPUT_FILE

# --- Check SQL execution result ---
$sqlcmd_exit_code = $LASTEXITCODE
if ($sqlcmd_exit_code -ne 0) {
    Write-Error "sqlcmd failed with exit code $sqlcmd_exit_code"
    Write-Host "Check output file: $OUTPUT_FILE"
    exit $sqlcmd_exit_code
}

Write-Host "SQL script executed successfully. Output saved to $OUTPUT_FILE"


# --- Create deleted files log if it doesn't exist ---
if (-not (Test-Path -LiteralPath $DELETED_FILES_LOG -PathType Leaf)) {
    New-Item -Path $DELETED_FILES_LOG -ItemType File -Force | Out-Null
    Write-Host "Created deleted files log: $DELETED_FILES_LOG"
}

# --- Function to check if file was already deleted ---
function IsAlreadyDeleted([string]$FilePath) {
    if (-not (Test-Path -LiteralPath $DELETED_FILES_LOG -PathType Leaf)) {
        return $false
    }
    foreach ($line in [System.IO.File]::ReadLines($DELETED_FILES_LOG)) {
        if ($line -ceq $FilePath) {
            return $true
        }
    }
    return $false
}

# --- Function to add file to deleted log ---
function AddToDeletedLog([string]$FilePath) {
    Add-Content -LiteralPath $DELETED_FILES_LOG -Value $FilePath -Encoding UTF8
}


# --- Parse output and delete files ---
Write-Host "Deleting files listed in SQL output..."

# --- $BASE_DIR="<shared-drive.location>/work/db/"
# --- $BASE_DIR="C:/Work/WorkProjects/WLM_WORKSPACE/shared-drive/work/db/"
$BASE_DIR="C:/Users/chent5/Downloads/Testing/"

# Read each line from SQL output
foreach ($fileLine in [System.IO.File]::ReadLines($OUTPUT_FILE)) {
    # Skip empty lines
    $file = $fileLine.Trim()
    if ([string]::IsNullOrWhiteSpace($file)) {
        continue
    }

    # Convert filename to lowercase for case-insensitive matching
    $fileLower = $file.ToLowerInvariant()
    if ($fileLower -match '^#?.*\.(xlsx|kz)$') {

        # Search for the file in BASE_DIR and all subdirectories
        try {
            $foundFiles = @(Get-ChildItem -LiteralPath $BASE_DIR -File -Recurse | Where-Object { $_.Name -ceq $file })
        } catch {
            $foundFiles = @()
        }

        if ($foundFiles.Count -eq 0) {
            Write-Host "File not found in directory or subdirectories: $file"

            # Try the original location as fallback
            $full_path = Join-Path -Path $BASE_DIR -ChildPath $file
            if (IsAlreadyDeleted $full_path) {
                Write-Host "Already deleted previously: $full_path"
            } else {
                AddToDeletedLog $full_path
            }
        } else {
            # Process each found file (including duplicates in different subdirectories)
            foreach ($foundFile in $foundFiles) {

                # Check if file was already deleted in a previous run
                $full_path = $foundFile.FullName
                if (IsAlreadyDeleted $full_path) {
                    Write-Host "Already deleted previously: $full_path"
                    continue
                }

                if (Test-Path -LiteralPath $full_path -PathType Leaf) {
                    try {
                        Remove-Item -LiteralPath $full_path -Force -ErrorAction Stop
                    } catch {
                        Write-Host "Failed to delete: $full_path"
                        continue
                    }
                    Write-Host "Deleted: $full_path"
                    AddToDeletedLog $full_path
                } else {
                    Write-Host "File not found: $full_path"
                    AddToDeletedLog $full_path
                }
            }
        }
    } else {
        Write-Host "Skipping non-target file: $file"
    }
}

exit 0