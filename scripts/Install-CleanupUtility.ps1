# installs the disk cleanup tool on a windows server

# defs
# 
#version, path
$exePath = @{
    # 2008
    "6.0x86" = "C:\Windows\winsxs\x86_microsoft-windows-cleanmgr_31bf3856ad364e35_6.0.6001.18000_none_6d4436615d8bd133\cleanmgr.exe";
    "6.0AMD64" = "C:\Windows\winsxs\amd64_microsoft-windows-cleanmgr_31bf3856ad364e35_6.0.6001.18000_none_c962d1e515e94269\cleanmgr.exe";
    # 2008 R2
    "6.1AMD64" = "C:\Windows\winsxs\amd64_microsoft-windows-cleanmgr_31bf3856ad364e35_6.1.7600.16385_none_c9392808773cd7da\cleanmgr.exe";
    # 2012
    "6.2AMD64" = "C:\Windows\winsxs\wow64_microsoft-windows-cleanmgr_31bf3856ad364e35_6.2.9200.16384_none_d06288181bb0c925\cleanmgr.exe";
    # 2012 R2
    "6.3AMD64" = "C:\Windows\WinSxS\amd64_microsoft-windows-cleanmgr_31bf3856ad364e35_6.3.9600.17031_none_5e3588b0315d2219\cleanmgr.exe"
}

$muiPath = @{
    # 2008
    "6.0x86" = "C:\Windows\winsxs\x86_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.0.6001.18000_en-us_5dd66fed98a6c5bc\cleanmgr.exe.mui";
    "6.0AMD64" = "C:\Windows\winsxs\amd64_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.0.6001.18000_en-us_b9f50b71510436f2\cleanmgr.exe.mui";
    # 2008 R2
    "6.1AMD64" = "C:\Windows\winsxs\amd64_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.1.7600.16385_en-us_b9cb6194b257cc63\cleanmgr.exe.mui";
    # 2012
    "6.2AMD64" = "C:\Windows\winsxs\amd64_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.2.9200.16384_en-us_b6a01752226afbb3\cleanmgr.exe.mui";
    # 2012 R2
    "6.3AMD64" = "C:\Windows\WinSxS\amd64_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.3.9600.17031_en-us_4ec7c23c6c7816a2\cleanmgr.exe.mui"
}

$version = ([environment]::OSVersion.Version.Major).ToString() + "." + ([environment]::OSVersion.Version.Minor).ToString()
$architecture = $ENV:PROCESSOR_ARCHITECTURE
$versionArchitecture = ""

#Write-Debug "Version: $version"
#Write-Debug "Proc: $architecture"

# determine OS version + proc architecture
# 2008 or 2008 r2

# creates a 3-character array, like '6.0'

if ($version[0] -ne "6") {
    #Write-Error "Major version number must be equal to 6 for this script to work. Check OS. Detected version number: $version"
}
else {
    $versionArchitecture = $version + $architecture    
   # Write-Debug "Version+Proc: $versionArchitecture"
} 

# check to see if cleanmgr.exe and cleanmgr.mui.exe exist, copy if either doesn't
if (-not(Test-Path $env:SystemRoot\System32\cleanmgr.exe)) { copy $exePath.Get_Item($versionArchitecture).ToString() $env:SystemRoot\System32\ }
if (-not(Test-Path $env:SystemRoot\System32\en-us\cleanmgr.exe.mui)) { copy $muiPath.Get_Item($versionArchitecture).ToString() $env:SystemRoot\System32\en-us\ }

# confirm

gci $env:SystemRoot\System32\cleanmgr.exe
gci $env:SystemRoot\System32\en-us\cleanmgr.exe.mui