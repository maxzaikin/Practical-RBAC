# Attributes of an Active Directory (AD) user object has a unique GUIDs.

Below is a list of some key user object attributes along with their corresponding GUIDs:

## Core User Attributes

    userAccountControl — Controls user account status (enabled/disabled).
        GUID: bf967a68-0de6-11d0-a285-00aa003049e2

    sAMAccountName — The login name of the user in the domain.
        GUID: 3e0abfd0-126a-11d0-a060-00aa006c33ed

    mail (Email Address) — The user's email address.
        GUID: 3e0abb9c-126a-11d0-a060-00aa006c33ed

    displayName — The display name of the user.
        GUID: bf967953-0de6-11d0-a285-00aa003049e2

    homeDirectory — The home directory of the user.
        GUID: bf9679e0-0de6-11d0-a285-00aa003049e2

    telephoneNumber — The phone number of the user.
        GUID: bf9679e1-0de6-11d0-a285-00aa003049e2

    employeeID — The employee ID.
        GUID: bf9679e3-0de6-11d0-a285-00aa003049e2

    department — The department the user belongs to.
        GUID: bf9679e4-0de6-11d0-a285-00aa003049e2

    description — A description of the user account.
        GUID: bf9679e6-0de6-11d0-a285-00aa003049e2

    memberOf — Groups to which the user belongs.
        GUID: bf9679e5-0de6-11d0-a285-00aa003049e2

## Additional User Attributes

    userPrincipalName (UPN) — The user’s login name in the format login@domain.
        GUID: bf967a14-0de6-11d0-a285-00aa003049e2

    manager — Identifies the user's manager.
        GUID: bf9679f0-0de6-11d0-a285-00aa003049e2

    employeeType — The type of employee (e.g., full-time, contractor).
        GUID: bf9679f4-0de6-11d0-a285-00aa003049e2

    title — The user's job title.
        GUID: bf9679f5-0de6-11d0-a285-00aa003049e2

    streetAddress — The user's street address.
        GUID: bf9679f7-0de6-11d0-a285-00aa003049e2

    postalCode — The postal code of the user.
        GUID: bf9679f8-0de6-11d0-a285-00aa003049e2

## Extended Attributes (Custom Attributes)

    Extended attributes, such as extensionAttribute1, extensionAttribute2, etc., are often added by administrators to Active Directory for custom use.
    
    extensionAttribute1.
        GUID: bf9679d0-0de6-11d0-a285-00aa003049e2

    extensionAttribute2.
        GUID: bf9679d1-0de6-11d0-a285-00aa003049e2

## Attribute Sets (User Property Sets)

    In Active Directory, attribute sets are groups of attributes that can be managed collectively. These sets can also have GUIDs, allowing the delegation of access to multiple attributes together.

    1. Basic User Information Set:

        GUID: 3e0abb0c-126a-11d0-a060-00aa006c33ed
        Attributes:
            displayName
            telephoneNumber
            mail
            sAMAccountName

    2. Extended User Information Set:

        GUID: bf967aba-0de6-11d0-a285-00aa003049e2
        Attributes:
            department
            manager
            employeeType

    3. General Information (Basic Information)

        GUID: 77b5b886-944a-11d1-aebd-0000f80367c1
        This property set typically contains basic user information.
        Attributes:
            displayName
            description
            telephoneNumber
            mail
            title
            physicalDeliveryOfficeName

    4. Public Information

        GUID: e48d0154-bcf8-11d1-8702-00c04fb96050
        Contains attributes related to general user identity information visible to others.
            Attributes:
                cn (Common Name)
                givenName
                sn (Surname)
                streetAddress
                postalCode
                telephoneNumber

    5. Personal Information

        GUID: e48d0156-bcf8-11d1-8702-00c04fb96050
        Personal details about a user, such as home contact information.
            Attributes:
                homePhone
                mobile
                pager
                postalAddress
                employeeNumber
                employeeID

    6. Web Information

        GUID: e48d0157-bcf8-11d1-8702-00c04fb96050
        Includes web-related information for users.
            Attributes:
                wWWHomePage
                URL
                personalTitle
                thumbnailPhoto

    7. Group Membership (Member of)

        GUID: bc0ac240-79a9-11d0-9020-00c04fc2d3cf
        This set focuses on group membership management.
            Attributes:
                member
                memberOf
                primaryGroupID

    8. Logon Information

        GUID: e48d0151-bcf8-11d1-8702-00c04fb96050
        Manages attributes that are related to user logon and authentication.
            Attributes:
                userPrincipalName (UPN)
                sAMAccountName
                userAccountControl
                lockoutTime
                lastLogonTimestamp
                logonHours
                logonCount

    9.  Account Restrictions

        GUID: 4c164200-20c0-11d0-a768-00aa006e0529
        Controls user account restriction properties.
            Attributes:
                accountExpires
                logonHours
                lockoutDuration
                badPwdCount
                badPasswordTime

    10. Public Key Information

        GUID: e48d0152-bcf8-11d1-8702-00c04fb96050
        Used for managing attributes related to user public keys.
            Attributes:
                userCertificate
                userSMIMECertificate
                msPKI-CertificateName

    11. Remote Access Information

        GUID: 037088f8-0ae1-11d2-b422-00a0c968f939
        Contains attributes related to remote access services.
            Attributes:
                msNPAllowDialin
                msNPCallingStationID
                msNPTimeOfDay
                msRADIUSCallbackNumber

    12. Personal Identification Information

        GUID: e48d0155-bcf8-11d1-8702-00c04fb96050
        Personal information such as employee identification attributes.
            Attributes:
                employeeID
                employeeNumber
                personalTitle

    13. Telephone Information

        GUID: e48d0153-bcf8-11d1-8702-00c04fb96050
        Contains telephone-related attributes.
            Attributes:
                telephoneNumber
                homePhone
                mobile
                pager
                facsimileTelephoneNumber

    14. Domain Password (Reset Password)

        GUID: ab721a54-1e2f-11d0-9819-00aa0040529b
        This property set is associated with resetting domain passwords.
            Attributes:
                unicodePwd
                ntPwdHistory
                lmPwdHistory
                pwdLastSet
                lockoutTime

    15. Exchange Information

        GUID: Varies per attribute.
        Used for attributes related to Microsoft Exchange mailboxes, including email aliases, quotas, and other mail-related information.
            Attributes:
                mailNickname
                proxyAddresses
                msExchRecipientTypeDetails
                msExchMailboxGuid

    16. Extended Rights (Control Access Rights)

        GUID: e48d0158-bcf8-11d1-8702-00c04fb96050
        Rights to perform certain actions in AD (e.g., resetting passwords, modifying group membership, managing service principal names).
            Attributes:
                userAccountControl
                msDS-UserAccountDisabled
                pwdLastSet
                lockoutTime

    17. Information Object Access

        GUID: 00000000-0000-0000-0000-000000000000
        This set is used for controlling access to information about the object, including reading and writing non-sensitive information.