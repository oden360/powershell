$rulename="ttu"
$locala="192.168.0.0/16"
$remotea="192.168.0.0/16"
$authority="DC=den, DC=niels, CN=niels-CA-CA"
#$authority="ca.niels.den\niels-CA-CA"
$methode = 1

$qMProposal = New-NetIPsecQuickModeCryptoProposal -Encapsulation ESP -ESPHash SHA1 -Encryption DES3 
$qMCryptoSet = New-NetIPsecQuickModeCryptoSet -DisplayName "esp:sha1-des3"      -Proposal $qMProposal 
# = ca =
$NewCertProposal = New-NetIPsecAuthProposal -Machine -Cert -Authority $authority   -AuthorityType root 
# = kerberos =
#$NewCertProposal = New-NetIPsecAuthProposal -Machine -Kerberos 
New-NetIPSecRule -DisplayName $rulename -Mode Tunnel -LocalAddress $locala -RemoteAddress $remotea -InboundSecurity Require -OutboundSecurity Require -QuickModeCryptoSet $qMCryptoSet.Name -Phase1AuthSet $NewCertProposal
