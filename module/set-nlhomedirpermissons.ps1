<#
.Synopsis
       Set the folder permissions according to the ... principle
.DESCRIPTION
       Removes all the permissions of the given path folder and sets it to only admin and system
.EXAMPLE
       get-item <filepath> | set-nlhomedirpermissions
>
<# to do
    evaluate if the object is a directory
#>
function set-nlhomedirpermissions
{
    [CmdletBinding()]
    [OutputType([System.IO.FileSystemInfo])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileSystemInfo[]]$dirs
    )
    Begin
    {
        $rules = @(("NT AUTHORITY\SYSTEM","fullcontrol","allow"),("BUILTIN\Administrators","fullcontrol","allow"))
        $accesrules = $rules|foreach-object {New-Object System.Security.AccessControl.FileSystemAccessRule $_}
    }
    Process
    {
        foreach($dir in $dirs){
            $acl=get-acl $dir
            $acl.SetAccessRuleProtection($true,$false) # remove inheratance
            $acl.Access | %{$acl.RemoveAccessRule($_)} |Out-Null
            $accesrules| % {$acl.AddAccessRule($_)}   |Out-Null
            Set-Acl -path $dir.FullName -AclObject $acl
            Write-Output $dir
        }
    }

}

