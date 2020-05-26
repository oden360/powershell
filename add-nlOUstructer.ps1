<#
.Synopsis
   Short description
.DESCRIPTION
  This function will add all ous form a string every ou will have 
  subous users and computers
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
# use the name match algorithem function !!!!
function add-nlOUstructer
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   Position=0)]
        [String[]]$OUelements
       
       
    )
#'C:\Users\Administrator\Documents\names.csv'
    Begin
    {
          $domain=Get-ADDomain -Current LocalComputer
          $path='OU='+$domain.NetBIOSName+','+$domain.DistinguishedName
          $subou=@('users','computers')
    }
    Process
    {  try{
        $newOU=$OUelements|%{ New-ADOrganizationalUnit -Path $path -Name $_}
         }
       catch{
         Write-Warning "The OU $OUelements already exists editing existing OU "
         $newOU=$OUelements|%{ Get-ADOrganizationalUnit -Identity ('OU='+$_+','+$path)}
       }
       try{
        $subou|%{ New-ADOrganizationalUnit -Path $newou.distinguishedname -Name $_}
         }
       catch{
         Write-Warning "The sub ou $subou of $OUelements already exists "
       }
    }
    End
    {
    }
}