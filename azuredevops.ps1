iex (iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/utils.ps1).Content

function CommentOnPR {
    param (
        [Parameter(Mandatory)][string]$prId,
        [Parameter(Mandatory)][string]$domain,
        [Parameter(Mandatory)][string]$cloudflareToken
    )

    $previewUrl = "$domain"
    $markdown = @"
    ## Preview Environment
    |Service |Url|
    |--------|---|
    |Portal  |$previewUrl|
"@

    $body = @{
        comments = @(@{ parentCommentId = 0; content = $markdown; commentType = 1 })
        status = 4
    }

    $header = @{
        Authorization = "Basic " + [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":" + $cloudflareToken))
    }
    $url = "https://dev.azure.com/metaphorltd/red/_apis/git/repositories/red.portal/pullrequests/$prId/threads?api-version=5.1"

    try {
        Invoke-RestMethod -Uri $url -Method Post -Headers $header -Body ($body | ConvertTo-Json -Depth 2) -ContentType "application/json"
        Write-Inf "Comment added to PR"
    } catch {
        Write-Error "Error commenting on PR: $_"
    }
}