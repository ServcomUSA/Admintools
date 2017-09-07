
<#
.Synopsis
   Does a ping and DNS lookup on an object
.DESCRIPTION
   Can resolve both FQDN and IP Addresses
.EXAMPLE
PS C:\dev\ScriptHeap\Cloud Scripts> Test-PingAndDNSLookup -TargetList localhost

                  DNSValueFound DNSValue                                               RespondedToPing Target                               
                  -------------------- ---------------                                               --------------- ------                               
                                  True {localhost, localhost}                                                   True localhost  
.EXAMPLE
PS C:\> Test-PingAndDNSLookup 192.168.1.254

                  DNSValueFound DNSValue                                               RespondedToPing Target                               
                  -------------------- ---------------                                               --------------- ------                               
                                  True 254.1.168.192.in-addr.arpa                                              False 192.168.1.254                        

.INPUTS
   TargetList: Takes an input of string(s). Strings can be either IP addresses or FQDNs, or a mix of both. Accepts $TargetList from Pipeline.
   DnsServer: Takes a single DNS server by IP or FQDN. Can be used to override default DNS server on the host. If blank, defaults to the default DNS server on the host.
.OUTPUTS
   Outputs a PSCustomObject consisting of [string]Target, [bool]RespondedToPing, [string]dnsServer, [bool]DNSValueFound, and [string]DNSValue
#>
function Test-PingAndDNSLookup
{
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  ConfirmImpact='Low')]
    [OutputType([PSCustomObject])]
    Param
    (
        # List of IPs or FQDNs to test
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Parameter Set 1')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Alias("IPAddress", "ComputerName")] 
        [string[]] $TargetList,

        #Optional - specify a specific DNS server
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=1,
                   ParameterSetName='Parameter Set 1')]
        [string]$DnsServer = "$null"

    )

    Begin
    {
        #initialize some vars
        $results = @()
        [bool]$PingResult = $false
        [bool]$rDNSresult = $false
        $dnsLookupResult = ""

        #check $dnsServer value, assign a default if not specified
        if ($dnsServer -eq "$null") {
            $dnsServerSearchOrder = Get-DnsClientServerAddress | Select-Object -ExpandProperty ServerAddresses
            
            #rational checks on possibly bad DNS server results

            #no DNS servers listed - warn, but continue
            if ($dnsServerSearchOrder.Length -lt 1) {Write-Warning "Invalid or no DNS servers configured on host. DNS lookups may fail."}
            
            $dnsServer = $dnsServerSearchOrder[0]
        }
        
    }
    Process
    {
        foreach ($target in $targetList) {

            #this section could use some graceful Try/catch stuff, in case obviously bad params are passed

            if ($pscmdlet.ShouldProcess("$target", "Ping and Resolve DNS Against $target")) 
            {
                $PingResult = (Test-Connection -Count 1 -ComputerName $target -Quiet)
                
                #decide if we want a forward or reverse DNS value, based on $target
                if ($target -as [ipaddress]) {
                    #default to "Name" (reverse DNS) - assuming we are being passed an IP Address
                    $dnsLookupType = "Name"
                    $dnsLookupResult = Resolve-DnsName $target -Server $DnsServer
                } else {
                    #if this isn't specifically an IP address, we fail back and assume this is an FQDN, instead
                    #switch the lookup type to "IPAddress" (forward)
                    $dnsLookupType = "IPAddress"
                    $dnsLookupResult = Resolve-DnsName $target -type A -Server $DnsServer
                }
               
                $dnsLookupResult = $dnsLookupResult | Select-Object $dnsLookupType

                if ($dnsLookupResult -eq $null) { $rDNSresult = $false }
                else {$rDNSresult = $true }

                

  
            $obj = New-Object PSCustomObject -Property @{
                Target = $target;
                RespondedToPing = $PingResult;
                DNSValueFound = $rDNSresult; 
                DNSValue = $dnsLookupResult;
                DnsServer = $dnsServer
                }
            $results += ($obj)
            }
        }
    }
    End
    {
        $results | Format-Table -Property Target, RespondedToPing, DnsServer, DNSValueFound, DNSValue 
    }
}
