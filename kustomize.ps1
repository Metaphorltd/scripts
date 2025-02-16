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
        curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
        sudo install -o root -g root -m 0755 kustomize /usr/local/bin/kustomize
        kustomize version
    }else
    {
        Write-Info  "Kustomize found"
    }
}

function DeployKustomize {
    param (
        [Parameter(Mandatory)][string]$app,
        [Parameter(Mandatory)][string]$path,
        [Parameter(Mandatory)][string]$domain,
        [Parameter(Mandatory)][string]$dockerImage,
        [string]$dockerUser  = "abdullahgb",
        [string]$buildId     = "latest",
        [string]$namespace   = "pr"
    )
    $ErrorActionPreference = 'Stop'
    $output = 'temp'
    Invoke-UpdateKustomizeContent -output $output
    $kustomizePath = "$output/$path"
    Push-Location $kustomizePath
    Invoke-TryInstallKustomize
    Write-Info "Setting deployment configurations"
    kustomize edit set nameprefix "$app-"
    kustomize edit set namespace "$namespace"
    kustomize edit set label "app:$app"
    $imagePath = "${dockerUser}/${dockerImage}:${buildId}"
    kustomize edit set image "user/app=$imagePath"

    $ingressPatch = @"
    - op: replace
      path: /spec/rules/0
      value:
        host: "$domain"
        http:
          paths:
          - pathType: Prefix
            path: /
            backend:
              service:
                name: $app-service
                port:
                  number: 80
"@
    Write-Output $ingressPatch | Out-File ingress.yaml
    kustomize edit add patch --kind Ingress --name ingress --path ingress.yaml
    kustomize build . | kubectl apply -k .
    ThrowOnError $?
    Write-Info "Deployment created successfully"
    Pop-Location
}