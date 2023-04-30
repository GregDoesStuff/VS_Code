# Set the start and end IP addresses
$start_ip = "192.168.0.1"
$end_ip = "192.168.0.20"

# Loop through the IP addresses and ping each one
for ($i = [int]($start_ip.Substring($start_ip.LastIndexOf(".") + 1)); $i -le [int]($end_ip.Substring($end_ip.LastIndexOf(".") + 1)); $i++) {
    $ip_address = "192.168.0." + $i
    if (Test-Connection -ComputerName $ip_address -Count 1 -Quiet) {
        Write-Host "$ip_address is up"
    }
    else {
        Write-Host "$ip_address is down"
    }
}
