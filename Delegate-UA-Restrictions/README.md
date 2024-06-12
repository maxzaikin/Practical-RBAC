# Delegate-UA-Restrictions.ps1

## Synopsis

This PowerShell script delegates permissions to manage user account restrictions to a specified Active Directory group for a specific OU.  This allows group members to edit account expiration dates for users within the designated OU. 

## Notes

This script adds a note to the role's description field for audit and tracking purposes.

## Expected Behaviour

The script delegates the "Write Property" permission to the specified group for the **Account Restrictions** property set, specifically for the `accountExpires` attribute. This allows group members to modify the account expiration date for users within the OU. 

The script is designed to ensure least privilege. Users granted this role can only manage account expiration dates and will not have permission to perform other actions like modifying passwords or other attributes.

It is important to consider the potential security risks associated with delegating this permission. If this is the only role granted to a group, those users will be restricted to account expiration management.

**To enable the newly created user account and configure additional permissions, either delegate those permissions to another group or user with broader privileges, or add those permissions to the current group.**

## Account Restrictions (GUID: 4C164200-20C0-11D0-A768-00AA006E0529)

This property set controls various account restrictions, including:

* **`logonHours`**:  Defines the allowed logon hours for the user. This allows you to restrict logon attempts to specific times.
* **`logonWorkstation`**:  Specifies the allowed workstations from which the user can log in. This restricts the user to specific devices.
* **`userAccountControl`**:  This attribute is a bitmask that controls several account settings, including:
* **`accountExpires`**:  This attribute defines the date and time when the account will expire. It allows you to set an expiration date for a user account.
* **`userWorkstations`**:  Specifies a list of workstations allowed for user logon.

## Parameters

* **`-role_name`**: Name of the role (AD group) to which permissions are delegated. (Mandatory, Position 0)
* **`-ou`**: Distinguished name of the Organizational Unit (OU) where permissions are delegated. (Mandatory, Position 1)
* **`-WhatIf`**: Simulates changes without actually modifying Active Directory. (Optional)

## Example

```powershell
Delegate-UA-Restrictions -role_name 'Helpdesk_Tier1' -ou 'OU=Standard Users,DC=contoso,DC=com'