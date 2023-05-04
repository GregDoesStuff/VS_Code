# Prompt the user to enter the start and end IP addresses to scan
$start_ip = Read-Host "Enter the start IP address"
$end_ip = Read-Host "Enter the end IP address"

# Parse the IP address segments to integers
if (!([ipaddress]::TryParse($start_ip, [ref]$null)) -or !([ipaddress]::TryParse($end_ip, [ref]$null))) {
    Write-Host "Invalid IP address format"
    exit
}

# Calculate the total number of IP addresses to scan
$start_ip_int = [ipaddress]$start_ip
$end_ip_int = [ipaddress]$end_ip
$total_ips = $end_ip_int.Address - $start_ip_int.Address + 1
$total_ports = 100

# Create an empty list to store the up IP addresses
$up_ips = @()

# Loop through the IP addresses and ping each one
for ($i = $start_ip_int.Address; $i -le $end_ip_int.Address; $i++) {
    $ip_address = [ipaddress]$i
    
    if (Test-Connection -ComputerName $ip_address -Count 1 -Quiet) {
        Write-Host "$ip_address is up"
        
        # Add the up IP address to the list
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
        
        		# Write port scan results for the current IP address to file
        		"$port is open" | Out-File -FilePath "ipScanResults.txt" -Append
    		}
    		elseif ($result.UdpTestSucceeded) {
        		Write-Host "Port $port is listening on $ip_address"
        
        		# Write port scan results for the current IP address to file
        		"$port is listening" | Out-File -FilePath "ipScanResults.txt" -Append
    		}
    
    		# Update the progress bar for port scanning
    		$port_progress = [int]($count * 100 / $total_ports)
    		$ip_progress = [int](($i - $start_ip_int.Address + 1) * 100 / $total_ips)
    		Write-Progress -Activity "Scanning IP addresses and ports" -PercentComplete $ip_progress -Status "Scanning IP address $ip_address, Testing port $port" -CurrentOperation "Testing port $port on IP address $ip_address" -PercentComplete $port_progress
	    }
    }
    
    # Update the IP scan progress bar
    $ip_progress = [int](($i -
