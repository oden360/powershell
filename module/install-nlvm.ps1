# Set VM Name, Switch Name, and Installation Media Path.
$VMName = ‘London’
$Switch = ‘BlackwaterConfig’
$InstallMedia = ‘C:\Software\en_windows_server_2016_x64_dvd_9718492.iso’

# Create New Virtual Machine
New-VM -Name $VMName -MemoryStartupBytes 4GB -Generation 2 -NewVHDPath “C:\BlackwaterConfig\Virtual Machines\$VMName\$VMName.vhdx” -NewVHDSizeBytes 30GB -Path “C:\BlackwaterConfig\Virtual Machines\$VMName” -SwitchName $Switch

# Add DVD Drive to Virtual Machine
Add-VMScsiController -VMName $VMName
Add-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path $InstallMedia

# Mount Installation Media
$DVDDrive = Get-VMDvdDrive -VMName $VMName

# Configure Virtual Machine to Boot from DVD
Set-VMFirmware -VMName $VMName -FirstBootDevice $DVDDrive

