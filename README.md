# Powershell
    Powershell scripts
    These are scripts to automate the management of window server

## Installation main machine
## Install hyper-V
    Install-windowsfeature hyper-v - includeallsubfeqtures -includemanagmenttools -restart
## Make parrent disk

## Installing form a parent disk
    New-VHD -ParentPath 'C:\hyper-v\parent disks\' -Path 'C:\hyper-v\child disks\'-Differencing
## Installing vm form installed disk
    New-VM -Name "test2" -MemoryStartupBytes 4096MB -VHDPath 'C:\hyper-v\child disks\test.vhdx' -Path 'C:\hyper-v\VM\' -Generation 2 -SwitchName 'private'

# Controlling vm
    Stop-VM -Name TestVM
    Start-VM - Name TestVM

    Stop-VM -Name TestVM -Passthru | Set-VM -ProcessorCount 2 -DynamicMemory -MemoryMaximumBytes 2GB -Passthru | Start-VM

## Creating new switch
    New-VMSwitch -name ExternalSwitch  -NetAdapterName Ethernet -AllowManagementOS $true
    New-VMSwitch -name InternalSwitch -SwitchType Internal
    New-VMSwitch -name PrivateSwitch -SwitchType Private

    Get-VMSwitch
## changing swith on running vm
    get-vm <vmname> |get-vmnetadapter |connect-vmnetworkadapter -switchname <switchname>
## Log in to the new domain controller
# Install ad-domain services and tools
    Add-windowsfeature ad-domain-services -includeservicetools
    Restart-computer
# Install forest
Install-ADDSForest -Domainname "<name>"
# install add
Install-addsdomaincontroller -Domainname "<name>" -credential (get credential)
# change username
       rename-computer <name>
# change ip
        new-netipaddress -ipaddress -prefixlength -defaultgateway -interfacealias
        set-dnsclientiserveraddress -interfaceindex -serveraddress
# Using powershell scripts
# getting items from csv
    $csv=import-csv <path> -delimiter (';')
    $ounames=($csv|%{$_.substring(0,1).toupper+$_.substring(1).tolower})|get-unique
## Installing modules
    Git clone https://github.com/oden360/powershell.git
    Place in powershell module
    Load scripts
### Adding users from file

### Adding home-directory
    Add-nlhomedir <directory path>
### Adding ad controlled folder
    Add-nlhomedir <directory path> -visable |set-nlgrouppermissions

