# Prompt the user to enter the start and end IP addresses to scan
$start_ip = Read-Host "Enter the start IP address"
$end_ip = Read-Host "Enter the end IP address"

# Calculate the total number of IP addresses to scan
$total_ips = [int]($end_ip.Substring($end_ip.LastIndexOf(".") + 1)) - [int]($start_ip.Substring($start_ip.LastIndexOf(".") + 1)) + 1
$total_ports = 100

# Create a list to store the up IP addresses
$up_ips = @()

# Loop through the IP addresses and ping each one
for ($i = [int]($start_ip.Substring($start_ip.LastIndexOf(".") + 1)); $i -le [int]($end_ip.Substring($end_ip.LastIndexOf(".") + 1)); $i++) {
    $ip_address = $start_ip.Substring(0, $start_ip.LastIndexOf(".") + 1) + $i.ToString()
    if (Test-Connection -ComputerName $ip_address -Count 1 -Quiet) {
        Write-Host "$ip_address is up"
        $up_ips += $ip_address
    }
    
    # Update the IP scan progress bar
    $ip_progress = [int](($i - [int]($start_ip.Substring($start_ip.LastIndexOf(".") + 1)) + 1) * 100 / $total_ips)
    Write-Progress -Activity "Scanning IP addresses" -PercentComplete $ip_progress -Status "Scanning IP address $ip_address" -CurrentOperation "Scanning IP address $ip_address" 
}

# Check if any IP addresses were found to be up
if ($up_ips.Count -eq 0) {
    Write-Host "No IP addresses found to be up."
}
else {
    # Loop through the up IP addresses and scan each one for open ports
    foreach ($ip in $up_ips) {
        Write-Host "Results for ${ip}:"
        
        # Loop through ports 1-100 and test each one
        $ports = 1..100
        $total_ports = $ports.Count
        $count = 0
        foreach ($port in $ports) {
            $count++
            $result = Test-NetConnection -ComputerName $ip -Port $port -WarningAction SilentlyContinue | Out-Null
            if ($result.TcpTestSucceeded) {
                Write-Host "Port $port is open"
            }
            elseif ($result.UdpTestSucceeded) {
                Write-Host "Port $port is listening"
            }
            
            # Update the progress bar for port scanning
            $port_progress = [int]($count * 100 / $total_ports)
            Write-Progress -Activity "Scanning IP addresses and ports" -PercentComplete $ip_progress -Status "Scanning IP address $ip, Testing port $port" -CurrentOperation "Testing port $port on IP address $ip" -PercentComplete $port_progress
        }
        
        # Notify the user when port scanning for an IP address is complete
        Write-Host "Port scanning for IP address $ip is complete."
    }
}
