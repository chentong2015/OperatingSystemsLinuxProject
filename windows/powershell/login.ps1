###########################################################
## login.ps1
# Returns:
#   0: no errors
#   1: generic error
###########################################################
param (
    [string]$Url,
    [string]$ClientId,
    [string]$ClientSecret,
    [string]$Login = "",
    [string]$Password,
    [Switch]$help
)
$ParentDir = Split-Path -Path $PSScriptRoot -Parent

. "${ParentDir}/conf/env.ps1"

$ErrorActionPreference = "Stop"

$ScriptName = $MyInvocation.MyCommand.Name

function Usage(){
    Write-Host "`n Login Utility`nUsage: $ScriptName [options...]"
    Write-Host "`t-Url`t`t`t"                "Administration Url"
    Write-Host "`t-ClientId`t`t"             "Client Id"
    Write-Host "`t-ClientSecret`t`t"         "Client Secret"
    Write-Host "`t-Login`t`t`t"              "User Login"
    Write-Host "`t-Password`t`t"             "User Password"
    Write-Host "`t-Help`t`t"                 "This help text"
}


if ($help) {
    Usage
    return 0
}

$Url=$ADMIN_URL
$ClientId=$CLIENT_ID
$ClientSecret=$CLIENT_SECRET
$Login=$LOGIN
$Password=$PASSWORD

if ([String]::IsNullOrEmpty($Url) -OR
        [String]::IsNullOrEmpty($ClientId) -OR
        [String]::IsNullOrEmpty($ClientSecret) -OR
        [String]::IsNullOrEmpty($Login) -OR
        [String]::IsNullOrEmpty($Password)) {
    Write-Host "`n"
    if ([String]::IsNullOrEmpty($Url)) {Write-Host "Administration Url cannot be empty"}
    if ([String]::IsNullOrEmpty($ClientId)) {Write-Host "Client Id cannot be empty"}
    if ([String]::IsNullOrEmpty($ClientSecret)) {Write-Host "Client Secret cannot be empty"}
    if ([String]::IsNullOrEmpty($Login)) {Write-Host "User Login cannot be empty"}
    if ([String]::IsNullOrEmpty($Password)) {Write-Host "User Password cannot be empty"}

    Usage
    return 1
}

$AdminEndpoint = "${Url}/oauth2/token"

$Headers = @{
    "clientId"     = $ClientId;
    "clientSecret" = $ClientSecret;
    "Content-Type" = "application/json"
}

$Body = "{
    `"username`" : `"${Login}`",
    `"password`" : `"${Password}`",
    `"bearer`"   : `"FORMBASED`"
}"

add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
            return true;
        }
 }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

try {
    $ResponseBody = Invoke-WebRequest -Uri $AdminEndpoint -Headers $Headers -Method 'Post' -Body $Body | ConvertFrom-Json
    $Result = if ([string]::IsNullOrEmpty($ResponseBody.token)) {1} else {$ResponseBody.token}
    Write-Host "[Login Succeeded]"
    return $Result
} catch [System.Net.WebException] {
    Write-Host "[Login failed : check env access parameters]"
    Write-Host "[${ScriptName}] - $($_.Exception.Message)"
    return 1
}