iex (iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/utils.ps1).Content

function Invoke-UpdateKustomizeContent {
    param (
        [string]$output = "temp",
        [string]$owner  = "metaphorltd",
        [string]$repo   = "scripts",
        [string]$branch = "main",
        [string]$path   = "kustomize"
    )
    if (-not (Test-Path $output)) {
        New-Item -ItemType Directory -Path $output
    }
    Write-Info "Updating kustomize content..."
    Invoke-WebRequest -Uri "https://github.com/$owner/$repo/archive/$branch.tar.gz" -OutFile "$output/$repo.tar.gz"
    ThrowOnError $?
    tar -xzvf "$output/$repo.tar.gz" -C "$output" --strip-components=2 "$repo-$branch/$path"
}