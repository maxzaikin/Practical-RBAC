Function Create-Network-Folder-Access-Management-Group {
    <#
        .SYNOPSIS
            Creates an Active Directory group for managing access to a network folder and delegates permission to manage group membership without granting access to the folder contents.
        
        .PARAMETER GroupName
            The name of the new AD group to be created.
        
        .PARAMETER NetworkFolderPath
            The path to the network folder where permissions should be applied.
        
        .PARAMETER NetworkFolderName
            The descriptive name of the network folder.

        .PARAMETER ou
            The Organizational Unit (OU) where the group should be created.
        
        .EXAMPLE
            Create-Network-Folder-Group -GroupName "FolderAdmins" -NetworkFolderPath "J:\SharedFolder" -NetworkFolderName "SharedFolder" -ou "OU=Groups,DC=contoso,DC=com"
        
        .NOTES
            This script checks if a group already exists, and if not, creates a new group in Active Directory and delegates permissions for managing folder access groups without granting access to the folder contents.
        
            ---------------------
               Version: 1.0
               Author:  M. Zaikin
               Date:    2024-08-29
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true, Position = 0)]
        [string]$GroupName,  # The name of the AD group to be created

        [parameter(Mandatory = $true, Position = 1)]
        [string]$NetworkFolderPath,   # Path to the network folder

        [parameter(Mandatory = $true, Position = 2)]
        [string]$NetworkFolderName,   # Descriptive name of the network folder

        [parameter(Mandatory = $true, Position = 3)]
        [string]$ou                 # The OU where the group should be created
    )

    BEGIN {
        # Initialize timer to track execution time
        $StopWatch = New-Object System.Diagnostics.Stopwatch
        $StopWatch.Start()

        # Log the action
        $current_user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
        $current_date = Get-Date -UFormat "%A %m/%d/%Y %R %Z"
        $log_note = "Creating group $GroupName for folder $NetworkFolderName. Operator: $current_user. Date: $current_date"

        # Check if the group already exists
        $existingGroup = Get-ADGroup -Filter { Name -eq $GroupName } -ErrorAction SilentlyContinue
    }

    PROCESS {
        if ($existingGroup) {
            # If the group exists, exit with a warning message
            Write-Host "Group '$GroupName' already exists. Exiting script." -ForegroundColor Yellow
            return
        }

        try {
            # Create the new group in AD
            New-ADGroup -Name $GroupName -GroupScope Global -Description "Group for managing access to $NetworkFolderName" -Path $ou
            Write-Host "Group '$GroupName' created successfully." -ForegroundColor Green

            # Log the creation action
            $log_note += " | Group created."

            # Define permission for group membership management
            $ACE_TRUSTEE = New-Object System.Security.Principal.SecurityIdentifier (Get-ADGroup $GroupName).SID
            $WritePropertyPermission = [System.DirectoryServices.ActiveDirectoryRights]::WriteProperty
            $AccessControlAllow = [System.Security.AccessControl.AccessControlType]::Allow
            $InheritanceFlags = [DirectoryServices.ActiveDirectorySecurityInheritance]::None
            $MemberAttribute = [GUID]"bf9679c0-0de6-11d0-a285-00aa003049e2"

            # Apply the delegation rule to manage group memberships
            $acl = Get-ACL -Path ("AD:" + $ou)
            $acl.AddAccessRule((New-Object System.DirectoryServices.ActiveDirectoryAccessRule $ACE_TRUSTEE,
                                                                                  $WritePropertyPermission,
                                                                                  $AccessControlAllow,
                                                                                  $MemberAttribute,
                                                                                  $InheritanceFlags,
                                                                                  $null))

            # Apply the new ACL back to the OU
            Set-ACL -Path ("AD:" + $ou) -AclObject $acl

            # Log that permissions were delegated
            $log_note += " | Permissions delegated to manage group memberships for folder access."

        } catch {
            Write-Host "Error creating group or delegating permissions: $_" -ForegroundColor Red
        }
    }

    END {
        # Stop the timer and output the elapsed time
        Write-Host "--------------------------------------"
        Write-Host "TOTAL TIME: $($StopWatch.Elapsed.ToString())"
        $StopWatch.Stop()
    }
}