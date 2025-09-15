function new-credential {
    <#
    .SYNOPSIS
        Generate a PS Credential object.  Can generate with either a securestring or string.
    
    .PARAMETER username
        String: username to be used in credential

    .PARAMETER password
        securestring/string: Password used in credenital

    .EXAMPLE
        PS C:> new-credential -username "foo" -password "bar"

    .EXAMPLE
        PS C:> new-credential -username "foo" -password $(convertTo-SecureString "bar" -AsPlainText)

    #>
    param (
        [Parameter(Mandatory=$true)]
        [srting]$username,
        [Parameter(Mandatory=$true)]
        [ValidateScript({$_ -is [string] -or $_ -is [SecureString]})]
        [object]$password
    )
    
    if ($password -is [string]) {
        $password = ConvertTo-SecureString $password -AsPlainText
    }

    try {
        write-host "Creating new PS Credential."
        [pscredential]$credential = New-Object System.Management.Automation.PSCredential($username, $password)
        write-host "Successfully created new PS Credential object."
        return $credential
    }
    catch {
        write-host "Error Code: $($_.Exeption.HResult)"
        write-host "Error Message: $($_.Exeption.Message)"
        write-host "Error Line: $($_.Exeption.Line)"  
        throw "Error Message: $($_.Exeption.Message)"
    }
}