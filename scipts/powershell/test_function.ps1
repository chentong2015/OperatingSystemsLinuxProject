# File.ReadLines() 返回延迟读取的IEnumerable, 而非一次性读取整个文件
# foreach 会完成枚举并释放相关资源, 延迟枚举可能带来的文件句柄问题
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

# ReadAllLines() 会一次性读取文件，并在读取完成后关闭文件
function IsAlreadyDeleted([string]$FilePath) {
    if (-not (Test-Path -LiteralPath $DELETED_FILES_LOG -PathType Leaf)) {
        return $false
    }

    $lines = [System.IO.File]::ReadAllLines($DELETED_FILES_LOG)
    foreach ($line in $lines) {
        if ($line -ceq $FilePath) {
            return $true
        }
    }
    return $false
}