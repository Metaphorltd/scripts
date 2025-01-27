function CreatePRDeployment {
    param (
        [Parameter(Mandatory)][string]$dockerImage,
        [Parameter(Mandatory)][string]$prId,
        [Parameter(Mandatory)][string]$dockerUser,
        [Parameter(Mandatory)][string]$domain,
        [Parameter(Mandatory)][string]$service
    )

    $ErrorActionPreference = 'Stop'
    Write-Inf "Setting deployment configurations"
    kustomize edit set nameprefix "pr$prId-"
    kustomize edit set label "app:pr$prId"
    kustomize edit set image "$dockerUser/red.portal=$dockerImage"

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
                name: $service
                port:
                  number: 80
"@
    Write-Output $ingressPatch | Out-File ingress.yaml
    kustomize edit add patch --kind Ingress --name pr-ingress --path ingress.yaml
    kustomize build . | kubectl apply -k .
    Write-Inf "Deployment created successfully"
}
