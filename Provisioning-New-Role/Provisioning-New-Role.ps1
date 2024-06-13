Function Provisioning-New-Role
{
    <#
        .SYNOPSIS
            Create new RBAC role, disable inheritance and grants full control access to Enterprise and Domain admins, grants read-only access to Authorized users
                  
        .PARAMETER Role
            Group name

        .EXAMPLE
            Provisioning-New-Role -role_name 'Role-Name' -role_description 'Description' -role_path -WhatIf

        .LINK
        .NOTES
            Original script located here:
                I:\Organization\ISD\00_ОФ\03. База знаний\1. Инструментарий\Provisioning-New-Role.ps1

            20240216 M. Zaikin
            [+] Release

            Email: mvzaikin@sakhalin-1.com

        [-------------------------------------DISCLAIMER-------------------------------------]
        All scripts are provided as-is with no implicit warranty or support. It's always considered a best practice to test scripts in a DEV/TEST environment before running them in production. 
        In other words, I will not be held accountable if one of my scripts is responsible for an RGE (Resume Generating Event). 
        If you have questions or issues, please reach out/report them on my GitHub page. Thanks for your support!
        [-------------------------------------DISCLAIMER-------------------------------------]
    #>

    [cmdletbinding(SupportsShouldProcess = $true)]
    param (
        [parameter(Mandatory = $true, Position = 0)]
        [string]$role_name,

        [parameter(Mandatory = $true, Position = 1)]
        [string]$role_description,

        [parameter(Mandatory = $true, Position = 2)]
        [string]$role_ad_path,

        [parameter(Mandatory = $true, Position = 3)]
        [string]$output_path
    )

    BEGIN { 
        [System.Collections.ArrayList]$LogList = @()
        $computerName = [System.Net.Dns]::GetHostName()       
        $current_user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
        $current_date = Get-Date -UFormat "%A %m/%d/%Y %R %Z"
        $role_ad_scope = "DomainLocal"
        $role_ad_category = "Security"
          
        $output_file_name = "RBAC_$($role_name).csv"
        $output_path = Join-Path -Path $output_path -ChildPath $output_file_name

        $new_note = "RBAC Role $($role_name) provisioned by $($current_user) from computer: $($computerName) per. Date:$($current_date)"  

        $StopWatch = New-Object System.Diagnostics.Stopwatch
        $StopWatch.Start()        

        # Get a reference to the RootDSE of the current domain
        $rootdse = Get-ADRootDSE
        $searchbase_DN = $rootdse.DefaultNamingContext

        # Create a hashtable to store the GUID value of each schema class and attribute
        $guidmap = @{}
        Get-ADObject -SearchBase ($rootdse.SchemaNamingContext) -LDAPFilter "(schemaidguid=*)" -Properties lDAPDisplayName,schemaIDGUID | ForEach-Object {
            $guidmap[$_.lDAPDisplayName] = [System.GUID]$_.schemaIDGUID
        }
    }
    
    PROCESS {
        try
        {
            if ($PSCmdlet.ShouldProcess("Role: $role_name")) {
                # 1. Create new Role in AD 
                Write-Output "Provision new Role in AD: $($role_name)"
                if (-not $WhatIf) {
                    $new_role_obj = New-ADGroup -Name $role_name -GroupScope $role_ad_scope -GroupCategory $role_ad_category -Path $role_ad_path -Description $role_description -PassThru

                    $Notes = (Get-ADGroup $role_name -Properties info).info
                    $Notes += "$new_note"
                    Set-ADGroup -Identity $role_name -Replace @{info = $Notes}
                    
                    # 2. Disable inheritance 
                    Write-Output "Disabling security inheritance..."
                    $role_dn = (Get-ADGroup $role_name).DistinguishedName
                    $role_entry = [ADSI]"LDAP://$role_dn"
                    $role_acl = $role_entry.ObjectSecurity
                    $role_acl.SetAccessRuleProtection($true, $false)
                    
                    # 3. Grant full control access to Enterprise and Domain admins
                    $enterprise_admins = New-Object System.Security.Principal.SecurityIdentifier (Get-ADGroup "Enterprise Admins").SID
                    $domain_admins = New-Object System.Security.Principal.SecurityIdentifier (Get-ADGroup "Domain Admins").SID

                    Write-Output "+ Applying Full Access ACE for Enterprise Admins"
                    $ace1 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $enterprise_admins,"GenericAll","Allow","All",$guidmap["group"]
                    $role_acl.AddAccessRule($ace1)

                    Write-Output "+ Applying Full Access ACE for Domain Admins"
                    $ace2 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $domain_admins,"GenericAll","Allow","All",$guidmap["group"]
                    $role_acl.AddAccessRule($ace2)

                    # 4. Set the modified ACL back to the role 
                    $role_entry.CommitChanges()
                    $role_entry.ObjectSecurity = $role_acl
                }
                else {
                    Write-Output "WhatIf: Create new Role in AD: $($role_name)"
                    Write-Output "WhatIf: Disable security inheritance"
                    Write-Output "WhatIf: Apply Full Access ACE for Enterprise Admins"
                    Write-Output "WhatIf: Apply Full Access ACE for Domain Admins"
                }
            }
        }
        catch
        {
            $message = $_.Exception.Message
            Write-Output "ERROR: $message : TIME: $($StopWatch.Elapsed.ToString())"
        }            
    }

    END {
        Write-Output "--------------------------------------"        
        Write-Output "TOTAL TIME: $($StopWatch.Elapsed.ToString())"
        $StopWatch.Stop()

        $LogObject = [PSCustomObject]@{                              
            'ROLE NAME' = $role_name
            'ROLE DESCRIPTION' = $role_description
            'PROVISIONED BY' = $current_user  
            'PATH' = $role_ad_path                                               
            'FROM' = $computerName
            'DATE' = $current_date
            'REASON' = $work_order
        }

        $LogList.Add($LogObject) | Out-Null
        $LogList | Export-Csv -Path $output_path -Encoding UTF8 -Delimiter ";"
        Write-Output "Log saved to $output_path"
        Write-Output "Send log to ISD@s1.rosneft.ru"
    }   
}
