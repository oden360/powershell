# Powershell
    Powershell scripts
    These are scripts to automate the management of window server

# Installation
## Install hyper-V
    Install-windowsfeature hyper-v - includeallsubfeqtures -includemanagmenttools -restart

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

# Using powershell scripts
## Installing modules
    Git clone https://github.com/oden360/powershell.git
    Place in powershell module
    Load scripts
### Adding users from file

### Adding home-directory
    Add-nlhomedir <directory path>
### Adding ad controlled folder
    Add-nlhomedir <directory path>|set-nlgrouppermissions

