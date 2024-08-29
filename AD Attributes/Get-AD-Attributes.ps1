Function Get-ADAttributes {
    <#
        .SYNOPSIS
            Retrieves all attributes from the AD schema and allows filtering by partial GUID or attribute name.

        .PARAMETER Filter
            A partial GUID or part of an attribute's name to filter the results.

        .EXAMPLE
            Get-ADAttributes -Filter "bf967"
            Retrieves all attributes that have a GUID containing "bf967".

        .EXAMPLE
            Get-ADAttributes -Filter "home"
            Retrieves all attributes whose names contain "home".

        .NOTES
            This script retrieves AD schema attributes, along with their GUIDs, and provides filtering options for ease of use.
            Version: 1.0
            Author: M. Zaikin
            Date: 2024-08-30
    #>

    [CmdletBinding()]
    param (
        [string]$Filter
    )

    BEGIN {
        Write-Verbose "Initializing attribute retrieval with filter: $Filter"
    }

    PROCESS {
        try {
            # If filter is provided, adjust the LDAP query
            if ($Filter) {
                $ldapFilter = "(&(schemaIDGUID=*)(|(lDAPDisplayName=*$Filter*)(schemaIDGUID=*$(($Filter -replace '-', '') )*)))"
            } else {
                $ldapFilter = "(schemaIDGUID=*)"
            }

            # Retrieve attributes from the schema
            Get-ADObject -LDAPFilter $ldapFilter `
                -SearchBase "CN=Schema,CN=Configuration,DC=contoso,DC=com" `
                -SearchScope Subtree `
                -Property lDAPDisplayName, schemaIDGUID |
                Format-Table lDAPDisplayName, schemaIDGUID
        }
        catch {
            Write-Error "An error occurred: $_"
        }
    }

    END {
        Write-Verbose "Completed attribute retrieval."
    }
}