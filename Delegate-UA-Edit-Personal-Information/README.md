# Delegate-UA-Edit-Personal-Information.ps1

## Synopsis

This PowerShell script delegates permissions to edit basic user attributes (personal information) to a specified Active Directory group for a specific OU.

## Notes

This script adds a note to the role's description field for audit and tracking purposes.

## Expected Behaviour

The script delegates the "Write Property" permission to the specified group for the **Personal Information** property set. This allows group members to modify the following user attributes:

**Personal Information Set (GUID: 77B5B886-944A-11D1-AEBD-0000F80367C1)**

*   `givenName` (First Name)
*   `sn` (Last Name)
*   `telephoneNumber`
*   `mail`
*   `physicalDeliveryOfficeName`
*   `postalAddress`
*   `streetAddress`
*   `l` (Locality)
*   `st` (State or Province)
*   `co` (Country)
*   `postalCode`
*   `postOfficeBox`
*   `initials`
*   `info`
*   `description`

## Parameters

* **`-role_name`**: Name of the role (AD group) to which permissions are delegated. (Mandatory, Position 0)
* **`-ou`**: Distinguished name of the Organizational Unit (OU) where permissions are delegated. (Mandatory, Position 1)
* **`-WhatIf`**: Simulates changes without actually modifying Active Directory. (Optional)

## Example

```powershell
Delegate-UA-Edit-Personal-Information -role_name 'Helpdesk_Tier1' -ou 'OU=Standard Users,DC=contoso,DC=com'
