iex (iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/utils.ps1).Content

function Get-AuthorizationToken {
    [OutputType([string])]
    param (
        [string]$clientId = "rems.auth.devops.client",
        [string]$clientSecret,
        [string]$scopes,
        [string]$audience?,
        [string]$authUrl = "https://auth.metaphorltd.com"
    )

    # get discovery document
    $document = Invoke-RestMethod -Uri "$authUrl/.well-known/openid-configuration" -Method Get
    $tokenEndpoint = $document.token_endpoint
    # $hashtable2 = @{One='one'; Two='two';Three='three'}   # hashtable with 3 values
    # key value pairs of arguments
    $body = @{
        client_id=$clientId;
        client_secret=$clientSecret;
        scope=$scopes;
        grant_type='client_credentials'
    }
    # convert above to =>  "client_id=$clientId&client_secret=$clientSecret&scope=$scopes&grant_type=client_credentials" as string
    $body = $body.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }
    $body = $body -join '&'
    echo $body | ConvertTo-Json
}