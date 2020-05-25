#Powershell
powershell scripts
these are scripts to automate the management of window server

#Installation
## Install hyper-V
install-windowsfeature hyper-v - includeallsubfeqtures -includemanagmenttools -restart

##Installing form a parent disk
new-VHD -ParentPath 'C:\hyper-v\parent disks\' -Path 'C:\hyper-v\child disks\'-Differencing
##Installing vm form installed disk
New-VM -Name "test2" -MemoryStartupBytes 4096MB -VHDPath 'C:\hyper-v\child disks\test.vhdx' -Path 'C:\hyper-v\VM\' -Generation 2 -SwitchName 'private'

#Controlling vm
Stop-VM -Name TestVM
Start-VM - Name TestVM

Stop-VM -Name TestVM -Passthru | Set-VM -ProcessorCount 2 -DynamicMemory -MemoryMaximumBytes 2GB -Passthru | Start-VM

##Creating new switch
New-VMSwitch -name ExternalSwitch  -NetAdapterName Ethernet -AllowManagementOS $true
New-VMSwitch -name InternalSwitch -SwitchType Internal
New-VMSwitch -name PrivateSwitch -SwitchType Private

Get-VMSwitch

#Using powershell scripts
##Installing modules
git clone https://github.com/oden360/powershell.git
place in powershell module
load scripts
###Adding users from file

###Adding home-directory
add-nlhomedir <directory path>
###Adding ad controlled folder
add-nlhomedir <directory path>|set-nlgrouppermissions

