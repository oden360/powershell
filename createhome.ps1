<#
.Synopsis
   create home directory 
.DESCRIPTION
   this commande generates a home directory hidden filder in the given path, if this folder already exsists it will
   set the correct settings.
#>
# to do -> when you pipe a exicting file path the function keeps piping data to the next pipe gen erros 
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

         [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   parametersetname="hidden",
                   Position=1)]
         [ValidateNotNullOrEmpty()]
        [Switch]$hidden
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
           $dir= new-item  -Path $path  @al -ErrorAction stop | set-nlhomedirpermissions | set-nlsharepermissions -hidden:$hidden
           Write-Output $dir
        }
        catch [System.Net.WebException],[System.Exception]
        {
            Write-Warning 'This folder already exists editing existing folder'
           $dir=Get-Item -Path $Path | set-nlhomedirpermissions | set-nlsharepermissions -hidden:$hidden
            Write-Output $dir
        }
       
       
    }
    End
    {
    }
}

<#
.Synopsis
   Short description
.DESCRIPTION
   removes all the permissions of a the given path folder and sets it to only admin and system
.EXAMPLE
   Example of how to use this cmdlet
#>
<# to do 
    evaluate if the object is a directory
#>
function set-nlhomedirpermissions
{
    [CmdletBinding()]
    [OutputType([System.IO.FileSystemInfo])]
    Param
    (
        # Param1 help description
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

<#
.Synopsis
   add domain users to share
.DESCRIPTION
   this function adds the domain users as full control users
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
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
                   parametersetname="hidden",
                   Position=1)]
        
        [Switch]$hidden
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
            if ($hidden){
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