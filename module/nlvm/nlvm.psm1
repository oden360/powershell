<#
.Synopsis
  make a install
.DESCRIPTION
   this commande generates a home directory folder  in the given path, if this folder already exsists it will
   set the correct settings. It has a option to hide the sharefile.
#>
function install-vm
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # bool
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   Position=0)]
        [ValidateNotNullOrEmpty()]
        [switch]$iso=$false,
        # parrent path or iso
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        # name
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$name,
        # mem
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [ValidateNotNullOrEmpty()]
        [int64]$mem,
        # sw
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$sw,
 # size
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [ValidateNotNullOrEmpty()]
        [int64]$size


    )

    Begin
    {
        $vhdpath="C:\hyper-v\child disks\$name.vhdx"
        $vmpath="C:\hyper-v\VM\$name"
    }
    Process
    {
        try
        {
           if ($iso) {New-VHD -Path $vhdpath -SizeBytes $size}else{
             New-VHD -Path  $vhdpath -parentPath $path -SizeBytes $size
            }
            New-VM -Name $name -MemoryStartupBytes $mem -VHDPath $vhdpath -Path  $vmpath -Generation 2 -SwitchName $sw
        }

        catch [System.Net.WebException],[System.Exception]
        {
            Write-Warning 'something went wrong'
        }
    }
}
Export-ModuleMember -Function install-vm
