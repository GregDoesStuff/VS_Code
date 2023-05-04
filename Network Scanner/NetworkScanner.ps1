# Prompt the user to enter the start and end IP addresses to scan
$start_ip = Read-Host "Enter the start IP address"
$end_ip = Read-Host "Enter the end IP address"

# Calculate the total number of IP addresses to scan
$total_ips = [int]($end_ip.Substring($end_ip.LastIndexOf(".") + 1)) - [int]($start_ip.Substring($start_ip.LastIndexOf(".") + 1)) + 1
$total_ports = 100

# Initialize the results file
$results_file = "ipScanResults.txt"
if (Test-Path $results_file) {
    Remove-Item $results_file
}

# Loop through the IP addresses and ping each one
for ($i = [int]($start_ip.Substring($start_ip.LastIndexOf(".") + 1)); $i -le [int]($end_ip.Substring($end_ip.LastIndexOf(".") + 1)); $i++) {
    $ip_address = $start_ip.Substring(0, $start_ip.LastIndexOf(".") + 1) + $i.ToString()
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
    	        $output = "Port $port is open on $ip_address"
    	        Write-Host $output
    	        Add-Content $results_file $output
    	    }
    	    elseif ($result.UdpTestSucceeded) {
    	        $output = "Port $port is listening on $ip_address"
    	        Write-Host $output
    	        Add-Content $results_file $output
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
