Function Delegate-Group-Membership-Management
{
    <#
        .SYNOPSIS
            Delegates permissions to manage group membership for a specific group that controls folder access, 
            without granting access to the folder itself.
        
        .PARAMETER delegate_group
            The AD group or user that is being granted permissions to manage the group membership.
        
        .PARAMETER target_group
            The AD group that controls access to a specific network folder.
        
        .PARAMETER ou
            Distinguished name of the Organizational Unit (OU) where the groups are located.
        
        .PARAMETER WhatIf    
            Simulates changes without actually modifying Active Directory.
        
        .EXAMPLE
            Delegate-Group-Membership-Management -delegate_group 'Folder_Admins' -target_group 'network_folder_write' -ou 'OU=Groups,DC=contoso,DC=com'
        
        .NOTES
            This script will delegate rights to the specified group or user for managing group membership of access control groups 
            without granting actual folder access permissions.
        
            ---------------------
               Version: 1.0
               Author:  M. Zaikin
               Date:    2024-08-29

        #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true, Position = 0)]
        [string]$delegate_group,  # The group or user who will manage group memberships
        
        [parameter(Mandatory = $true, Position = 1)]
        [string]$target_group,   # The group controlling access to the folder
        
        [parameter(Mandatory = $true, Position = 2)]
        [string]$ou,             # The OU where the groups are located

        [parameter(Mandatory = $false)]
        [switch]$WhatIf
    )

    BEGIN {
        # Initialize a stopwatch to measure the script's execution time.
        $StopWatch = New-Object System.Diagnostics.Stopwatch
        $StopWatch.Start() 

        # Create a log entry
        $current_user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
        $current_date = Get-Date -UFormat "%A %m/%d/%Y %R %Z"
        $new_note = "Delegated group membership management for $($target_group) to $($delegate_group). Operator: $($current_user). Date:$($current_date)"        

        # Get the security identifier (SID) of the delegate group (the group managing the membership).
        $ACE_TRUSTEE = New-Object System.Security.Principal.SecurityIdentifier (Get-ADGroup $delegate_group).SID

        # Get the group object that controls access to the folder.
        $target_group_obj = Get-ADGroup -Identity $target_group

        # Get the access control list (ACL) of the group that controls folder access.
        $group_acl = Get-ACL -Path ("AD:" + $target_group_obj.DistinguishedName)

        # Define the permission for modifying group membership (WriteProperty on "member" attribute).
        $WritePropertyPermission = [System.DirectoryServices.ActiveDirectoryRights]::WriteProperty

        # Define the access control type: Allow.
        $AccessControlAllow = [System.Security.AccessControl.AccessControlType]::Allow

        # Define the inheritance flag: Apply permissions only to this object, no inheritance.
        $InheritanceFlags = [DirectoryServices.ActiveDirectorySecurityInheritance]::None

        # Define the GUID for the "member" attribute in Active Directory.
        $MemberAttribute = [GUID]"bf9679c0-0de6-11d0-a285-00aa003049e2"
    }

    PROCESS {
        try {
            # Check if the WhatIf parameter is specified to simulate changes.
            if ($WhatIf) {
                Write-Verbose "Simulating changes..."
                Write-Verbose "$($group_acl).AddAccessRule((New-Object System.DirectoryServices.ActiveDirectoryAccessRule $($ACE_TRUSTEE),
                                                                                                       $($WritePropertyPermission),
                                                                                                       $($AccessControlAllow),
                                                                                                       $($MemberAttribute),
                                                                                                       $($InheritanceFlags),
                                                                                                       $null))"
            }
            else {
                # Create a new access rule to allow the delegate group to modify the "member" attribute of the target group.
                $group_acl.AddAccessRule((New-Object System.DirectoryServices.ActiveDirectoryAccessRule $ACE_TRUSTEE,
                                                                                                     $WritePropertyPermission,
                                                                                                     $AccessControlAllow,
                                                                                                     $MemberAttribute,
                                                                                                     $InheritanceFlags,
                                                                                                     $null))

                # Apply the modified ACL to the group.
                Set-ACL -Path ("AD:" + $target_group_obj.DistinguishedName) -AclObject $group_acl

                # Update the group’s description with the new note for tracking purposes.
                $Notes = (Get-ADGroup $target_group -Properties info).info
                $Notes += "  |  $new_note"
                Set-ADGroup -Identity $target_group -Replace @{info = $Notes}
            }
        }
        catch {
            # Catch any exceptions and write the error message to the console.
            Write-Output "ERROR: $($_.Exception.Message)"
        }
    }

    END {
        # Stop the stopwatch and output the total execution time.
        Write-Output "--------------------------------------"
        Write-Output "TOTAL TIME: $($StopWatch.Elapsed.ToString())"
        $StopWatch.Stop()
    }
}
