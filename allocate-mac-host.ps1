# Script to automatically retry Mac host allocation until successful
# Checks both us-east-1a and us-east-1d every 5 minutes

$instanceType = "mac2-m2.metal"
$zones = @("us-east-1a", "us-east-1d")
$retryIntervalSeconds = 300  # 5 minutes

Write-Host "Starting Mac host allocation retry script..." -ForegroundColor Green
Write-Host "Instance Type: $instanceType" -ForegroundColor Cyan
Write-Host "Will check zones: $($zones -join ', ')" -ForegroundColor Cyan
Write-Host "Retry interval: $retryIntervalSeconds seconds" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

$attemptNumber = 1

while ($true) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] Attempt #$attemptNumber" -ForegroundColor White
    
    foreach ($zone in $zones) {
        Write-Host "  Trying $zone..." -ForegroundColor Gray
        
        $result = aws ec2 allocate-hosts --instance-type $instanceType --availability-zone $zone --auto-placement on --quantity 1 --output json 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "SUCCESS! Host allocated in $zone" -ForegroundColor Green
            Write-Host $result
            
            # Parse host ID from result
            $hostData = $result | ConvertFrom-Json
            if ($hostData.HostIds) {
                $hostId = $hostData.HostIds[0]
                Write-Host ""
                Write-Host "Host ID: $hostId" -ForegroundColor Cyan
                Write-Host ""
                Write-Host "Run this command to launch instance:" -ForegroundColor Yellow
                Write-Host "aws ec2 run-instances --instance-type $instanceType --host-id $hostId ..." -ForegroundColor White
            }
            
            exit 0
        }
        else {
            $errorMessage = $result | Out-String
            if ($errorMessage -like "*InsufficientHostCapacity*") {
                Write-Host "    No capacity available" -ForegroundColor DarkYellow
            }
            elseif ($errorMessage -like "*HostLimitExceeded*") {
                Write-Host "    Quota exceeded - stopping script" -ForegroundColor Red
                Write-Host $errorMessage
                exit 1
            }
            else {
                $errShort = $errorMessage.Substring(0, [Math]::Min(100, $errorMessage.Length))
                Write-Host "    Error: $errShort" -ForegroundColor Red
            }
        }
    }
    
    Write-Host "  All zones full. Waiting $retryIntervalSeconds seconds..." -ForegroundColor DarkGray
    Write-Host ""
    Start-Sleep -Seconds $retryIntervalSeconds
    $attemptNumber++
}
