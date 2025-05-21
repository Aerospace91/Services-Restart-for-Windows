# ==========================
# Service Restart Script by https://github.com/tonytech95
# ==========================

# --- Configurable Variables ---
$ServiceName       = "spooler"
$LogFile           = Join-Path $PSScriptRoot "service_restart.log"
$InitialWaitSec    = 300
$WaitIntervalSec   = 5
$MaxWaitIter       = 36   # 36*5=180 seconds max wait for stop

function Write-Log($Message) {
    $timestamp = Get-Date -Format "[yyyy-MM-dd HH:mm:ss]"
    Add-Content -Path $LogFile -Value "$timestamp $Message"
}

# --- Log Script Start ---
Write-Log "Script started. Waiting $InitialWaitSec seconds before restart."

# --- Initial Wait ---
Start-Sleep -Seconds $InitialWaitSec

# --- Stop Service ---
Write-Log "Attempting to stop service '$ServiceName'..."
try {
    Stop-Service -Name $ServiceName -ErrorAction Stop
} catch {
    Write-Log "WARNING: Service '$ServiceName' may not have stopped on first attempt. $_"
}

# --- Wait for Service to Stop (with timeout) ---
$iter = 0
while ($true) {
    $status = (Get-Service -Name $ServiceName).Status
    if ($status -eq 'Stopped') {
        break
    }
    $iter++
    if ($iter -ge $MaxWaitIter) {
        Write-Log "ERROR: Timeout waiting for service '$ServiceName' to stop."
        exit 2
    }
    Start-Sleep -Seconds $WaitIntervalSec
}
Write-Log "Service '$ServiceName' stopped."

# --- Start Service ---
Write-Log "Starting service '$ServiceName'..."
try {
    Start-Service -Name $ServiceName -ErrorAction Stop
} catch {
    Write-Log "ERROR: Failed to start service '$ServiceName'. $_"
    exit 3
}

# --- Confirm Service Running ---
$status = (Get-Service -Name $ServiceName).Status
if ($status -ne 'Running') {
    Write-Log "ERROR: Service '$ServiceName' failed to start properly."
    exit 4
} else {
    Write-Log "Service '$ServiceName' started successfully."
}

# --- Script Complete ---
Write-Log "Script completed successfully."
exit 0
