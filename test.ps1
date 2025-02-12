iex (iwr https://raw.githubusercontent.com/metaphorltd/scripts/dev/utils.ps1).Content
# # $token = & { . ([scriptblock]::Create((iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/auth.ps1).Content)); GetAuthToken -clientSecret P@kistan7861324 -scopes ShellEx }
# . ./utils.ps1
# . ([scriptblock]::Create((iwr https://raw.githubusercontent.com/metaphorltd/scripts/dev/utils.ps1).Content))
# iex (iwr ).Content


# . (Import-Script -path "/kustomize.ps1" -branch "dev")
# . $script;
# Invoke-Expression $path

# . ./kustomize.ps1
# . ./kustomize.ps1
# . ([scriptblock]::Create((iwr https://raw.githubusercontent.com/metaphorltd/scripts/dev/kustomize.ps1).Content))
# $kustomizePath = Invoke-UpdateKustomizeContent -branch "dev"
# Write-Info $kustomizePath
# DeployKustomize  -app "pr47-red-portal" -path "red-portal" -dockerImage "red.portal" -buildId "764" -domain "pr47-portal.metaphorltd.com" 
# . ./globals.ps1
# $scriptPath = "https://raw.githubusercontent.com/metaphorltd/scripts/main/utils.ps1"
# $res = $scriptPath -match '^http'
# Write-Host $kustomizeUrl
# Define the URL of the raw content
# $kustomizeContentUrl = "https://api.github.com/repos/metaphorltd/scripts/contents?ref=dev"

# # Set repository and folder information
# $repoOwner = "metaphorltd"
# $repoName = "scripts"
# $folderPath = "kustomize"  # Example: "docs"
# $output = "D:\temp\scripts"

# # GitHub API URL to list files in the folder
# $apiUrl = $kustomizeContentUrl

# # Make the API request
# $response = Invoke-RestMethod -Uri $apiUrl -Method Get

# # Download each file
# foreach ($item in $response) {
#     if ($item.type -eq "file") {
#         $fileUrl = $item.download_url
#         $fileName = $item.name
#         Write-Host "Downloading $fileName..."
#         Invoke-WebRequest -Uri $fileUrl -OutFile $output/$fileName
#     }
# }
# . /kube.ps1
# [string]$output = "./temp"
# if (-not (Test-Path $output)) {
# New-Item -ItemType Directory -Path $output
# }
# Write-Host "Downloading files..."
# $response = Invoke-WebRequest -Uri "https://github.com/metaphorltd/scripts/archive/dev.tar.gz" -OutFile "$output/scripts.tar.gz"
# Write-Host "Extracting files..."
# tar -xzvf "$output/scripts.tar.gz" -C $output --strip-components=2 "scripts-dev/kustomize"
# Write-Host "Extraction complete."


# Script: '([scriptblock]::Create((iwr https://raw.githubusercontent.com/metaphorltd/scripts/dev/kube.ps1).Content))'
# Arguments: -app red-portal
#       -path red-portal
#       -dockerImage red.portal
#       -buildId 771
#       -domain pr47.metaphorltd.com
#       -namespace pr
#       -environment pr

# Script: '([scriptblock]::Create((iwr https://raw.githubusercontent.com/metaphorltd/scripts/dev/kube.ps1).Content))'
# Arguments: -app pr47
#       -path red-portal/environments/pr
#       -dockerImage red.portal
#       -buildId 771
#       -namespace pr
#       -domain pr47.metaphorltd.com
# . (Import-Script -path "/kube.ps1" -branch "dev")
# DeployKustomize -app pr47 -path red-portal/environments/pr -dockerImage red.portal -buildId 771 -namespace pr -domain pr47.metaphorltd.com

. .\auth.ps1
$token = GetAuthToken -clientSecret "P@kistan7861324" -scopes "ShellEx"
Write-Host $token
. .\shellapp.ps1
$body = @{
    BuildId = "771"
    PrId = "47"
}
$body = $body | ConvertTo-Json 
DeployApp -token $token -appId ce42cf5f-3967-4ff7-ad25-dec414b2067d -body $body