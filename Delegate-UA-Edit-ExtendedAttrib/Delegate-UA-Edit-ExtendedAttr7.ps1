Function Delegate-UA-Edit-ExtendedAttribute7
{
    <#
        .SYNOPSIS
            Delegates "Edit ExtendedAttribute7" permissions to an Active Directory group.

        .PARAMETER role_name
            Name of the group to which permissions are delegated.

        .PARAMETER ou
            Distinguished name of the Organizational Unit (OU) where permissions are delegated.

        .PARAMETER WhatIf    
            Simulates changes without actually modifying Active Directory.

        .EXAMPLE
            Delegate-UA-Edit-ExtendedAttribute7 -role_name 'HR_Team' -ou 'OU=Standard Users,DC=contoso,DC=com' 

        .NOTES
            This function delegates "Edit ExtendedAttribute7" permissions to a specified Active Directory group for a specific OU.
            It allows the group members to modify the `ExtendedAttribute7` attribute within the designated OU.
            The permission is applied to the container where user objects are stored.

            ---------------------
               Version: 1.0
               Author:  M. Zaikin
               Date:    2024-08-29
               
        [-------------------------------------DISCLAIMER-------------------------------------]
        This script is provided "AS IS" without warranty of any kind, express or implied, including but not limited to the warranties of 
        merchantability, fitness for a particular purpose and noninfringement. In no event shall the author or copyright holder be liable 
        for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection 
        with the script or the use or other dealings in the script. 
        [-------------------------------------DISCLAIMER-------------------------------------]
    #>

    [cmdletbinding()]
    param (
        [parameter(Mandatory = $true, Position = 0)]
        [string]$role_name,

        [parameter(Mandatory = $true, Position = 1)]
        [string]$ou,
        
        [parameter(Mandatory=$false)]
        [switch]$WhatIf
    )

    BEGIN { 
        # Get the security identifier (SID) of the specified role (group).
        $ACE_TRUSTEE = New-Object System.Security.Principal.SecurityIdentifier (Get-ADGroup $role_name).SID

        # Get the OU object.
        $ou_obj = Get-ADOrganizationalUnit -Identity $ou

        # Get the access control list (ACL) of the OU.
        $ou_acl = Get-ACL -Path ("AD:" + $ou_obj.DistinguishedName)

        # Define the permission to be granted: Write Property.
        $WritePropertyPermission = [System.DirectoryServices.ActiveDirectoryRights]::WriteProperty

        # Define the access control type: Allow.
        $AccessControlAllow = [System.Security.AccessControl.AccessControlType]::Allow  

        # Define the inheritance flag: Apply to child objects.
        $InheritanceFlags = [DirectoryServices.ActiveDirectorySecurityInheritance]::SelfAndChildren           

        # GUID for the ExtendedAttribute7 (это пример, нужно заменить на правильный GUID если атрибут является кастомным).
        $ExtendedAttribute7Property = [GUID]"bf9679c0-0de6-11d0-a285-00aa003049e2" # Пример GUID, может быть другим
        
        # Define the GUID for the user object class in Active Directory.
        $AD_CLASS_USER_OBJECT = [GUID]"bf967aba-0de6-11d0-a285-00aa003049e2"

        # Get the current computer name.
        $computerName = [System.Net.Dns]::GetHostName()

        # Get the current username.
        $current_user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

        # Get the current date and time.
        $current_date = Get-Date -UFormat "%A %m/%d/%Y %R %Z"

        # Create a note to be added to the role's description field.
        $new_note = "Edit ExtendedAttribute7 permissions have been delegated to RBAC role $($role_name) on OU=$($ou). Operator: $($current_user), computer: $($computerName). Date:$($current_date)"        
    }

    PROCESS {
        try
        {  
            if ($WhatIf) {
                Write-Verbose "Simulating changes..."
                Write-Verbose "$($ou_acl).AddAccessRule((New-Object System.DirectoryServices.ActiveDirectoryAccessRule $($ACE_TRUSTEE),
                                                                                                                       $($WritePropertyPermission),
                                                                                                                       $($AccessControlAllow),
                                                                                                                       $($ExtendedAttribute7Property),
                                                                                                                       $($InheritanceFlags),
                                                                                                                       $($AD_CLASS_USER_OBJECT)))"
            }
            else {
                # Create a new access rule granting the role permission to edit ExtendedAttribute7.
                $ou_acl.AddAccessRule((New-Object System.DirectoryServices.ActiveDirectoryAccessRule $ACE_TRUSTEE,
                                                                                                     $WritePropertyPermission,
                                                                                                     $AccessControlAllow,
                                                                                                     $ExtendedAttribute7Property,
                                                                                                     $InheritanceFlags,
                                                                                                     $AD_CLASS_USER_OBJECT))           
                                                                                                                
                # Apply the modified ACL to the OU.
                Set-ACL -Path ("AD:" + $ou_obj.DistinguishedName) -AclObject $ou_acl

                # Get the current notes from the role's description field.
                $Notes = (Get-ADGroup $role_name -Properties info).info

                # Append the new note to the existing notes.
                $Notes += "  |  $new_note"

                # Update the role's description field with the new notes.
                Set-ADGroup -Identity $role_name -Replace @{info = $Notes} 
            }          
        }
        catch
        {
            # Get the exception message.
            $message = $_.Exception.Message

            # Write the error message to the console.
            Write-Output "ERROR: $message"       
        }            
    }

    END {
        Write-Output "Delegation completed successfully."        
    }   
}
