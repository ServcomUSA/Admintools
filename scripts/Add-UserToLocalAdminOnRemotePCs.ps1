#change this target group name, as appropriate
# may not work w/o the ''
$groupName = 'Administrators'

#set this to a list of servers/computers you want to change
$servers = "sever1", "server2"

# if $true, will prompt you before making change to group member
# change to $false if you are feeling lucky
$confirm = $true


#######
## The good stuff is below
## Set your values above before executing this!!
## WKR - 08-29-2019
######

$creds = Get-Credential

$servers | foreach-object{
    Write-Host "-----------"
    $session = New-PSSession -ComputerName $_ -Credential $creds
    Invoke-Command -Session $session -ScriptBlock {$before = Get-LocalGroupMember -Group $Using:groupName;
        Write-Host "Current Group Members on" $Using:_
        $before | foreach-object{
            Write-Host $_.Name;
        }
        if ($Using:confirm){
            Add-LocalGroupMember -Group $Using:groupName -Member $Using:newAdmin -Confirm;
        } else {
            Add-LocalGroupMember -Group $Using:groupName -Member $Using:newAdmin;
        }
        $after = Get-LocalGroupMember -Group $Using:groupName;
        #Write-Host $Using:newAdmin "added to Administrators";
        Write-Host "After script Execution:";
        $after | foreach-object{
            Write-Host $_.Name;
        }
    }

    Remove-PSSession $session
}