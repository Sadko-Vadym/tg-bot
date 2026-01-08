# Script to trigger CI/CD workflow after secret is added

Write-Host "Triggering CI/CD workflow..." -ForegroundColor Yellow
Write-Host ""

$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Host "⚠️  You have uncommitted changes. Committing them first..." -ForegroundColor Yellow
    git add .
    git commit -m "chore: update before CI/CD trigger"
}

Write-Host "Creating empty commit to trigger workflow..." -ForegroundColor Cyan
git commit --allow-empty -m "trigger: CI/CD pipeline after secret setup"

Write-Host "Pushing to develop branch..." -ForegroundColor Cyan
git push origin develop

Write-Host ""
Write-Host "✅ Push completed!" -ForegroundColor Green
Write-Host ""
Write-Host "Check workflow status at:" -ForegroundColor Yellow
Write-Host "  https://github.com/Sadko-Vadym/tg-bot/actions" -ForegroundColor Cyan
Write-Host ""
Write-Host "Waiting 10 seconds before checking status..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Check workflow status (optional - requires GITHUB_TOKEN env variable)
if ($env:GITHUB_TOKEN) {
    $headers = @{
        "Accept" = "application/vnd.github.v3+json"
        "Authorization" = "token $env:GITHUB_TOKEN"
    }
    
    try {
        $workflowsUrl = "https://api.github.com/repos/Sadko-Vadym/tg-bot/actions/runs?branch=develop&per_page=1"
        $response = Invoke-RestMethod -Uri $workflowsUrl -Headers $headers -Method Get
        
        if ($response.workflow_runs.Count -gt 0) {
            $latestRun = $response.workflow_runs[0]
            Write-Host ""
            Write-Host "Latest Workflow Run:" -ForegroundColor Green
            Write-Host "  Status: $($latestRun.status)" -ForegroundColor White
            Write-Host "  URL: $($latestRun.html_url)" -ForegroundColor Cyan
            Write-Host ""
            
            if ($latestRun.status -eq "in_progress" -or $latestRun.status -eq "queued") {
                Write-Host "⏳ Workflow is running. Check back in a few minutes." -ForegroundColor Yellow
            }
        }
    } catch {
        Write-Host "Could not check workflow status automatically." -ForegroundColor Yellow
        Write-Host "Please check manually: https://github.com/Sadko-Vadym/tg-bot/actions" -ForegroundColor Cyan
    }
} else {
    Write-Host "ℹ️  Set GITHUB_TOKEN environment variable to enable automatic status checking." -ForegroundColor Gray
    Write-Host "   Check manually: https://github.com/Sadko-Vadym/tg-bot/actions" -ForegroundColor Cyan
}

