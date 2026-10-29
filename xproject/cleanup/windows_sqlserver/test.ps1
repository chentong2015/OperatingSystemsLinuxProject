if (Test-Path -LiteralPath $full_path -PathType Leaf) {
    try {
        Remove-Item -LiteralPath $full_path -Force -ErrorAction Stop
    } catch {
        Write-Host "Failed to delete: $full_path"
        continue
    }

    Write-Host "Deleted: $full_path"
    Add-ToDeletedLog $full_path
}