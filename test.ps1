# $token = & { . ([scriptblock]::Create((iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/auth.ps1).Content)); GetAuthToken -clientSecret P@kistan7861324 -scopes ShellEx }
iex (iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/utils.ps1).Content
Log-Info "Hello"

function Global:Write-Info {
    param (
        [string]$message
    )
    Write-Log -message $message -level "INF"
}

Write-Info "HEllo"