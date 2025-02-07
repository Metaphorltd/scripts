iex (iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/utils.ps1).Content

function UpdateDNSRecord {
    param (
        [Parameter(Mandatory)][string]$domain,
        [Parameter(Mandatory)][string]$zoneId,
        [Parameter(Mandatory)][string]$apiToken,
        [Parameter(Mandatory)][string]$serverIp
    )

    $url = "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records"
    $recordData = @{
        type    = "CNAME"
        name    = "$domain"
        content = $serverIp
        proxied = $true
    }

    $headers = @{
        'Authorization' = "Bearer $apiToken"
        'Content-Type' = 'application/json'
    }

    try {
        $response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body ($recordData | ConvertTo-Json -Depth 2)
        if ($response.success) {
            Write-Inf "DNS record added successfully"
        } else {
            Write-Error "Error adding DNS record: $($response.errors[0].message)"
        }
    } catch {
        Write-Error "Error: $_"
    }
}
function StartCloudflared {
    param (
        [Parameter(Mandatory)][string]$cloudflareId,
        [Parameter(Mandatory)][string]$cloudflareSecret,
        [Parameter(Mandatory)][string]$hostname
    )
    
    $job = Start-Job {
        sudo cloudflared access ssh --id $cloudflareId -$cloudflareSecretcfSecret --hostname $hostname --url localhost:6443
    }
    Start-Sleep 5
    if ($job.State -eq 'Failed') {
        throw "Error starting cloudflared: $($job.ChildJobs[0].JobStateInfo.Reason.Message)"
    }
    return $job
}