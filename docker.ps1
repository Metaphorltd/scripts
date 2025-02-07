iex (iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/utils.ps1).Content
function BuildAndPushDockerImage {
    param (
        [Parameter(Mandatory)][string]$dockerUser,
        [Parameter(Mandatory)][string]$dockerPassword,
        [Parameter(Mandatory)][string]$dockerImage,
        [Parameter(Mandatory)][string]$nugetUsername,
        [Parameter(Mandatory)][string]$nugetToken,
        [string]$dockerfile = "Dockerfile",
        [string]$context    = ".",
        [string]$tag        = "latest"
    )
    docker login -u $dockerUser -p $dockerPassword
    ThrowOnError $?

    $imageTag = "${dockerUser}/${dockerImage}:${tag}"
    Write-Info "Building Docker image: $imageTag"
    docker build -f $dockerfile --build-arg nuget_username = $nugetUsername --build-arg nuget_auth_token = $nugetToken --tag $imageTag $context
    ThrowOnError $?

    Write-Info "Pushing Docker image: $imageTag"
    docker push $imageTag --all-tags
    ThrowOnError $?
    return $imageTag
}