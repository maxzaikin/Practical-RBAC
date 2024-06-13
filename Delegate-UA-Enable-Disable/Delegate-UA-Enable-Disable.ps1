Function Delegate-UA-Enable-Disable 
{
    <#
        .SYNOPSIS
            Delegates "Enable/Disable User Account" permissions to an Active Directory group.

        .PARAMETER role_name
            Name of the group to which permissions are delegated.

        .PARAMETER ou
            Distinguished name of the Organizational Unit (OU) where permissions are delegated.

        .PARAMETER WhatIf    
            Simulates changes without actually modifying Active Directory.

        .EXAMPLE
            Delegate-UA-Enable-Disable -role_name 'Helpdesk_Tier1' -ou 'OU=Standard Users,DC=contoso,DC=com' 

        .LINK
            https://github.com/maxzaikin/Practical-RBAC
                    
        .NOTES
            This function delegates "Enable/Disable User Account" permissions to a specified Active Directory group for a specific OU.
            It allows the group members to enable or disable user accounts within the designated OU.
            NOTE: this permission should be applied on the container where you store your groups not your privileged roles

            ---------------------
               Version: 1.0
               Author:  M. Zaikin
               Date:    2024-02-16
               
        [-------------------------------------DISCLAIMER-------------------------------------]
        This script is provided "AS IS" without warranty of any kind, express or implied, including but not limited to the warranties of 
        merchantability, fitness for a particular purpose and noninfringement. In no event shall the author or copyright holder be liable 
        for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection 
        with the script or the use or other dealings in the script. 

        It is essential to thoroughly test this script in a non-production environment before deploying it to a production environment. 
        The author is not responsible for any damages or data loss that may occur as a result of using this script. 
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
        # Initialize an array to store log messages. Not currently used, but can be implemented for logging purposes.
        [System.Collections.ArrayList]$LogList = @()

        # Get the current computer name.
        $computerName = [System.Net.Dns]::GetHostName()

        # Get the current username.
        $current_user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

        # Get the current date and time.
        $current_date = Get-Date -UFormat "%A %m/%d/%Y %R %Z"

        # Initialize a stopwatch to measure the script's execution time.
        $StopWatch = New-Object System.Diagnostics.Stopwatch
        $StopWatch.Start() 

        # Create a note to be added to the role's description field.
        $new_note = "Enable/Disable User Account permissions have been delegated to RBAC role $($role_name) on OU=$($ou). Operator: $($current_user), computer: $($computerName). Date:$($current_date)"        
          
        # Define the GUID for the "userAccountControl" attribute in Active Directory.
        $UserAccountControlProperty = [GUID]"bf967a68-0de6-11d0-a285-00aa003049e2"
          
        # Define the GUID for the user object class in Active Directory.
        $AD_CLASS_USER_OBJECT = [GUID]"bf967aba-0de6-11d0-a285-00aa003049e2"
         
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

        # Define the inheritance flag: No inheritance.
        $InheritanceFlags = [DirectoryServices.ActiveDirectorySecurityInheritance]::SelfAndChildren           
    }    
    PROCESS {
        try
        {  
            # Check if the WhatIf parameter is specified.
            if ($WhatIf) {
                Write-Verbose "Simulating changes..."
                Write-Verbose "$($ou_acl).AddAccessRule((New-Object System.DirectoryServices.ActiveDirectoryAccessRule $($ACE_TRUSTEE),
                                                                                                                       $($WritePropertyPermission),
                                                                                                                       $($AccessControlAllow),
                                                                                                                       $($UserAccountControlProperty),
                                                                                                                       $($InheritanceFlags),
                                                                                                                       $($AD_CLASS_USER_OBJECT)))"
            }
            else {
                # Create a new access rule granting the role permission to enable/disable user accounts.
                $ou_acl.AddAccessRule((New-Object System.DirectoryServices.ActiveDirectoryAccessRule $ACE_TRUSTEE,
                                                                                                     $WritePropertyPermission,
                                                                                                     $AccessControlAllow,
                                                                                                     $UserAccountControlProperty,
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
        # Catch any exceptions during the process.
        catch
        {
            # Get the exception message.
            $message = $_.Exception.Message

            # Write the error message to the console.
            Write-Output "ERROR: $message"       
        }            
    }
    END {
        Write-Output "--------------------------------------"        
        Write-Output "TOTAL TIME: $($StopWatch.Elapsed.ToString())"
        
        $StopWatch.Stop()  
    }   
}
