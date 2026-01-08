# PowerShell script to add GitHub secret via API
# Requires: GitHub Personal Access Token with repo scope

param(
    [Parameter(Mandatory=$true)]
    [string]$Token,
    
    [Parameter(Mandatory=$false)]
    [string]$SecretName = "GHCR_TOKEN",
    
    [Parameter(Mandatory=$false)]
    [string]$SecretValue = "",
    
    [Parameter(Mandatory=$false)]
    [string]$Owner = "Sadko-Vadym",
    
    [Parameter(Mandatory=$false)]
    [string]$Repo = "tg-bot"
)

$headers = @{
    "Accept" = "application/vnd.github.v3+json"
    "Authorization" = "token $Token"
}

# Step 1: Get repository public key
Write-Host "Getting repository public key..." -ForegroundColor Yellow
$publicKeyUrl = "https://api.github.com/repos/$Owner/$Repo/actions/secrets/public-key"
$publicKeyResponse = Invoke-RestMethod -Uri $publicKeyUrl -Headers $headers -Method Get

$publicKey = $publicKeyResponse.key
$keyId = $publicKeyResponse.key_id

Write-Host "Public Key ID: $keyId" -ForegroundColor Green

# Step 2: Encrypt the secret using libsodium (requires libsodium library)
# For simplicity, we'll use a workaround - GitHub CLI or manual setup is recommended
Write-Host ""
Write-Host "To encrypt the secret, you need libsodium library." -ForegroundColor Yellow
Write-Host "Recommended: Use GitHub web interface or GitHub CLI (gh)" -ForegroundColor Yellow
Write-Host ""
Write-Host "Manual setup:" -ForegroundColor Cyan
Write-Host "1. Go to: https://github.com/$Owner/$Repo/settings/secrets/actions" -ForegroundColor White
Write-Host "2. Click 'New repository secret'" -ForegroundColor White
Write-Host "3. Name: $SecretName" -ForegroundColor White
Write-Host "4. Value: [Your token]" -ForegroundColor White
Write-Host "5. Click 'Add secret'" -ForegroundColor White
Write-Host ""

# Alternative: Check if we can use GitHub CLI
Write-Host "Checking GitHub Actions status..." -ForegroundColor Yellow
$workflowsUrl = "https://api.github.com/repos/$Owner/$Repo/actions/runs"
$workflowsResponse = Invoke-RestMethod -Uri $workflowsUrl -Headers $headers -Method Get

if ($workflowsResponse.workflow_runs.Count -gt 0) {
    $latestRun = $workflowsResponse.workflow_runs[0]
    Write-Host ""
    Write-Host "Latest workflow run:" -ForegroundColor Green
    Write-Host "  Status: $($latestRun.status)" -ForegroundColor White
    Write-Host "  Conclusion: $($latestRun.conclusion)" -ForegroundColor White
    Write-Host "  URL: $($latestRun.html_url)" -ForegroundColor Cyan
    Write-Host ""
}

