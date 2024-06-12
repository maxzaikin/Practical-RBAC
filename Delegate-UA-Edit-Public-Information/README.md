# Delegate-UA-Edit-Public-Information.ps1

## Synopsis

This PowerShell script delegates permissions to edit basic user attributes (public information) to a specified Active Directory group for a specific OU.

## Notes

This script adds a note to the role's description field for audit and tracking purposes.

## Expected Behaviour

The script delegates the "Write Property" permission to the specified group for the **Public Information** property set. This allows group members to modify the following user attributes:

**Public Information Set (GUID: E48D0154-BCF8-11D1-8702-00C04FB96050)**

*   `displayName` -  Display name of the user, often used for user logins and directory listings.
*   `personalTitle` -  Professional title or designation of the user (e.g., "Manager", "Engineer").
*   `givenName` (First Name) -  First name of the user.
*   `initials` -  User's initials.
*   `sn` (Last Name) -  Last name of the user.
*   `physicalDeliveryOfficeName` -  The user's office location.
*   `telephoneNumber` - Primary phone number of the user.
*   `otherTelephone` -  Additional phone numbers of the user.
*   `mail` -  Email address of the user.
*   `wwwHomePage` -  URL of the user's website or homepage.
*   `co` (Country) -  Country of the user.
*   `department` -  The user's department within the organization.
*   `company` -  The user's company or organization.
*   `manager` -  The user's manager (linked to another user account).
*   `title` -  User's job title.

## Parameters

* **`-role_name`**: Name of the role (AD group) to which permissions are delegated. (Mandatory, Position 0)
* **`-ou`**: Distinguished name of the Organizational Unit (OU) where permissions are delegated. (Mandatory, Position 1)
* **`-WhatIf`**: Simulates changes without actually modifying Active Directory. (Optional)

## Example

```powershell
Delegate-UA-Edit-Public-Information -role_name 'Helpdesk_Tier1' -ou 'OU=Standard Users,DC=contoso,DC=com'
