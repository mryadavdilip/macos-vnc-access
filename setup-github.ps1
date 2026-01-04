# GitHub Setup Script for macOS VNC Access
# Run this script to complete the setup

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  macOS VNC Access - GitHub Setup" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Create GitHub repository
Write-Host "STEP 1: Create GitHub Repository" -ForegroundColor Yellow
Write-Host "---------------------------------------" -ForegroundColor Gray
Write-Host "1. Opening GitHub in your browser..."
Start-Process "https://github.com/new"
Write-Host ""
Write-Host "2. Fill in the form:" -ForegroundColor White
Write-Host "   - Repository name: macos-vnc-access" -ForegroundColor Gray
Write-Host "   - Description: macOS VNC access via GitHub Actions" -ForegroundColor Gray
Write-Host "   - Make it PUBLIC (required for free Actions)" -ForegroundColor Gray
Write-Host "   - Click 'Create repository'" -ForegroundColor Gray
Write-Host ""
Read-Host "Press ENTER after you've created the repository"

# Step 2: Get your GitHub username
Write-Host ""
Write-Host "STEP 2: Enter Your GitHub Username" -ForegroundColor Yellow
Write-Host "---------------------------------------" -ForegroundColor Gray
$githubUsername = Read-Host "Enter your GitHub username"

# Step 3: Push code
Write-Host ""
Write-Host "STEP 3: Pushing Code to GitHub" -ForegroundColor Yellow
Write-Host "---------------------------------------" -ForegroundColor Gray

$repoUrl = "https://github.com/$githubUsername/macos-vnc-access.git"
Write-Host "Setting remote URL: $repoUrl" -ForegroundColor Gray

git remote add origin $repoUrl 2>$null
if ($LASTEXITCODE -ne 0) {
    git remote set-url origin $repoUrl
}

Write-Host "Pushing code..." -ForegroundColor Gray
git push -u origin master

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "SUCCESS! Code pushed to GitHub" -ForegroundColor Green
    
    # Step 4: Trigger workflow
    Write-Host ""
    Write-Host "STEP 4: Starting macOS VNC Workflow" -ForegroundColor Yellow
    Write-Host "---------------------------------------" -ForegroundColor Gray
    Write-Host "Opening GitHub Actions page..." -ForegroundColor Gray
    Start-Process "https://github.com/$githubUsername/macos-vnc-access/actions"
    
    Write-Host ""
    Write-Host "1. Click on the 'macOS VNC Access' workflow" -ForegroundColor White
    Write-Host "2. Click 'Run workflow' button" -ForegroundColor White
    Write-Host "3. Click the green 'Run workflow' button" -ForegroundColor White
    Write-Host "4. Click on the workflow run to see details" -ForegroundColor White
    Write-Host "5. Look for the VNC connection details in the logs" -ForegroundColor White
    Write-Host ""
    
    # Optional: Setup ngrok token
    Write-Host ""
    Write-Host "OPTIONAL: Setup ngrok Token (Recommended)" -ForegroundColor Yellow
    Write-Host "---------------------------------------" -ForegroundColor Gray
    Write-Host "For better performance, add an ngrok token:" -ForegroundColor White
    Write-Host "1. Sign up at https://ngrok.com (free)" -ForegroundColor Gray
    Write-Host "2. Get your authtoken from https://dashboard.ngrok.com/get-started/your-authtoken" -ForegroundColor Gray
    Write-Host "3. Add it to GitHub Secrets:" -ForegroundColor Gray
    Start-Process "https://github.com/$githubUsername/macos-vnc-access/settings/secrets/actions/new"
    Write-Host "   - Name: NGROK_AUTH_TOKEN" -ForegroundColor Gray
    Write-Host "   - Value: [paste your ngrok token]" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host "  Setup Complete!" -ForegroundColor Green
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "The workflow will provide:" -ForegroundColor White
    Write-Host "  • VNC URL (from ngrok tunnel)" -ForegroundColor Cyan
    Write-Host "  • Password: Dilip@2026" -ForegroundColor Cyan
    Write-Host "  • Username: runner" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Download VNC Viewer: https://www.realvnc.com/download/viewer/" -ForegroundColor Yellow
    Write-Host ""
    
} else {
    Write-Host ""
    Write-Host "ERROR: Failed to push code" -ForegroundColor Red
    Write-Host "You may need to authenticate with GitHub" -ForegroundColor Yellow
    Write-Host "Try running: git push -u origin master" -ForegroundColor White
}
