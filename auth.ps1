iex (iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/utils.ps1).Content

function GetAuthToken {
    [OutputType([string])]
    param (
        [string]$clientId = "rems.auth.devops.client",
        [Parameter(Mandatory)][string]$clientSecret,
        [Parameter(Mandatory)][string]$scopes,
        [string]$audience?,
        [string]$authUrl = "https://auth.metaphorltd.com"
    )

    # get discovery document
    $document = Invoke-RestMethod -Uri "$authUrl/.well-known/openid-configuration" -Method Get
    Write-Inf "Discovery document received successfully"
    $tokenEndpoint = $document.token_endpoint
    Write-Inf "Token endpoint: $tokenEndpoint"
    $body = @{
        client_id=$clientId;
        client_secret=$clientSecret;
        scope=$scopes;
        grant_type='client_credentials'
    }
    if($audience) {
        $body.Add('audience', $audience)
    }
    $body = $body.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }
    $body = $body -join '&'
    $response = Invoke-RestMethod -Uri $tokenEndpoint -Method Post -Headers @{"Content-Type" = "application/x-www-form-urlencoded" } -Body $body
    if ($? -eq $false) {
        throw 'Error in getting access token'
    }
    Write-Inf "Access token received successfully"
    return $response.access_token
}