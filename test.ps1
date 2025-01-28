# $token = & { . ([scriptblock]::Create((iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/auth.ps1).Content)); GetAuthToken -clientSecret P@kistan7861324 -scopes ShellEx }
. ./kube.ps1

CreateDeployment -kustomizePath ".\kustomize\red-portal\environments\pr" `
    -dockerImage "red.portal" `
    -app "pr47-red-portal" `
    -buildId "764" `
    -domain "pr47-portal.metaphorltd.com"