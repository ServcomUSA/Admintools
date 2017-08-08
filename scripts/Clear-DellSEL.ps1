<#
.Synopsis
   Backs up the SEL on a server to the specified location, then clears the file.

   POWERSHELL v.3.0 or higher required for this script. Not recommended for Windows Server versions lower than 2012.

.DESCRIPTION
   Backs up the SEL on a server to the specified location, then clears the file.

   Exit Code 1 = unable to find path to the toolset - check to see if the Dell OMSA tools are installed on this server
.EXAMPLE
   Will export the file to the specified location and will clear the log without further prompts

   Clear-DellSEL -BackupPath c:\users\username\documents -NoPrompt $true
.EXAMPLE
   Will export to the current user's Documents folder and wait for confirmation before clearing the file.
   
   Clear-DellSEL
#>


<#
    Debugging functions disabled. 
    TO ENABLE DEBUG: ctrl+H, replace "#Write-Debug" with "Write-Debug"
#>

#Requires -Version 3

function Clear-DellSEL
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # BackupPath - defaults to ~\Documents
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $BackupPath = "$HOME\Documents",

        # NoPrompt
        # defaults to $false
        # if $true, then will suppress a prompt to confirm deletion of SEL
        [bool]
        $NoPrompt = $false,
        
        
        # toolPath
        # location of the utilities - can be overridden if needed
        [string]
        $toolPath = "C:\Program Files\Dell\SysMgt\oma\bin"
    )

    Begin
    {
        #Write-Debug "Begin"
        #set output file
        $outputPath = ""
        
        if (Test-Path $HOME\Documents) {
            $outputPath = "$HOME\Documents"
        } 
        else {
        #hard-coded backup in case the first isn't available
            if (-not (Test-Path "c:\Dell_Logs")) {
                  mkdir c:\Dell_Logs
                  $outputPath = "c:\Dell_Logs"
            }
        }

        #Write-Debug $outputPath


        #only do this if the $toolPath is still at the defaul value!
        if ($toolPath -eq "C:\Program Files\Dell\SysMgt\oma\bin") {
            #Write-Debug "Checking path to toolset..."
           #double-check to make sure the x64 path is the correct one
            if (-not (Test-Path $toolPath)) {
                #Write-Debug "Checking alternate path to toolset..."

                #how about the x86 path?
                $toolPath = "C:\Program Files (x86)\Dell\SysMgt\oma\bin"       

                if (-not (Test-Path $toolPath)) {
                    #Write-Debug "Cannot find a path to the required tools. Check to see if OMSA is installed!"
                    #well, this ain't gonna work - quit
                    throw "Could not find path to OMSA installation. Please specify correct path."
                }
            }
        }

        #Write-Debug "Begin complete"

    }
    Process
    {
        #Write-Debug "Processing"
        #Write-Debug $outputPath
        #$toolPath = "C:\Program Files\Dell\SysMgt\oma\bin"
        

        if (Test-Path "$toolPath\omreport.exe") {
            cd $toolPath
            $filename = "esm_" + (Get-Date -Format yyyyMMdd) + ".txt"
            .\omreport.exe system esmlog -outc $outputPath\$filename
        }
        else {
            #Write-Debug "Utility omreport.exe not available at path: " $toolPath
        }

         # if $NoPrompt is false, wait for confirmation
        if ($NoPrompt -eq $false) {
            Read-Host 'Will now clear the Hardware Alert log. This cannot be undone. Press any key to continue' | Out-Null
        }
        

        if (Test-Path "$outputPath\$filename" ) {
            .\omconfig.exe system esmlog action=clear
        }

        #Write-Debug "Processing Complete"

    }
    End
    {
        
    }
}