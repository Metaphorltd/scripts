param (
    [string]$message = "World"
)
iex (iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/utils.ps1).Content
Write-Inf "Hello, $message!"