iex (iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/utils.ps1).Content

$shellExUrl = "https://shellex.metaphorltd.com"
function RefreshApp {
    param (
        [Parameter(Mandatory)][string]$token,
        [Parameter(Mandatory)][string]$appId
    )

    $url = "$shellExUrl/kube/apps/$appId/refresh"
    Invoke-RestMethod -Uri $url -Method Get -Headers @{"Authorization" = "Bearer $token" }
    ThrowOnError $? 'Error in deploying the app'
    return "App refreshed successfully"
}

function DeployApp {
    param (
        [Parameter(Mandatory)][string]$token,
        [Parameter(Mandatory)][string]$appId,
        [Parameter(Mandatory)][string]$body
    )
    $url = "$shellExUrl/kube/apps/$appId/deploy"
    Invoke-RestMethod -Uri $url -Method Post -Headers @{"Authorization" = "Bearer $token" } -Body $body
    ThrowOnError $? 'Error in deploying the app'
    return "App deployed successfully"
}
