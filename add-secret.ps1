# Script to help add GitHub secret
# Note: Due to API limitations, this provides instructions for manual setup

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GitHub Secret Setup Helper" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$secretName = "GHCR_TOKEN"
# Set your token here or pass as parameter
$token = $env:GITHUB_TOKEN
if (-not $token) {
    Write-Host "Please set GITHUB_TOKEN environment variable or modify this script" -ForegroundColor Red
    exit 1
}
$repoUrl = "https://github.com/Sadko-Vadym/tg-bot"

Write-Host "Secret Name: $secretName" -ForegroundColor Yellow
Write-Host "Repository: $repoUrl" -ForegroundColor Yellow
Write-Host ""
Write-Host "To add the secret manually:" -ForegroundColor Green
Write-Host ""
Write-Host "1. Open this URL in your browser:" -ForegroundColor White
Write-Host "   $repoUrl/settings/secrets/actions" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Click 'New repository secret'" -ForegroundColor White
Write-Host ""
Write-Host "3. Enter:" -ForegroundColor White
Write-Host "   Name:  $secretName" -ForegroundColor Yellow
Write-Host "   Value: [Your token - see below]" -ForegroundColor Yellow
Write-Host ""
Write-Host "4. Click 'Add secret'" -ForegroundColor White
Write-Host ""
Write-Host "Your token (copy this):" -ForegroundColor Green
Write-Host $token -ForegroundColor White -BackgroundColor DarkGray
Write-Host ""

# Check current workflow status
Write-Host "Checking current workflow status..." -ForegroundColor Yellow
try {
    $env:GITHUB_TOKEN = $token
    $headers = @{
        "Accept" = "application/vnd.github.v3+json"
        "Authorization" = "token $env:GITHUB_TOKEN"
    }
    $workflowsUrl = "https://api.github.com/repos/Sadko-Vadym/tg-bot/actions/runs"
    $response = Invoke-RestMethod -Uri $workflowsUrl -Headers $headers -Method Get
    
    if ($response.workflow_runs.Count -gt 0) {
        $latestRun = $response.workflow_runs[0]
        Write-Host ""
        Write-Host "Latest Workflow Run:" -ForegroundColor Green
        Write-Host "  Status:     $($latestRun.status)" -ForegroundColor $(if ($latestRun.status -eq "completed") { "Green" } else { "Yellow" })
        Write-Host "  Conclusion:  $($latestRun.conclusion)" -ForegroundColor $(if ($latestRun.conclusion -eq "success") { "Green" } elseif ($latestRun.conclusion -eq "failure") { "Red" } else { "Yellow" })
        Write-Host "  URL:        $($latestRun.html_url)" -ForegroundColor Cyan
        Write-Host "  Created:    $($latestRun.created_at)" -ForegroundColor White
        Write-Host ""
        
        if ($latestRun.conclusion -eq "failure") {
            Write-Host "Workflow failed. This is expected if the secret is not set yet." -ForegroundColor Yellow
            Write-Host "After adding the secret, make another push to trigger a new run." -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "Could not check workflow status: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "After adding the secret, run:" -ForegroundColor Green
Write-Host "  git commit --allow-empty -m 'trigger: CI/CD after secret setup'" -ForegroundColor White
Write-Host "  git push origin develop" -ForegroundColor White
Write-Host ""

