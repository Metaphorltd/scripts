
iex (iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/utils.ps1).Content
$shellExUrl ="https://shellex.metaphorltd.com"

function Invoke-Docker-Publish {
    param (
        [Parameter(Mandatory)][string]$username,
        [Parameter(Mandatory)][string]$password,
        [Parameter(Mandatory)][string]$image,
        [string]$dockerfie = "Dockerfile",
        [string]$tag = "latest",
        [string]$context = "."
    )
    Write-Inf "Logging in to Docker Hub"
    docker login -u $username -p $password

    $imagePath = "${username}/${image}:${tag}"
    Write-Inf "Building the Docker image"
    docker build $context -f $dockerfile -t $imagePath

    Write-Inf "Pushing the Docker image: $imagePath"
    docker push "${username}/${image}:${tag}"
}

function Invoke-Refresh-App {
    param (
        [Parameter(Mandatory)][string]$token,
        [Parameter(Mandatory)][string]$appId
    )

    $url = "$shellExUrl/kube/apps/$appId/refresh"
    Invoke-RestMethod -Uri $url -Method Get -Headers @{"Authorization" = "Bearer $token" }
    if ($? -eq $false) {
        throw 'Error in refreshing the app'
    }
}