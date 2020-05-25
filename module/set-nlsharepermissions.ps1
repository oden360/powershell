<#
.Synopsis
        Addes share permissions to folder according to ....
.DESCRIPTION

.EXAMPLE
        get-item <filepath> | set-nlsharepermissions
#>
function set-nlsharepermissions
{
    [CmdletBinding()]
    [OutputType([System.IO.FileSystemInfo])]
    Param
    (
        # Param1 help description
        [Parameter(
                   ValueFromPipeline=$true,
                   Position=0)]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileSystemInfo[]]$dirs,
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   parametersetname="visable",
                   Position=1)]

        [Switch]$visable=$false
    )
    begin
    {
        $at=@{
             "FullAccess"= (Get-ADDomain | Select-Object -expandProperty name)  + "\domain users";
             #full acces needs to stay first element
        }
    }
    Process
    {
        foreach($dir in $dirs)
        {
            $name=$dir.Name
            if (!($visable)){
                $name =($dir.Name +"$")
           }
           try
           {
               New-SmbShare -name $name  -Path $dir.FullName @at -ErrorAction stop |Out-Null
               Write-Output $dir
           }

           catch [System.Net.WebException],[System.Exception]
           {
               Write-Warning "share is already set adding permisson"
               Grant-SmbShareAccess -Name $name -AccountName $at.Values[0] -AccessRight Full -force |Out-Null
               Write-Output $dir
           }
        }
    }
}
