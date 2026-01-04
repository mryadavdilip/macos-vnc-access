$runId = "20692950760"

Write-Host "VNC Connection Monitor - Waiting for macOS to be ready..." -ForegroundColor Cyan
Write-Host "Workflow: https://github.com/mryadavdilip/macos-vnc-access/actions/runs/$runId" -ForegroundColor Gray
Write-Host ""

$attempts = 0
$maxAttempts = 120

while ($attempts -lt $maxAttempts) {
    $attempts++
    
    try {
        $logs = gh run view $runId --log 2>&1 | Out-String
        
        if ($logs -match 'VNC URL: (tcp://[^\s]+)') {
            $vncUrl = $matches[1]
            
            Write-Host ""
            Write-Host "SUCCESS! VNC CONNECTION READY!" -ForegroundColor Green
            Write-Host "======================================" -ForegroundColor Green
            Write-Host ""
            Write-Host "VNC URL:  $vncUrl" -ForegroundColor Cyan
            Write-Host "Password: Dilip@2026" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "Opening VNC Viewer download page..." -ForegroundColor Yellow
            Start-Process "https://www.realvnc.com/download/viewer/"
            
            $info = "VNC URL: $vncUrl`nPassword: Dilip@2026`nGenerated: $(Get-Date)"
            $info | Out-File "vnc-ready.txt"
            
            break
        }
        
        $status = gh run view $runId --json status,conclusion | ConvertFrom-Json
        if ($status.conclusion -eq "failure") {
            Write-Host "Workflow failed!" -ForegroundColor Red
            break
        }
        
        if ($attempts % 6 -eq 0) {
            $mins = [math]::Round($attempts / 6, 1)
            Write-Host "[$mins min] Waiting... (Status: $($status.status))" -ForegroundColor Gray
        }
    }
    catch {
    }
    
    Start-Sleep -Seconds 10
}

if ($attempts -ge $maxAttempts) {
    Write-Host "Timeout. Check manually: https://github.com/mryadavdilip/macos-vnc-access/actions" -ForegroundColor Yellow
}
