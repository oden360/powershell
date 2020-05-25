<#
.Synopsis
   create home directory
.DESCRIPTION
   this commande generates a home directory folder  in the given path, if this folder already exsists it will
   set the correct settings. It has a option to hide the sharefile.
#>
function add-nlhomedir
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Path,

         [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   parametersetname="visable",
                   Position=1)]
         [ValidateNotNullOrEmpty()]
        [Switch]$visable=$false
    )

    Begin
    {
    $al=@{
         "Itemtype" = "directory";
        }
    }
    Process
    {
        try
        {
           $dir= new-item  -Path $path  @al -ErrorAction stop | set-nlhomedirpermissions | set-nlsharepermissions -visable:$visable
           Write-Output $dir
        }
        catch [System.Net.WebException],[System.Exception]
        {
            Write-Warning 'This folder already exists editing existing folder'
            $dir=Get-Item -Path $Path | set-nlhomedirpermissions | set-nlsharepermissions -visable:$visable
            Write-Output $dir
        }
    }
}

