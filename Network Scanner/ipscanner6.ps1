# Prompt the user to enter the start and end IP addresses to scan
$start_ip = Read-Host "Enter the start IP address"
$end_ip = Read-Host "Enter the end IP address"

# Calculate the total number of IP addresses to scan
$total_ips = [int]($end_ip.Substring($end_ip.LastIndexOf(".") + 1)) - [int]($start_ip.Substring($start_ip.LastIndexOf(".") + 1)) + 1

# Loop through the IP addresses and ping each one
for ($i = [int]($start_ip.Substring($start_ip.LastIndexOf(".") + 1)); $i -le [int]($end_ip.Substring($end_ip.LastIndexOf(".") + 1)); $i++) {
    $ip_address = $start_ip.Substring(0, $start_ip.LastIndexOf(".") + 1) + $i.ToString()
    if (Test-Connection -ComputerName $ip_address -Count 1 -Quiet) {
        Write-Host "$ip_address is up"
        
        # Loop through ports 1-100 and test each one
        for ($port = 1; $port -le 100; $port++) {
            $result = Test-NetConnection -ComputerName $ip_address -Port $port -InformationLevel Quiet -ErrorAction SilentlyContinue
            if ($result -and $result.TcpTestSucceeded) {
                Write-Host "Port $port is open on $ip_address"
            }
            elseif ($result -and $result.UdpTestSucceeded) {
                Write-Host "Port $port is listening on $ip_address"
            }
        }
    }
    
    # Update the progress bar
    $progress = [int](($i - [int]($start_ip.Substring($start_ip.LastIndexOf(".") + 1)) + 1) * 100 / $total_ips)
    Write-Progress -Activity "Scanning IP addresses" -PercentComplete $progress
}
