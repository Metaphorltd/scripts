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
