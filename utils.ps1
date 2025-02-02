function Global:Import-Script {
    param (
        [string]$path,
        [string]$branch = "main",
        [string]$repo = "scripts",
        [string]$owner = "metaphorltd"
    )

    if ($path -match '^http') {
        iex (iwr $path).Content
    }
    else {
        if ($path -notmatch '/') {
            $path = "/$path"
        }
        iex (iwr https://raw.githubusercontent.com/metaphorltd/$repo/$branch$path).Content
    }
    
}

function Global:Write-Log {
    param (
        [string]$message,
        [string]$level = "INF"
    )
    $timestamp = Get-Date -Format "HH:mm:ss"
    if ($level -eq "ERR") {
        Write-Host -NoNewline "[$timestamp "
        Write-Host -NoNewline "$level] " -ForegroundColor Red
        write-host  $message
    }else{
        Write-Host -NoNewline "[$timestamp "
        Write-Host -NoNewline "$level] " -ForegroundColor Green
        write-host  $message
    }
}

function Global:Write-Info {
    param (
        [string]$message
    )
    Write-Log -message $message -level "INF"
}

function Global:Write-Error {
    param (
        [string]$message
    )
    Write-Log -message $message -level "ERR"
}
function Global:Write-Inf {
    param (
        [string]$message
    )
    Write-Log -message $message -level "INF"
}

function Global:Write-Err {
    param (
        [string]$message
    )
    Write-Log -message $message -level "ERR"
}

function Global:ThrowOnError
{
    param(
        [bool]$isSuccess,
        [string]$message?)
    if(-not $isSuccess)
    {
        $message = if ($null -eq $message) { "Error while executing the script" } else { $message }
        Write-Error -Message $message -Exception (New-Object -TypeName System.Exception) -ErrorAction Stop
    }
}

function Global:ExitOnError
{
    param($isSuccess)
    if(-not $isSuccess)
    {
        exit 1
    }
}