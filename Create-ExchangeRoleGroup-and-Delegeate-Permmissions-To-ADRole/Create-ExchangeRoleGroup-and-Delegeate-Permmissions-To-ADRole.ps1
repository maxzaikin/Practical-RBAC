Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn

Function Create-ExchangeRoleGroup-and-Delegeate-Permmissions-To-ADRole {
    <#
        .SYNOPSIS
            Creates an Exchange Role Group and adds a member to it, with logging actions to the member's description field.
                  
        .PARAMETER ExchangeRole
            Name of the new Exchange role group.
        
        .PARAMETER ExchangeRolesList
            List of Exchange roles to be assigned to the new role group.
            
        .PARAMETER Description
            Description for the new role group.
        
        .PARAMETER ADRole
            Distinguished name of the user or group to be added as a member to the exchange role group.
            
        .PARAMETER WhatIf    
            Simulates changes without actually modifying Active Directory.

        .EXAMPLE
            Create-ExchangeRoleGroup-and-Delegeate-Permmissions-To-ADRole -ExchangeRole "Exchange Users Mailbox Management" -ExchangeRolesList @("Mail Recipients", "Mail Recipient Creation", "Recipient Policies") -Description "Role to manage mailboxes and distribution groups" -ADRole "Priv.Exch.User-Mailbox-Management.GG"
            
        .NOTES
            This function creates an Exchange Role Group with specified roles and adds a specified member to the group.
            
            ---------------------
               Version: 1.0
               Author:  Maks V. Zaikin
               Date:    12-Jun-2024

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
        [string]$ExchangeRole,

        [parameter(Mandatory = $true, Position = 1)]
        [string[]]$ExchangeRolesList,

        [parameter(Mandatory = $true, Position = 2)]
        [string]$Description,

        [parameter(Mandatory = $true, Position = 3)]
        [string]$ADRole,

        [parameter(Mandatory = $false)]
        [switch]$WhatIf
    )# param

    BEGIN {   
        # Initialize an array to store log messages. 
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

        # Get the current notes from the member's description field.
        $Notes = (Get-ADGroup $ADRole -Properties info).info

        # Create a note to be added to the role's description field.
        $new_note = "Exchange role group $($ExchangeRole) created with permissions $($ExchangeRolesList). AD role: $($ADRole) has been included in membership. Operator: $($current_user), computer: $($computerName). Date:$($current_date)" 
    }    
    PROCESS {
        try
        {  
            # Check if the WhatIf parameter is specified.
            if ($WhatIf) {
                Write-Verbose "Simulating changes..."
                Write-Verbose "New-RoleGroup -Name '$ExchangeRole' -Roles '$($ExchangeRolesList -join ',')' -Description '$Description'"
                Write-Verbose "Add-RoleGroupMember -Identity $ExchangeRole' -Member '$ADRole'"
                
                # Display the new note that would be added to the description.
                Write-Verbose "Current description: $Notes"
                Write-Verbose "New note: $new_note"
            }
            else {
                # Create the new role group with specified roles
                New-RoleGroup -Name $ExchangeRole -Roles $ExchangeRolesList -Description $Description

                # Add the specified member to the new role group
                Add-RoleGroupMember -Identity $ExchangeRole -Member $ADRole
                
                # Append the new note to the existing notes.
                $Notes += "  |  $new_note"

                # Update the member's description field with the new notes.
                Set-ADGroup -Identity $ADRole -Replace @{info = $Notes} 
            }          
        }
        # Catch any exceptions during the process.
        catch
        {
            # Get the exception message.
            $message = $_.Exception.Message

            # Write the error message to the console along with the execution time.
            Write-Output "ERROR: $message : TIME: $($StopWatch.Elapsed.ToString())"       
        }            
    }
    END {
        Write-Output "--------------------------------------"        
        Write-Output "TOTAL TIME: $($StopWatch.Elapsed.ToString())"
        
        $StopWatch.Stop()
    }   
}
