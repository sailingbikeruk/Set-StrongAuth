Write-Host "Connecting MSOL Online" -ForegroundColor Green 
if (Get-MsolDomain -ErrorAction 'SilentlyContinue') { Write-Host "Connected to O365 MSOL Online" -ForegroundColor Green} 
else 
{
    Connect-MsolService 
    if(Get-MsolDomain -ErrorAction 'SilentlyContinue') {Write-Host "Connected to O365 MSOL Online" -ForegroundColor Green} 
    else {Write-Host "Can't Connect to O365 Online, exiting." -ForegroundColor Red ;exit}
}

Write-Host "settingPrePopulate" =-ForegroundColor Yello
$SMS = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationMethod
$SMS.IsDefault = $true
$SMS.MethodType = "OneWaySMS"
$Phone = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationMethod
$Phone.IsDefault = $false
$Phone.MethodType = "TwoWayVoiceMobile"
$PrePopulate = @($SMS, $Phone)

# Change this to import multiple users from CSV
# File must have one column only and the Header must read UserPrinicpalName
Write-Host "Importing Users" -ForegroundColor Yellow
$UserList = import-csv -path <put path here>

# I use these lines for re-doing odd accounts that fail, it's bad but I assume that $PrePopulate is still populated :)
# Set-MsolUser -UserPrincipalName <put UPN here> -StrongAuthenticationMethods $PrePopulate
# Get-Msoluser -UserPrincipalName <put UPN here> | select -expandproperty StrongAuthenticationMethods

write-host "Setting the Strong Authentication Method" -ForegroundColor White
foreach($User in $UserList)
{
    # This is the key line
    write-Host "setting authentication method for " $User.UPN
    Set-MsolUser -UserPrincipalName $User.UPN -StrongAuthenticationMethods $PrePopulate
}

write-Host "Getting the new settings" -ForegroundColor White
foreach($User in $UserList)
{
    # These line just confirm the change has been made they can be commented out in prod if required
    Write-Host "`n`nGetting Autentication methods for " $User.upn -ForegroundColor Yellow
    Get-Msoluser -UserPrincipalName $User.UPN | select -expandproperty StrongAuthenticationMethods
}
