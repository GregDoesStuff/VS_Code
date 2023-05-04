# Prompt the user to enter the start and end IP addresses to scan
$start_ip = Read-Host "Enter the start IP address"
$end_ip = Read-Host "Enter the end IP address"

# Calculate the total number of IP addresses to scan
$total_ips = [int]($end_ip.Substring($end_ip.LastIndexOf(".") + 1)) - [int]($start_ip.Substring($start_ip.LastIndexOf(".") + 1)) + 1
$total_ports = 100

# Loop through the IP addresses and ping each one
$up_ips = @()
for ($i = [int]($start_ip.Substring($start_ip.LastIndexOf(".") + 1)); $i -le [int]($end_ip.Substring($end_ip.LastIndexOf(".") + 1)); $i++) {
    $ip_address = $start_ip.Substring(0, $start_ip.LastIndexOf(".") + 1) + $i.ToString()
    if (Test-Connection -ComputerName $ip_address -Count 1 -Quiet) {
        Write-Host "$ip_address is up"
        $up_ips += $ip_address
    }
    
    # Update the IP scan progress bar
    $ip_progress = [int](($i - [int]($start_ip.Substring($start_ip.LastIndexOf(".") + 1)) + 1) * 100 / $total_ips)
    Write-Progress -Activity "Scanning IP addresses and ports" -PercentComplete $ip_progress -Status "Scanning IP address $ip_address" -CurrentOperation "Scanning IP address $ip_address" 
}

# Loop through the up IPs and scan ports
foreach ($ip in $up_ips) {
    Write-Host "Scanning ports for $ip ..."
    $ports = 1..100
    $total_ports = $ports.Count
    $count = 0
    foreach ($port in $ports) {
        $count++
        $result = Test-NetConnection -ComputerName $ip -Port $port -WarningAction SilentlyContinue | Out-Null
        if ($result.TcpTestSucceeded) {
            Write-Host "Port $port is open on $ip"
        }
        elseif ($result.UdpTestSucceeded) {
            Write-Host "Port $port is listening on $ip"
        }
        
        # Update the progress bar for port scanning
        $port_progress = [int]($count * 100 / $total_ports)
        $ip_progress = [int](($up_ips.IndexOf($ip) + 1) * 100 / $up_ips.Count)
        Write-Progress -Activity "Scanning IP addresses and ports" -PercentComplete $ip_progress -Status "Scanning ports for $ip" -CurrentOperation "Testing port $port on IP address $ip" -PercentComplete $port_progress
    }
    
    # Write port scan results for the current IP address to file
    Write-Host "Results for ${ip}:"
    Get-NetTCPConnection -ComputerName $ip -State Listen | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort | Sort-Object LocalPort | Format-Table -AutoSize
    Write-Host ""
}
