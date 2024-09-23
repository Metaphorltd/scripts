iex (iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/utils.ps1).Content

function Get-AuthorizationToken {
    [OutputType([string])]
    param (
        [string]$clientId = "rems.auth.devops.client",
        [string]$clientSecret,
        [string]$scope = "Rems.Auth.Api",
        [string]$authUrl = "https://auth.metaphorltd.com",
        [string]$authApiUrl = "https://auth-api.metaphorltd.com"
    )

    # get discovery document
    $document = Invoke-RestMethod -Uri "$authUrl/.well-known/openid-configuration" -Method Get
    $tokenEndpoint = $document.token_endpoint
    $response = Invoke-RestMethod -Uri $tokenEndpoint -Method Post -Headers @{"Content-Type" = "application/x-www-form-urlencoded" } -Body "client_id=$clientId&client_secret=$clientSecret&scope=$scope&grant_type=client_credentials"
    if ($? -eq $false) {
        throw 'Error in getting access token'
    }
    Write-Inf "Access token received successfully"
    return $response.access_token
}