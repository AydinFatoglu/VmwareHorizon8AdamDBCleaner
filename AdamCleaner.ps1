cls

# Ask for the value to search
$valueToSearch = Read-Host "Enter the value to search for"


# Define the credentials (plain text)
$username = "DOMAIN\VDIADMINUSER"
$password = "Password"

# Define the connection string for the ADAM database
$adamServer = "YourVCS.FQDN" # Replace with the ADAM server address if different
$adamPort = 389 # Default port, change if needed
$adamPath = "OU=Servers,DC=vdi,DC=vmware,DC=int" # Adjust the path as necessary
$ldapPath = "LDAP://${adamServer}:${adamPort}/${adamPath}"

# Create the DirectoryEntry connection with plain text credentials
$adamConnection = New-Object System.DirectoryServices.DirectoryEntry($ldapPath, $username, $password)

# Define the search criteria
$searcher = New-Object System.DirectoryServices.DirectorySearcher($adamConnection)
$searcher.SearchRoot = $adamConnection
$searcher.SearchScope = [System.DirectoryServices.SearchScope]::Subtree
$searcher.Filter = "(objectClass=*)"

# Execute the search
$results = $searcher.FindAll()

# Function to check if any property contains the exact search value and return the attribute name and value
function GetMatchingAttribute {
    param ($entry, $valueToSearch)
    foreach ($property in $entry.Properties.PropertyNames) {
        foreach ($value in $entry.Properties[$property]) {
            if ($value -eq $valueToSearch) {
                return @{
                    Attribute = $property
                    Value = $value
                }
            }
        }
    }
    return $null
}

# Function to delete the entry
function DeleteEntry {
    param ($entry)
    try {
        $entry.DeleteTree()
        Write-Host "Deleted entry: $($entry.Path)"
    } catch {
        Write-Host "Failed to delete entry: $($entry.Path)"
    }
}

# Display the results and ask for deletion
$results | ForEach-Object {
    $result = $_.GetDirectoryEntry()
    $matchingAttribute = GetMatchingAttribute $result $valueToSearch
    if ($matchingAttribute) {
        $output = [PSCustomObject]@{
            Path = $result.Path
            Name = $result.Name
            Attribute = $matchingAttribute.Attribute
            Value = $matchingAttribute.Value
        }
        
        # Display the entry details
        $output | Format-Table -AutoSize
        
        # Prompt for deletion
        $confirm = Read-Host "Do you want to delete this entry? (yes/no/exit)"
        if ($confirm -eq "y") {
            DeleteEntry $result
            
        } elseif ($confirm -eq "exit") {
            Write-Host "Exiting script."
            break
        } elseif ($confirm -eq "no") {
            Write-Host "Skipping deletion for this entry."
        }
    }
}
