# 不区分大小写的字符串相等比较

$trust_server_certificate = "true"
$trust_server_certificate = "TRUE"
$trust_server_certificate = "True"
$trust_server_certificate = "tRuE"

if ($trust_server_certificate -notin @("true", "false")) {
    throw "Invalid trust_server_certificate value. Expected 'true' or 'false'."
}

if ($trust_server_certificate -ieq "true") {
    Write-Host "Matched"
}