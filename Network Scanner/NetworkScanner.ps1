# Prompt the user to enter the start and end IP addresses to scan
$start_ip = Read-Host "Enter the start IP address"
$end_ip = Read-Host "Enter the end IP address"

# Calculate the total number of IP addresses to scan
$total_ips = [int]($end_ip.Substring($end_ip.LastIndexOf(".") + 1)) - [int]($start_ip.Substring($start_ip.LastIndexOf(".") + 1)) + 1
$total_ports = 100

# Create the ipScanResults file and clear its contents
$ipScanResultsPath = ".\ipScanResults.txt"
New-Item -ItemType File -Path $ipScanResultsPath -Force | Out-Null
Clear-Content $ipScanResultsPath

# Loop through the IP addresses and ping each one
foreach ($i in ($start_ip..$end_ip)) {
    $ip_address = $i
    if (Test-Connection -ComputerName $ip_address -Count 1 -Quiet) {
        Write-Host "$ip_address is up"

        # Loop through ports 1-100 and test each one
        $ports = 1..100
        $total_ports = $ports.Count
        $count = 0
        foreach ($port in $ports) {
            $count++
            $result = Test-NetConnection -ComputerName $ip_address -Port $port -WarningAction SilentlyContinue | Out-Null
            if ($result.TcpTestSucceeded) {
                $portResult = "Port $port is open on $ip_address"
                Write-Host $portResult
                $portResult | Out-File -FilePath $ipScanResultsPath -Append
            }
            elseif ($result.UdpTestSucceeded) {
                $portResult = "Port $port is listening on $ip_address"
                Write-Host $portResult
                $portResult | Out-File -FilePath $ipScanResultsPath -Append
            }

            # Update the progress bar for port scanning
            $port_progress = [int]($count * 100 / $total_ports)
            $ip_progress = [int](($i - [int]$start_ip + 1) * 100 / $total_ips)
            Write-Progress -Activity "Scanning IP addresses and ports" -PercentComplete $ip_progress -Status "Scanning IP address $ip_address, Testing port $port" -CurrentOperation "Testing port $port on IP address $ip_address" -PercentComplete $port_progress
        }
    }

    # Update the IP scan progress bar
    $ip_progress = [int](($i - [int]$start_ip + 1) * 100 / $total_ips)
    Write-Progress -Activity "Scanning IP addresses and ports" -PercentComplete $ip_progress -Status "Scanning IP address $ip_address" -CurrentOperation "Scanning IP address $ip_address" 
}

# Read the contents of the ipScanResults file and display them on the console
$results = Get-Content -Path $ipScanResultsPath
Write-Host "IP Scan Results:"
Write-Host $results
