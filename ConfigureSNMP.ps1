#start and configure initial SNMP setup for new environment
# WORK IN PROGRESS
#
# Set traps under community names: "public & GCT#%*"
#localhost is OM's IP address
# must accept SNMP packets from any host
# finally restart the SNMP host


#variables
$servermanager = @("enter from Notepad for multiple servers")
$community = @("public & GCT#%*")

#import server manager
Import-Module ServerManager

#Check If SNMP Services Are Already Installed
$check = Get-WindowsFeature | Where-Object {$_.Name -eq "SNMP-Services"}
If ($check.Installed -ne "True") {
	#Install/Enable SNMP Services
	Add-WindowsFeature SNMP-Services | Out-Null
}

#Start SNMP
Start-Service SNMP $($servermanager)


