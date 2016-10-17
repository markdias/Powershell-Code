#PingHosts

Function Ping-Computer
{
	Param (
		
		[String]$Computername,
		[String]$Export = "No"
		
	)
	$result = @()
	$conn = Test-Connection -ComputerName $Computername -Quiet -Count 1
	$PCDetails = Get-ADComputer -Filter 'Name -eq $Computername' -Properties extensionAttribute12, Modified, location
	Try
	{
		$dns = [System.Net.Dns]::GetHostEntry($Computername)
		$dns_host = $dns.HostName
		$dns_ip = $dns.AddressList | select -ExpandProperty IPAddressToString
		
		
		
		
	}
	Catch
	{
		$dns_host = "No DNS Record"
		$dns_ip = "No IP Address"
	}
	
	
	$HostObj = New-Object PSObject -Property @{
		Host = $Computername
		IP = $dns_ip
		DNSHost = $dns_host
		Online = $conn
		Enabled = $PCDetails.Enabled
        Disabled = $PCDetails.extensionAttribute12
        Location = $PCDetails.location
		OU = $PCDetails.DistinguishedName
		Description = $PCDetails.Description
		LastModified = $PCDetails.Modified
	}
	
	$result += $HostObj
	
	$result
	If ($Export -eq "Yes")
	{
		$result | Export-Csv c:\temp\list1.csv -NoTypeInformation -Append
	}
}

$Data = (Get-ADComputer -Filter * -SearchBase "DC=com").Name
#$Data = (get-content "c:\temp\pcs.txt")
foreach ($Computer in $Data)
{
	Ping-Computer -Computername $Computer -Export Yes
}
