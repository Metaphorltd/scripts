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

function Invoke-TryInstallKustomize{
    param (
        [bool]$force =$false
    )
    $result = Get-Command kustomize -ErrorAction SilentlyContinue;
    if(!$result -or $force){
        Write-Info  "Kustomize not found. Installing..."
        curl --silent --location --remote-name "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v3.2.3/kustomize_kustomize.v3.2.3_linux_amd64"
        chmod a+x kustomize_kustomize.v3.2.3_linux_amd64
        sudo mv kustomize_kustomize.v3.2.3_linux_amd64 /usr/local/bin/kustomize
        kustomize version
    }else
    {
        Write-Info  "Kustomize found"
    }
}