# Practical-RBAC

This repository provides practical scripts and examples for implementing Role-Based Access Control (RBAC) in Active Directory using PowerShell. The focus is on granular permissions, least privilege, and secure delegation of administrative rights.

## Introduction

RBAC is a security principle that grants users access to resources based on their roles within an organization. By implementing RBAC, you can:

* Enhance security by limiting user access to only what is necessary.
* Simplify administration by managing permissions based on roles, not individual users.
* Improve compliance by enforcing consistent access control policies.

This repository focuses on practical implementation using PowerShell scripts and examples for Active Directory.

**More about RBAC you can find in my article published on Linkedin:**

- [Building a Secure Access Control Matrix: Best Practices for Active Directory](https://www.linkedin.com/pulse/building-secure-access-control-matrix-best-practices-active-zaikin-7gr4e)
>
## Contents

* **Docs:**
    * [`AD Attributes`](https://github.com/maxzaikin/Practical-RBAC/blob/main/AD%20Attributes/AD%20Attributes.md): List of AD Attributes and it GUIDs  
* **Scripts:**
    * [`Create-ExchangeRoleGroup-and-Delegeate-Permmissions-To-ADRole.ps1`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Create-ExchangeRoleGroup-and-Delegeate-Permmissions-To-ADRole/Create-ExchangeRoleGroup-and-Delegeate-Permmissions-To-ADRole.ps1):
    * [`Delegate-UA-Create`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Delegate-UA-Create/Delegate-UA-Create.ps1):
    * [`Delegate-UA-Delete`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Delegate-UA-Delete/Delegate-UA-Delete.ps1):
    * [`Delegate-UA-Edit-DisplayName.ps1`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Delegate-UA-Edit-DisplayName/Delegate-UA-Edit-DisplayName.ps1):
    * [`Delegate-UA-Edit-EmployeeType.ps1`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Delegate-UA-Edit-EmployeeType/Delegate-UA-Edit-EmployeeType.ps1):
    * [`Delegate-UA-Edit-ExtendedAttr7.ps1`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Delegate-UA-Edit-ExtendedAttrib/Delegate-UA-Edit-ExtendedAttr7.ps1):
    * [`Delegate-UA-Edit-HomeDirectory.ps1`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Delegate-UA-Edit-HomeDirectory/Delegate-UA-Edit-HomeDirectory.ps1):
    * [`Delegate-UA-Edit-Personal-Information.ps1`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Delegate-UA-Edit-Personal-Information/Delegate-UA-Edit-Personal-Information.ps1):
    * [`Delegate-UA-Edit-Public-Information.ps1`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Delegate-UA-Edit-Public-Information/Delegate-UA-Edit-Public-Information.ps1):
    * [`Delegate-UA-Enable-Disable.ps1`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Delegate-UA-Enable-Disable/Delegate-UA-Enable-Disable.ps1):
    * [`Delegate-UA-Group-Membership-Management.ps1`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Delegate-UA-Group-Membership-Management/Delegate-UA-Group-Membership-Management.ps1):
    * [`Delegate-UA-Lock-Unlock.ps1`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Delegate-UA-Lock-Unlock/Delegate-UA-Lock-Unlock.ps1):
    * [`Delegate-UA-Reset-Password.ps1`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Delegate-UA-Reset-Password/Delegate-UA-Reset-Password.ps1):
    * [`Delegate-UA-Restrictions.ps1`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Delegate-UA-Restrictions/Delegate-UA-Restrictions.ps1):
    * [`Provisioning-New-Role.ps1`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Provisioning-New-Role/Provisioning-New-Role.ps1):
    * [`Configure-Network-Folder-Access-Groups.ps1`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Shared-Folders-Access-Management/Configure-Network-Folder-Access-Groups.ps1):
    * [`Create-Network-Folder-Access-Management-Group.ps1`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Shared-Folders-Access-Management/Create-Network-Folder-Access-Management-Group.ps1):
    * [`Delegate-Group-Membership-Management.ps1`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Shared-Folders-Access-Management/Delegate-Group-Membership-Management.ps1):
    * [`Scan-FolderPermissions.ps1`](https://github.com/maxzaikin/Practical-RBAC/blob/main/Shared-Folders-Access-Management/Scan-FolderPermissions.ps1):
* **Examples:**
    * *[Add examples of how to use the scripts in different scenarios]*
* **Documentation:**
    * *[Add documentation explaining RBAC concepts, best practices, and how to use the scripts effectively]*

## Getting Started

1. Clone this repository.
2. Review the scripts and documentation.
3. Modify the scripts to fit your specific environment and requirements.
4. Test the scripts in a non-production environment before deploying to production.

## Contributing

Contributions are welcome! If you have any scripts, examples, or documentation that would be helpful to others, please submit a pull request.

## Disclaimer

All scripts are provided as-is with no implicit warranty or support. It's always considered a best practice to test scripts in a development/test environment before running them in production.

## License

This repository is licensed under the [MIT License](LICENSE).
