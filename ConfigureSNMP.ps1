#start and configure initial SNMP setup for new environment
#
#NOT FOR PRODUCTION USE
#Currently in testing
#
# Select all agent services
# Set traps under community names: "public & GCT#%*"
# localhost is OM's IP address
# must accept SNMP packets from any host
# finally restart the SNMP host

#use Invoke-Command -ComputerName pc1, pc2 -FilePath "script path"


#variables
$path = null
$OMaddress = @("internal IP address of OM")


#import server manager
Import-Module ServerManager

#Check If SNMP Services Are Already Installed
$check = Get-WindowsFeature | Where-Object {$_.Name -eq "SNMP-Services"}
If ($check.Installed -ne "True") {
	#Install/Enable SNMP Services
	Add-WindowsFeature SNMP-Services | Out-Null
}

#Select all agent services for SNMP
$path = 'HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\RFC1156Agent\' 
Set-ItemProperty -Path $path -Name sysServices  -Value 79

#Set traps to public and GCT#%*

$path = 'HKCU:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration\public'
if(!(Test-Path -Path $path))
{
    New-Item -Path $path
}

$path = 'HKCU:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration\GCT#%*'
if(!(Test-Path -Path $path))
{
    New-Item -Path $path
}

#Set GCT#%* trap destination to localhost and to OM's IP address
Set-ItemProperty -Path $path -Name 1  -Value localhost
Set-ItemProperty -Path $path -Name 2  -Value $OMaddress

#Set to accept packets from any host
Remove-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers' -Name *

#Restart SNMP
Restart-Service SNMP $($servermanager)


