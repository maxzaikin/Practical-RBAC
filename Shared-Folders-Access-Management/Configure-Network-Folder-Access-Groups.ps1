Function Configure-Network-Folder-Access-Groups {
    <#
        .SYNOPSIS
            Creates three AD security groups for a specified folder with read-only, read-write, and full control permissions.

        .PARAMETER FolderName
            The name of the folder for which the groups are being created.
        
        .PARAMETER FolderPath
            The full path to the folder on the file system.
        
        .PARAMETER Domain
            The domain where the groups will be created. Default is the current domain.
        
        .PARAMETER OU
            The Organizational Unit (OU) where the groups will be created. Default is the Groups OU in the domain.
        
        .PARAMETER WhatIf
            Simulates the creation of groups without actually creating them.

        .EXAMPLE
            New-FolderAccessGroups -FolderName "HR_Files" -FolderPath "D:\Shares\HR_Files" -OU "OU=Groups,DC=contoso,DC=com"

        .NOTES
            This script will create three groups: ReadOnly, ReadWrite, FullControl with permissions for a specific folder.
            
            Version: 1.0
            Author:  M. Zaikin
            Date:    2024-08-29
    #>

    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        # Name of the folder for which groups are being created
        [parameter(Mandatory = $true, Position = 0)]
        [string]$FolderName,        

        # Full path to the folder on the file system
        [parameter(Mandatory = $true, Position = 1)]
        [string]$FolderPath,        

        # The domain name (default to the current domain)
        [parameter(Mandatory = $false)]
        [string]$Domain = $env:USERDNSDOMAIN,  

        # The Organizational Unit where the groups will be created
        [parameter(Mandatory = $false)]
        [string]$OU = "OU=Groups,$Domain",     

        # Simulate changes
        [parameter(Mandatory = $false)]
        [switch]$WhatIf             
    )

    BEGIN {
        # Create a stopwatch to measure script execution time.
        $StopWatch = New-Object System.Diagnostics.Stopwatch
        $StopWatch.Start()

        # Group suffixes for different permission levels.
        $ReadOnlySuffix = "_ReadOnly"
        $ReadWriteSuffix = "_ReadWrite"
        $FullControlSuffix = "_FullControl"

        # Prepare group names.
        $ReadOnlyGroup = "$($FolderName)$ReadOnlySuffix"
        $ReadWriteGroup = "$($FolderName)$ReadWriteSuffix"
        $FullControlGroup = "$($FolderName)$FullControlSuffix"

        # Prepare file system rights for different groups.
        $FileSystemRightsReadOnly = "ReadAndExecute"
        $FileSystemRightsReadWrite = "Modify"
        $FileSystemRightsFullControl = "FullControl"

        # Log information.
        Write-Verbose "Domain: $Domain"
        Write-Verbose "OU: $OU"
        Write-Verbose "Creating AD Groups for folder: $FolderPath"
    }

    PROCESS {
        # Check if the script should proceed.
        if ($PSCmdlet.ShouldProcess("Creating access groups for folder: $FolderName")) {

            # Create Read-Only group.
            New-ADGroup -Name $ReadOnlyGroup -SamAccountName $ReadOnlyGroup -GroupCategory Security -GroupScope Global -DisplayName "$FolderName Read-Only" -Path $OU -Description "Read-only access to $FolderName" -WhatIf:$WhatIf
            Write-Verbose "Created group: $ReadOnlyGroup"

            # Create Read-Write group.
            New-ADGroup -Name $ReadWriteGroup -SamAccountName $ReadWriteGroup -GroupCategory Security -GroupScope Global -DisplayName "$FolderName Read-Write" -Path $OU -Description "Read-write access to $FolderName" -WhatIf:$WhatIf
            Write-Verbose "Created group: $ReadWriteGroup"

            # Create Full-Control group.
            New-ADGroup -Name $FullControlGroup -SamAccountName $FullControlGroup -GroupCategory Security -GroupScope Global -DisplayName "$FolderName Full-Control" -Path $OU -Description "Full control access to $FolderName" -WhatIf:$WhatIf
            Write-Verbose "Created group: $FullControlGroup"

            # Set NTFS permissions on the folder if it exists.
            if (Test-Path $FolderPath) {
                # Set Read-Only permissions.
                $acl = Get-Acl -Path $FolderPath
                $acl.SetAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("$Domain\$ReadOnlyGroup", $FileSystemRightsReadOnly, "ContainerInherit,ObjectInherit", "None", "Allow")))
                Set-Acl -Path $FolderPath -AclObject $acl -WhatIf:$WhatIf
                Write-Verbose "Applied Read-Only permissions for $ReadOnlyGroup"

                # Set Read-Write permissions.
                $acl = Get-Acl -Path $FolderPath
                $acl.SetAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("$Domain\$ReadWriteGroup", $FileSystemRightsReadWrite, "ContainerInherit,ObjectInherit", "None", "Allow")))
                Set-Acl -Path $FolderPath -AclObject $acl -WhatIf:$WhatIf
                Write-Verbose "Applied Read-Write permissions for $ReadWriteGroup"

                # Set Full-Control permissions.
                $acl = Get-Acl -Path $FolderPath
                $acl.SetAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("$Domain\$FullControlGroup", $FileSystemRightsFullControl, "ContainerInherit,ObjectInherit", "None", "Allow")))
                Set-Acl -Path $FolderPath -AclObject $acl -WhatIf:$WhatIf
                Write-Verbose "Applied Full-Control permissions for $FullControlGroup"
            }
            else {
                Write-Output "ERROR: Folder path $FolderPath does not exist."
            }
        }
    }

    END {
        # Stop the stopwatch and log the total time taken for execution.
        Write-Output "--------------------------------------"
        Write-Output "TOTAL TIME: $($StopWatch.Elapsed.ToString())"
        $StopWatch.Stop()
    }
}
