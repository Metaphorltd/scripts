iex (iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/utils.ps1).Content

function Invoke-UpdateKustomizeContent {
    param (
        [string]$output = "./temp",
        [string]$branch = "main"
    )
    if (-not (Test-Path $output)) {
        New-Item -ItemType Directory -Path $output
    }
    Write-Info "Updating kustomize content..."
    $response = Invoke-WebRequest -Uri "https://github.com/metaphorltd/scripts/archive/$branch.tar.gz" -OutFile "$output/scripts.tar.gz"
    tar -xzvf "$output/scripts.tar.gz" -C $output --strip-components=2 "scripts-$branch/kustomize"
}