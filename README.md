# Vmware Horizon 8 AdamDB Machine Cleaner

This PowerShell script is designed to search for and optionally delete entries within an Active Directory Lightweight Directory Services (AD LDS) environment. It uses plain text credentials to establish a connection and allows users to search for specific values across all properties of directory entries.

## Features
- **User Input for Search Value**: The script prompts the user to enter a value to search for within the AD LDS entries.
- **Plain Text Credentials**: The connection to the AD LDS is established using plain text credentials.
- **LDAP Connection**: Configures the LDAP path to connect to the AD LDS server.
- **Directory Entry Search**: Uses `System.DirectoryServices.DirectorySearcher` to search the directory entries with a specified filter.
- **Attribute Matching**: Checks if any attribute of the directory entry contains the exact search value.
- **User Confirmation for Deletion**: Displays the matching entries and prompts the user to confirm if they want to delete the entry.
- **Delete Functionality**: Provides functionality to delete the directory entry if confirmed by the user.

## Usage
1. **Run the Script**: Execute the script in a PowerShell environment.
2. **Enter Search Value**: When prompted, enter the value you wish to search for within the directory entries.
3. **Review Search Results**: The script will display the entries containing the search value.
4. **Confirm Deletion**: You will be prompted to confirm whether you want to delete each entry. Options include `yes`, `no`, or `exit`.

## Code Overview

### Variables
- `$valueToSearch`: Stores the value entered by the user.
- `$username`, `$password`: Stores the AD LDS connection credentials.
- `$adamServer`, `$adamPort`, `$adamPath`, `$ldapPath`: Define the LDAP connection details.

### Functions
- `GetMatchingAttribute`: Checks if any property of an entry matches the search value.
- `DeleteEntry`: Deletes the specified directory entry.

### Main Process
- Establishes connection to the AD LDS.
- Searches for entries matching the filter criteria.
- Iterates through the results, checks for matching attributes, displays the details, and prompts the user for deletion.

### Example Execution
```shell
Enter the value to search for: exampleValue
Do you want to delete this entry? (yes/no/exit): yes
Deleted entry: LDAP://YourVCS.FQDN:389/CN=ExampleEntry,OU=Servers,DC=vdi,DC=vmware,DC=int
