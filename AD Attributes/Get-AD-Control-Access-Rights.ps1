Function Get-AD-Control-Access-Rights {
    <#
        .SYNOPSIS
            Retrieves all control access rights and allows filtering by partial GUID or right name.

        .PARAMETER Filter
            A partial GUID or part of the control access right name to filter the results.

        .EXAMPLE
            Get-ControlAccessRights -Filter "5f202"
            Retrieves control access rights that have a GUID containing "5f202".

        .EXAMPLE
            Get-ControlAccessRights -Filter "reset"
            Retrieves control access rights whose names contain "reset".

        .NOTES
            This script retrieves control access rights and their GUIDs from AD, with filtering options.
            Version: 1.0
            Author: Your Name
            Date: 2024-XX-XX
    #>

    [CmdletBinding()]
    param (
        [string]$Filter
    )

    BEGIN {
        Write-Verbose "Starting to retrieve control access rights with filter: $Filter"
    }

    PROCESS {
        try {
            # If filter is provided, adjust the LDAP query
            if ($Filter) {
                $ldapFilter = "(&(objectClass=controlAccessRight)(|(name=*$Filter*)(rightsGuid=*$(($Filter -replace '-', '') )*)))"
            } else {
                $ldapFilter = "(objectClass=controlAccessRight)"
            }

            # Retrieve control access rights from the schema
            Get-ADObject -LDAPFilter $ldapFilter `
                -SearchBase "CN=Extended-Rights,CN=Configuration,DC=contoso,DC=com" `
                -Property name, rightsGuid |
                Format-Table name, rightsGuid
        }
        catch {
            Write-Error "An error occurred: $_"
        }
    }

    END {
        Write-Verbose "Completed retrieval of control access rights."
    }
}
