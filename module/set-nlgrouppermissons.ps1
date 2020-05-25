<#
.Synopsis
   create and add groups to folder
.DESCRIPTION
   This function accepts a file system object/ object array. It will add groups following the ... .
   This entails that the naming contention is as followed
   adl-<filename>-fu /-m /-r

   The ntfs permissions are set for
        fu -> full control
        m  -> modify
        r  -> read and execute

.EXAMPLE
   get-item "c:/<file path>" | set-nlgrouppermissions
#>
<# to do
        make the OU domain local
#>
function set-nlgrouppermissions
{
    [CmdletBinding()]
    [OutputType([System.IO.FileSystemInfo])]
    Param(
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]

        [ValidateNotNullOrEmpty()]
        [System.IO.FileSystemInfo[]]$dirs
    )
    Begin
    {
        $domain=(Get-ADDomain -Current LocalComputer).name
        $suffix=@{'-fu'='fullcontrol';'-m'='modify';'-r' ='readandexecute'}

    }
    Process
    {
        foreach($dir in $dirs){
            $acl=get-acl $dir
            $path=Get-ADOrganizationalUnit -filter "name -like 'domain local'"| Select-Object -expandProperty DistinguishedName
            #check this to create groups
            $adgroups=$dirs|%{'adl-'+$_.Name}|%{foreach ($el in $suffix.Keys){ $_+$el}}
            try{
             $adgroups| % {New-ADGroup -path $path -Name $_  -GroupScope DomainLocal -GroupCategory Security }
             $accesrules = $adgroups|%{New-Object System.Security.AccessControl.FileSystemAccessRule ($_,$suffix.('-'+$_.split('-')[2]),"allow")}
             $accesrules| % {$acl.AddAccessRule($_)}  |Out-Null
             Set-Acl -path $acl.Path -AclObject $acl
            }
            catch{
             Write-Warning 'These groups exist... not adjusting anything'
            }
        Write-Output $dir
        }
    }
}
