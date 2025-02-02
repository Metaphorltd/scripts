iex (iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/utils.ps1).Content
function ReFetchDeployment {
  param (
      [Parameter(Mandatory)][string]$deployment,
      [Parameter(Mandatory)][string]$namespace
  )
  
  Write-Info "Scaling Kubernetes deployment to 0..."
  kubectl scale deployment $deployment --replicas 0 -n $namespace
  ThrowOnError $?
  Start-Sleep 1
  Write-Info "Scaling Kubernetes deployment to 1..."
  kubectl scale deployment $deployment --replicas 1 -n $namespace
  ThrowOnError $?
  Start-Sleep 1
}

function CreateDeployment {
    param (
        [Parameter(Mandatory)][string]$kustomizePath,
        [Parameter(Mandatory)][string]$dockerImage,
        [Parameter(Mandatory)][string]$app,
        [Parameter(Mandatory)][string]$domain,
        [string]$dockerUser = "abdullahgb",
        [string]$buildId = "latest",
        [string]$namespace = "pr"
    )
    $ErrorActionPreference = 'Stop'
    Import-Script "/kusomize.ps1" "dev"
    Invoke-UpdateKustomizeContent
    
    Push-Location $kustomizePath
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
    Write-Info "Deployment created successfully"
    Pop-Location
}
