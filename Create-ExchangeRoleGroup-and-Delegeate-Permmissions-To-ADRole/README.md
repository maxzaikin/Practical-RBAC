# Create-ExchangeRoleGroup-and-Delegeate-Permmissions-To-ADRole.ps1

## Synopsis

This PowerShell script creates a new Exchange Role Group with specified roles and adds a specified AD member to this new group. The script logs the action in the member's description field.

## Notes

This script is designed to create and manage Exchange role groups, allowing for granular control over user permissions. It is important to carefully consider the roles assigned and the members added to ensure proper security and functionality.

## Expected Behaviour

The script creates a new role group in Exchange Server with the name specified in `-ExchangeRole` and assigns the roles listed in `-ExchangeRolesList` to it. It then adds the user or group specified in `-ADRole` to the membership of the newly created role group. The script also logs this action in the description field of the AD role object.

## Parameters

* **`-ExchangeRole`**: Name of the new Exchange role group. (Mandatory, Position 0)
* **`-ExchangeRolesList`**:  A list of Exchange roles to be assigned to the new role group. (Mandatory, Position 1)
* **`-Description`**: Description for the new role group. (Mandatory, Position 2)
* **`-ADRole`**: Distinguished name of the user or group to be added as a member to the exchange role group. (Mandatory, Position 3)
* **`-WhatIf`**: Simulates changes without actually modifying Active Directory. (Optional)

## Important to know

* Your AD group, which is going to be ad in the parameter `-ADRole` should not be LocalGroup scope. It either needs to be a Global or Universal scope, this is because exchang creates it's groups as Universal due to the varaety of reasons

## Audit Exchange Role Example

```powershell
Get-ManagementRoleEntry "[Exchange role]\*" | Format-Table -Property Name -Wrap -AutoSize
```

## Things to consider

You man want to restrict WEB access to EAC for specific IP's. Here is how you do it:

```powershell
# Create a custom management scope for IP restriction
$ipRange = "192.168.1.0/24" # Adjust this to your local network IP range
New-ManagementScope -Name "LocalNetworkEACAccess" -RecipientRestrictionFilter { ipaddress -eq $ipRange }

# Assign the custom management scope to the EAC role group
New-ManagementRoleAssignment -Name "LocalNetworkEACAccessAssignment" -SecurityGroup "Exchange EAC Access" -Role "View-Only Organization Management" -CustomRecipientWriteScope "LocalNetworkEACAccess"

# Create a rule to deny OWA access for local network users
$localNetworkIPRange = "192.168.1.0/24" # Adjust this to your local network
New-ClientAccessRule -Name "Deny OWA Access for Local Network" -Action DenyAccess -AnyOfClientIPAddressesOrRanges $localNetworkIPRange -AnyOfProtocols OWA
```

Here is what you need to include to yuour script if you goin to run it outside Exchahnge server:

```powershell
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn

# Import Exchange module
if (-not (Get-Module -ListAvailable -Name "ExchangeOnlineManagement")) {
    Install-Module -Name "ExchangeOnlineManagement" -Force -AllowClobber
}

Import-Module ExchangeOnlineManagement

# Connect to Exchange Online 
$UserCredential = Get-Credential
Connect-ExchangeOnline -UserPrincipalName $UserCredential.UserName 
```

## Create Custom Exchange Role

```powershell
# Create custom role based on existin standard role "Mail Recipients"
New-ManagementRole -Name "Custom Mail Recipients" -Parent "Mail Recipients"

# Define commands that needs to be excluded from custom role
$excludedCommands = @{
    "Remove-UserPhoto" = $true
    "Remove-SweepRule" = $true
    "Remove-OwaMailboxPolicy" = $true
    "Remove-MobileDevice" = $true
    "Remove-MailboxUserConfiguration" = $true
    "Remove-MailboxRepairRequest" = $true
    "Remove-MailboxPermission" = $true
    "Remove-MailboxLocation" = $true
    "Remove-MailboxFolderPermission" = $true
    "Remove-InboxRule" = $true
    "Remove-HybridConfiguration" = $true
    "Remove-ActiveSyncDevice" = $true
}

# Get "Mail Recipients" list fo commands
$entries = Get-ManagementRoleEntry "Mail Recipients\*"

# copying all commands excluding unwanted
foreach ($entry in $entries) {
    if (-not $excludedCommands.ContainsKey($entry.Name)) {
        New-ManagementRoleEntry -Identity ("Custom Mail Recipients\" + $entry.Name) -Parameters $entry.Parameters
    }
}

```

## Script Use Example

```powershell
Create-ExchangeRoleGroup-and-Delegeate-Permmissions-To-ADRole -ExchangeRole "Exchange Users Mailbox Management" -ExchangeRolesList @("Mail Recipients", "Mail Recipient Creation", "Recipient Policies") -Description "Role to manage mailboxes and distribution groups" -ADRole "YOUR AD ROLE"
```

## Permissions Tests

```powershell
# Create User mailbox
New-Mailbox -Name "John Doe" -UserPrincipalName johndoe@contoso.com -Password (ConvertTo-SecureString -String "super secret pasword" -AsPlainText -Force)
```

```powershell
# Change User mailbox
Set-Mailbox -Identity johndoe@contoso.com -DisplayName "John Doe - Sales"
```

```powershell
# Delete User mailbox
Remove-Mailbox -Identity johndoe@contoso.com
```

```powershell
# Create Distribution Group
New-DistributionGroup -Name "Sales Team" -PrimarySmtpAddress salesteam@contoso.com
```

```powershell
# Create Email Contact
New-MailContact -Name "External Partner" -ExternalEmailAddress partner@externaldomain.com
```

```powershell
# Create Address policy
New-EmailAddressPolicy -Name "Default Email Policy" -IncludedRecipients AllRecipients -Priority 1 -EnabledPrimarySMTPAddressTemplate "%g.%s@contoso.com"
```

```powershell
# Change Address policy
Set-EmailAddressPolicy -Identity "Default Email Policy" -EnabledPrimarySMTPAddressTemplate "%g.%s@newdomain.com"
```

```powershell
# Apply Address policy
Update-EmailAddressPolicy -Identity "Default Email Policy"
```