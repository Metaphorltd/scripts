iex (iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/utils.ps1).Content

function UpdateAuthURLs {
    param (
        [Parameter(Mandatory)][string]$domain,
        [Parameter(Mandatory)][string]$clientSecret,
        [Parameter(Mandatory)][string]$authUrl,
        [Parameter(Mandatory)][string]$authApiUrl,
        [Parameter(Mandatory)][string]$clientId,
        [Parameter(Mandatory)][string]$scope
    )

    $previewUrl    = "$domain"
    $tokenEndpoint = (Invoke-RestMethod -Uri "$authUrl/.well-known/openid-configuration").token_endpoint

    $response = Invoke-RestMethod -Uri $tokenEndpoint -Method Post -Headers @{ "Content-Type" = "application/x-www-form-urlencoded" } `
        -Body "client_id=$clientId&client_secret=$clientSecret&scope=$scope&grant_type=client_credentials"

    if (-not $response.access_token) {
        throw "Error obtaining access token"
    }

    $token  = $response.access_token
    $header = @{ Authorization = "Bearer $token" }
    $url    = "$authApiUrl/api/Clients/$clientId/uris"
    $body   = @{ Url = $previewUrl }

    Invoke-RestMethod -Uri $url -Method Put -Headers $header -Body ($body | ConvertTo-Json) -ContentType "application/json"
    Write-Inf "Auth URLs updated successfully"
}