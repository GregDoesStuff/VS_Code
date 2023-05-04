# Prompt the user to enter the start and end IP addresses to scan
$start_ip = Read-Host "Enter the start IP address"
$end_ip = Read-Host "Enter the end IP address"

# Create a list to store the IP addresses that are up
$up_ips = @()

# Loop through the IP addresses and ping each one
for ($i = [int]($start_ip.Substring($start_ip.LastIndexOf(".") + 1)); $i -le [int]($end_ip.Substring($end_ip.LastIndexOf(".") + 1)); $i++) {
    $ip_address = $start_ip.Substring(0, $start_ip.LastIndexOf(".") + 1) + $i.ToString()
    if (Test-Connection -ComputerName $ip_address -Count 1 -Quiet) {
        Write-Host "$ip_address is up"
        $up_ips += $ip_address
        
        # Loop through ports 1-100 and test each one
    	$ports = 1..100
    	$total_ports = $ports.Count
    	$count = 0
    	foreach ($port in $ports) {
        		$count++
        		$result = Test-NetConnection -ComputerName $ip_address -Port $port -WarningAction SilentlyContinue | Out-Null
        		if ($result.TcpTestSucceeded) {
            		Write-Host "Port $port is open on $ip_address"
            		"$ip_address,$port,open" | Out-File -FilePath "ipScanResults.txt" -Append
        		}
        		elseif ($result.UdpTestSucceeded) {
            		Write-Host "Port $port is listening on $ip_address"
            		"$ip_address,$port,listening" | Out-File -FilePath "ipScanResults.txt" -Append
        		}

        		# Update the progress bar for port scanning
        		$port_progress = [int]($count * 100 / $total_ports)
        		$ip_progress = [int](($i - [int]($start_ip.Substring($start_ip.LastIndexOf(".") + 1)) + 1) * 100 / $total_ips)
        		Write-Progress -Activity "Scanning IP addresses and ports" -PercentComplete $ip_progress -Status "Scanning IP address $ip_address, Testing port $port" -CurrentOperation "Testing port $port on IP address $ip_address" -PercentComplete $port_progress
    	}
    }
    
    # Update the IP scan progress bar
    $ip_progress = [int](($i - [int]($start_ip.Substring($start_ip.LastIndexOf(".") + 1)) + 1) * 100 / $total_ips)
    Write-Progress -Activity "Scanning IP addresses and ports" -PercentComplete $ip_progress -Status "Scanning IP address $ip_address" -CurrentOperation "Scanning IP address $ip_address" 
}

# Display the results for each up IP address
foreach ($ip in $up_ips) {
    Write-Host "Results for $ip:"
    Get-Content "ipScanResults.txt" | Where-Object {$_ -like "$ip,*"} | Sort-Object -Property @{Expression={$_.Split(',')[1]}; Ascending=$true} | Format-Table -Property @{Name="IP Address";Expression={$_.Split(',')[0]}},@{Name="Port";Expression={$_.Split(',')[1]}},@{Name="Status";Expression={$_.Split(',')[2]}}
}
