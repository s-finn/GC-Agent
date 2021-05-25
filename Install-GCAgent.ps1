<#

#>

$aggregatorIP =     [string]$aggregator[0], 
$installPass =      [string]$agentpass[1],
$installProfile =   [string]$profile[2]     
$FileDestination = "C:\windows\temp\windows_installer.exe"

################################################
# Adding certificate exception to prevent API errors
################################################
add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@

    Try{
    Invoke-WebRequest -uri "https://$aggregatorIP/windows_installer.exe?profile=$profile" -outfile $FileDestination
    }
    Catch [System.WebException] {
       Write-Verbose "An exception occurred: $($_.Exception.Message) "
    }

    Invoke-Expression -Command "$FileDestination /a $aggregatorIP /p $installPass /installation-profile $InstallProfile"

