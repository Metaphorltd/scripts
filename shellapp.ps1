iex (iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/utils.ps1).Content
$shellExUrl ="https://shellex.metaphorltd.com"
function RefreshApp {
    param (
        [Parameter(Mandatory)][string]$token,
        [Parameter(Mandatory)][string]$appId
    )

    $url = "$shellExUrl/kube/apps/$appId/refresh"
    Invoke-RestMethod -Uri $url -Method Get -Headers @{"Authorization" = "Bearer $token" }
    ThrowOnError $? 'Error in refreshing the app'
    return "App refreshed successfully"
} 