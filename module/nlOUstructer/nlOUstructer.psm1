<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
# validate that its always a pair of strings
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
        [String[]]$OUelements,

         [Parameter(Mandatory=$false,
                   #ValueFromPipeline=$true,
                   Position=1)]
         [Switch]$group=$false,

         [Parameter(Mandatory=$false,
                   #ValueFromPipeline=$true,
                   Position=2)]
         [Switch]$server=$fasle
    )
    Process{
        #get all the switch attribute objects
        $arguments=(Get-Command add-nlOUstructer).Parameters.Values |Where-Object SwitchParameter |%{ Get-Variable $_.Name -ErrorAction SilentlyContinue }
        $arguments|%{ if($_.Value){
                $OUelements+=$_.Name
        }
    }

       $OUelements|gen-NLouobject|add-nlOU

    }
}
<#
.Synopsis
   gen sub ou list
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function gen-NLouobject
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        $ous
    )

    Process
    {
     $ous|%{
       $SUBOU=Switch ($_){
                'group'{@('domain local','globalgroup');break}
                'server'{@('local','global');break}
                 default {@('users','computers');break}
            }
            [pscustomobject]@{ ou=$_;subou=$subou}
      }
    }
}

<#
.Synopsis
   Short description
.DESCRIPTION
  This function will add all ous form a string every ou will have
  subous users and computers
.EXAMPLE
   Example of how to use this cmdlet
#>
function add-nlOU
{
    [CmdletBinding()]
    [OutputType()]
    Param
    (
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   Position=0)]
        [PSCustomObject[]]$OUelements
    )
    Begin
    {
          $domain=Get-ADDomain -Current LocalComputer
          $path='OU='+$domain.NetBIOSName+','+$domain.DistinguishedName
    }
    Process
    {  try{
        $newOU=$OUelements|%{ New-ADOrganizationalUnit -Path $path -Name $_.ou -PassThru}
         }
       catch{
         $newOU=$OUelements|%{ Get-ADOrganizationalUnit -Identity ('OU='+$_.ou+','+$path)}
       }
       try{
        $OUelements.subou|%{ New-ADOrganizationalUnit -Path $newou.distinguishedname -Name $_}
         }
       catch{
       }
    }
}
Export-ModuleMember -Function add-nlOUstructer
