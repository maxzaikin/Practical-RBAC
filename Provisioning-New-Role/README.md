# Provisioning-New-Role.ps1

## Synopsis

This PowerShell script creates a new RBAC role (group) in Active Directory, disables security inheritance for the role, and grants full control access to Enterprise Admins and Domain Admins while granting read-only access to authorized users.

## Notes

This script is designed to automate the provisioning of new RBAC roles in Active Directory, ensuring a secure and streamlined process. It is crucial to carefully consider the roles assigned and the members added to ensure proper security and functionality. 

This script implements the principle of least privilege. The newly created role is initially restricted, limiting potential impact in case of compromise.  

## Expected Behaviour

The script will:

1. **Create a new AD group** with the specified name, description, and path.
2. **Disable security inheritance** for the newly created role.
3. **Grant full control access** to the "Enterprise Admins" and "Domain Admins" groups.
4. **Grant read-only access** to users who are added to the group. 

## Parameters

* **`-role_name`**: Name of the new RBAC role (group). (Mandatory, Position 0)
* **`-role_description`**: Description for the new role. (Mandatory, Position 1)
* **`-role_ad_path`**:  Distinguished name path of the OU where the role should be created. (Mandatory, Position 2)
* **`-output_path`**: Path to save the log file. (Mandatory, Position 3)

## Example

```powershell
Provisioning-New-Role -role_name 'Role-Name' -role_description 'Description' -role_path 'OU=Roles,DC=contoso,DC=com' -output_path 'C:\Logs' -WhatIf