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
#  Invoke-UpdateKustomizeContent -branch "dev"
#  TryInstallKustomize
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
# . (Import-Script -path "/kube.ps1")
# . .\kustomize.ps1
# DeployKustomize -app pr47 -path red-portal/environments/pr -dockerImage red.portal -buildId 771 -namespace pr -domain pr47.metaphorltd.com

# . .\auth.ps1
# . (Import-script "/auth.ps1")
# $token = GetAuthToken -clientSecret "P@kistan7861324" -scopes "ShellEx"
# Write-Host $token
# # . .\shellapp.ps1
function KustomizeDeploy {
    . (Import-script "/shellapp.ps1")
    $ErrorActionPreference = 'Stop'
    $appId = "ce42cf5f-3967-4ff7-ad25-dec414b2067d"
    $shellExUrl = "http://localhost:5050"
    $token = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjBCNUQ4RTU3MTlFQTI3NjQ2QzZEQTJBQzM5MEIwMjZCIiwidHlwIjoiYXQrand0In0.eyJpc3MiOiJodHRwczovL2F1dGgubWV0YXBob3JsdGQuY29tIiwibmJmIjoxNzM5NjY4MDk5LCJpYXQiOjE3Mzk2NjgwOTksImV4cCI6MTczOTY3MTY5OSwiYXVkIjoiU2hlbGxFeCIsInNjb3BlIjpbIlNoZWxsRXgiXSwiY2xpZW50X2lkIjoiTWV0LkRldm9wcy5DbGllbnQifQ.A2bqcPhCerFhxHWOqn1hkfn6ck-Rqp8Ai_ohq7_9fEyyg5eRlO2uyou1Q7K3MR2ZWstn_l0y6Ct_7In9HhukaIjCkacifwtvus0KhgFN4YKHXy98DK3RZk6zqMsWPMkeFM-DO1A2ciZ7FVE5W1ABngA2MAay8BDhVqiF40kqD2jtUPH05M1gq0rh7ziP7caWOWdbmdsl1rVoSJ7C3cHOq-AMNZ1jiAXteJXc8x0cqD6hKCM4KecJXbvqnRqbQCk5NF8CeLsTq6af8z04v4px_uPSoe5Mug9TUo_WIzLmyLZltl2-H9wg41zeyYPtQ2IntcFZ_WAvVGxKMYY_XAe3DQ"
    $body = @{
        BuildId = "804"
        PrId = "48"
    }
    $body = $body | ConvertTo-Json
    $url = "$shellExUrl/kube/apps/$appId/deploy"
    Invoke-RestMethod -Uri $url -Method Post -Headers @{"Authorization" = "Bearer $token" } -Body $body -ContentType "application/json"
}
function RefreshApp {
    . .\auth.ps1
    $token = GetAuthToken -clientSecret "P@kistan7861324" -scopes "ShellEx"
    . ./shellapp.ps1
    $appId = "de42cf5f-3967-4ff7-ad25-dec414b2067d"
    RefreshApp -token $token -appId $appId
}
# ReFetchDeployment  -deployment "red-api-deployment" -namespace "red" -buildId "807"