Function Scan-FolderPermissions {
    <#
        .SYNOPSIS
            Scans a directory and its subdirectories (optionally recursively) and collects permission information for each subdirectory.

        .PARAMETER FolderPath
            The path to the folder to scan.

        .PARAMETER OutputPath
            The file path where the CSV report will be saved.

        .PARAMETER Recurse
            Indicates if the scan should be recursive (include all subdirectories).

        .EXAMPLE
            Scan-FolderPermissions -FolderPath "D:\Shares" -OutputPath "D:\Reports\Permissions.csv" -Recurse

        .NOTES
            This script will scan a specified folder, collect permission data on subdirectories, and save results in CSV format.
            
            Version: 1.0
            Author: M. Zaikin
            Date: 2024-08-29
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$FolderPath,    # Full path to the folder to scan.

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$OutputPath,    # File path where the CSV report will be saved.

        [Parameter(Mandatory = $false, Position = 2)]
        [switch]$Recurse        # Enable recursive scanning.
    )

    BEGIN {
        # Import required .NET namespaces for permissions
        Add-Type -AssemblyName "System.IO.FileSystemAccessControl"
        Add-Type -AssemblyName "System.Security.Principal"

        # Progress and status tracking
        $folderCount = 0
        $processedCount = 0

        # List to store scan results
        $ScanResults = @()

        # Start stopwatch to measure execution time
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew()

        Write-Host "Starting scan of folder: $FolderPath" -ForegroundColor Green
    }

    PROCESS {
        # Function to check if the ACL is inherited
        function Test-InheritedPermissions {
            param ([System.Security.AccessControl.DirectorySecurity]$acl)
            return $acl.AreAccessRulesProtected
        }

        # Function to compare permissions between two directories
        function Compare-DirectoryPermissions {
            param (
                [System.Security.AccessControl.DirectorySecurity]$parentAcl,
                [System.Security.AccessControl.DirectorySecurity]$childAcl
            )
            return $parentAcl.GetAccessRules($true, $true, [System.Security.Principal.NTAccount]) -eq $childAcl.GetAccessRules($true, $true, [System.Security.Principal.NTAccount])
        }

        # Get list of subdirectories (recursively or not)
        $subdirectories = if ($Recurse) {
            Get-ChildItem -Path $FolderPath -Directory -Recurse
        } else {
            Get-ChildItem -Path $FolderPath -Directory
        }

        $folderCount = $subdirectories.Count + 1  # Including root directory

        # Include the root directory in the scan
        $subdirectories = $subdirectories + (Get-Item -Path $FolderPath)

        # Process each directory
        foreach ($subdir in $subdirectories) {
            $processedCount++

            # Get ACL for the current directory
            $acl = Get-Acl -Path $subdir.FullName

            # Check if permissions are inherited
            $isInherited = -not (Test-InheritedPermissions -acl $acl)

            # For subdirectories, compare with parent directory permissions
            $isSameAsParent = $false
            if ($subdir.FullName -ne $FolderPath) {
                # Get parent ACL
                $parentDir = Get-Item -Path $subdir.FullName | Get-Item -ErrorAction SilentlyContinue
                $parentAcl = Get-Acl -Path $parentDir.Parent.FullName
                # Compare ACL with parent
                $isSameAsParent = Compare-DirectoryPermissions -parentAcl $parentAcl -childAcl $acl
            }

            # If permissions are not the same as parent or it's the root directory, document it
            if (-not $isSameAsParent -or $subdir.FullName -eq $FolderPath) {
                # Get permission entries (Access Control Entries - ACEs)
                $aclEntries = $acl.GetAccessRules($true, $true, [System.Security.Principal.NTAccount])

                # Collect information for each ACE
                foreach ($entry in $aclEntries) {
                    $ScanResults += [pscustomobject]@{
                        Directory       = $subdir.FullName
                        Identity        = $entry.IdentityReference.Value
                        AccessControl   = $entry.FileSystemRights
                        Inherited       = $entry.IsInherited
                        InheritanceFlag = $entry.InheritanceFlags
                        PropagationFlag = $entry.PropagationFlags
                    }
                }
            }

            # Display progress
            $percentComplete = [math]::Round(($processedCount / $folderCount) * 100, 2)
            Write-Progress -Activity "Scanning folders..." -Status "Processing $processedCount of $folderCount" -PercentComplete $percentComplete
        }
    }

    END {
        # Save scan results to CSV
        if ($ScanResults.Count -gt 0) {
            $ScanResults | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
            Write-Host "Scan completed! Results saved to: $OutputPath" -ForegroundColor Green
        } else {
            Write-Host "No permissions to document. No output generated." -ForegroundColor Yellow
        }

        # Stop the stopwatch and log the total time taken
        $StopWatch.Stop()
        Write-Host "Total time taken: $($StopWatch.Elapsed.ToString())"
    }
}