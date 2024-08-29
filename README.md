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
    * Each scrip support with the example section.
  
* **Documentation:**
    * Role-Based Access Control (RBAC) is a security model that restricts system access based on the roles taht users holds within an organization. Instead of giving users individual permissions, RBAC assigns permissions to roles, and users are assigned one or more roles. This structure makes managing access to resources more efficient and scalable.
    To understand RBAC and its principles in more deep, please refer to the official guidelines provided by NIST. [Their publications detail the essential elements of RBAC](https://csrc.nist.gov/projects/role-based-access-control), including user-role and permission-role assignments, role hierarchies, and the concept of Separation of Duties (SoD).

    * **Key RBAC Concepts**

      1. Role: A collection of permissions that define what actions users assigned to that role can perform.
      2. User: A person or system that is assigned one or more roles, inheriting the permissions associated with those roles.
      3. Permission: The ability to perform specific actions on resources (e.g., read, write, delete). Permissions are granted to roles, not directly to users.
      4. Resources: The systems, data, or applications that users need access to (e.g., network shares, databases, application features).
      5. Role Hierarchies: In complex organizations, roles may be organized hierarchically. Higher roles inherit the permissions of the roles below them.

    **Benefits of RBAC**

      1. Scalability: By grouping permissions into roles, it's easier to manage large numbers of users.
      2. Least Privilege: Users are given only the access they need to perform their job, reducing security risks.
      3. Auditing: It's easier to review and manage who has access to what resources since permissions are tied to roles, not individuals.
      4. Compliance: RBAC can help meet regulatory requirements by enforcing separation of duties and least privilege policies.

    **RBAC Best Practices**

      1.  Design Accecc Controll Matrix: The access controll matrix will help you to persue many positive initiatives such that documenting your Organization access role model, periodically audit permissions, and documenting permission granularity.
      2.  Define Roles Based on Business Functions: Roles should be based on actual business needs and job functions. 
      3.  Least Privilege: Assign users the minimum permissions they need to perform their job. Avoid creating overly broad or generalized roles like "admin".
      4.  Review and Audit Regularly: Regularly audit role assignments to ensure users no longer have access to resources they don't need. This is critical after employee role changes or departures.
      5.  Segregation of Duties (SoD): Ensure roles are segregated to prevent conflicts of interest. 
      6.  Automate Role Assignments: Use scripts and tools to automate the assignment and revocation of roles as users join, leave, or change positions within the organization.
      7.  Limit Role Overlap: One User account should ideally be assigned a single role that encompasses it needs. Assigning multiple roles to a one user account can lead to conflicts and excessive permissions.

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
