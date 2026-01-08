# Script to check workflow status and trigger new run after secret is added

# Set your token here or use environment variable
$token = $env:GITHUB_TOKEN
if (-not $token) {
    Write-Host "⚠️  GITHUB_TOKEN not set. Some features may not work." -ForegroundColor Yellow
    Write-Host "Set it with: `$env:GITHUB_TOKEN = 'your_token_here'" -ForegroundColor Yellow
    exit 0
}
$headers = @{
    "Accept" = "application/vnd.github.v3+json"
    "Authorization" = "token $token"
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "CI/CD Pipeline Checker" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if secret is set by trying to get public key (will fail if no access)
Write-Host "Checking if secret can be accessed..." -ForegroundColor Yellow
try {
    $publicKeyUrl = "https://api.github.com/repos/Sadko-Vadym/tg-bot/actions/secrets/public-key"
    $publicKey = Invoke-RestMethod -Uri $publicKeyUrl -Headers $headers -Method Get -ErrorAction Stop
    Write-Host "✅ Secret access available!" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Cannot verify secret via API (this is normal)" -ForegroundColor Yellow
    Write-Host "   Please ensure you've added GHCR_TOKEN secret manually" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Checking latest workflow runs..." -ForegroundColor Yellow

try {
    $workflowsUrl = "https://api.github.com/repos/Sadko-Vadym/tg-bot/actions/runs?branch=develop&per_page=5"
    $response = Invoke-RestMethod -Uri $workflowsUrl -Headers $headers -Method Get
    
    if ($response.workflow_runs.Count -gt 0) {
        Write-Host ""
        Write-Host "Recent Workflow Runs:" -ForegroundColor Green
        Write-Host ""
        
        $response.workflow_runs | ForEach-Object {
            $statusColor = switch ($_.status) {
                "completed" { "Green" }
                "in_progress" { "Yellow" }
                "queued" { "Cyan" }
                default { "White" }
            }
            
            $conclusionColor = switch ($_.conclusion) {
                "success" { "Green" }
                "failure" { "Red" }
                "cancelled" { "Yellow" }
                default { "White" }
            }
            
            Write-Host "  Run #$($_.run_number)" -ForegroundColor White -NoNewline
            Write-Host " - Status: " -NoNewline
            Write-Host $_.status -ForegroundColor $statusColor -NoNewline
            if ($_.conclusion) {
                Write-Host " - Conclusion: " -NoNewline
                Write-Host $_.conclusion -ForegroundColor $conclusionColor
            } else {
                Write-Host ""
            }
            Write-Host "    URL: $($_.html_url)" -ForegroundColor Cyan
            Write-Host "    Created: $($_.created_at)" -ForegroundColor Gray
            Write-Host ""
        }
        
        $latestRun = $response.workflow_runs[0]
        
        if ($latestRun.conclusion -eq "success") {
            Write-Host "✅ Latest workflow completed successfully!" -ForegroundColor Green
            Write-Host ""
            Write-Host "Getting image reference..." -ForegroundColor Yellow
            
            # Try to get job logs to find image reference
            $jobsUrl = "https://api.github.com/repos/Sadko-Vadym/tg-bot/actions/runs/$($latestRun.id)/jobs"
            $jobs = Invoke-RestMethod -Uri $jobsUrl -Headers $headers -Method Get
            
            $buildJob = $jobs.jobs | Where-Object { $_.name -like "*Build*" }
            if ($buildJob) {
                Write-Host ""
                Write-Host "Build Job: $($buildJob.name)" -ForegroundColor Green
                Write-Host "  Status: $($buildJob.status)" -ForegroundColor White
                Write-Host "  Conclusion: $($buildJob.conclusion)" -ForegroundColor White
                Write-Host ""
                Write-Host "Image should be available at:" -ForegroundColor Yellow
                Write-Host "  ghcr.io/den-vasyliev/kbot:v1.0.0-*-linux-amd64" -ForegroundColor Cyan
                Write-Host ""
                Write-Host "Check the workflow logs for the exact image tag:" -ForegroundColor White
                Write-Host "  $($latestRun.html_url)" -ForegroundColor Cyan
            }
        } elseif ($latestRun.conclusion -eq "failure") {
            Write-Host "❌ Latest workflow failed" -ForegroundColor Red
            Write-Host ""
            Write-Host "Common causes:" -ForegroundColor Yellow
            Write-Host "  1. GHCR_TOKEN secret not set" -ForegroundColor White
            Write-Host "  2. Token doesn't have required permissions" -ForegroundColor White
            Write-Host "  3. Build errors" -ForegroundColor White
            Write-Host ""
            Write-Host "Check logs: $($latestRun.html_url)" -ForegroundColor Cyan
        }
    }
} catch {
    Write-Host "Error checking workflow: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "To trigger a new workflow run:" -ForegroundColor Green
Write-Host "  git commit --allow-empty -m 'trigger: CI/CD pipeline'" -ForegroundColor White
Write-Host "  git push origin develop" -ForegroundColor White
Write-Host ""

