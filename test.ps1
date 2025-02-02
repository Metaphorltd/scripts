# # $token = & { . ([scriptblock]::Create((iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/auth.ps1).Content)); GetAuthToken -clientSecret P@kistan7861324 -scopes ShellEx }
# . ./kube.ps1

# CreateDeployment -kustomizePath ".\kustomize\red-portal\environments\pr" `
#     -dockerImage "red.portal" `
#     -app "pr47-red-portal" `
#     -buildId "764" `
#     -domain "pr47-portal.metaphorltd.com"
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

[string]$output = "./temp"
if (-not (Test-Path $output)) {
    New-Item -ItemType Directory -Path $output
}
Write-Host "Downloading files..."
$response = Invoke-WebRequest -Uri "https://github.com/metaphorltd/scripts/archive/dev.tar.gz" -OutFile "$output/scripts.tar.gz"
Write-Host "Extracting files..."
tar -xzvf "$output/scripts.tar.gz" -C $output --strip-components=2 "scripts-dev/kustomize"
Write-Host "Extraction complete."
