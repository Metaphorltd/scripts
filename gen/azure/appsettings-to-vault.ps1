# First thing to install Azure Powershell Module using following command
# Install-module Az

# Now Connect to your Azure Account using following command
# Connect-AzAccount

#write powershell script to list only key values pair who has primitive types values in json file
$vaultname = "<vault name>"
$resourcegroup = "<resource group>"
$jsonFilePath = "<path to json>"
#$azureKeyVault = Get-AzKeyVault -VaultName $vaultname -ResourceGroupName $resourcegroup

# Read the JSON file content
$jsonContent = Get-Content -Path $jsonFilePath
# remove all commented lines that start with space and contains // in middle and ends with space
$jsonContent = $jsonContent -replace "\s//.*"
# Convert the JSON content to a PowerShell object
$jsonObject = $jsonContent | ConvertFrom-Json

# Function to recursively traverse the object and find primitive type values
function Find-PrimitiveTypeValues {
    param (
        [PSCustomObject]$Object,
        [string]$ParentKey = '',
        [System.Collections.Generic.List[Object]]$FindingsList
    )
    foreach ($property in $Object.PSObject.Properties) {
        $currentKey = if ($ParentKey -eq '') { $property.Name } else { "$ParentKey--$($property.Name)" }
        $value = $property.Value
        if ($value -is [PSCustomObject] -or $value -is [System.Collections.Hashtable]) {
            # Recursive call for nested objects
            Find-PrimitiveTypeValues -Object $value -ParentKey $currentKey -FindingsList $FindingsList
        } elseif ($value -is [System.Array]) {
            # Handle arrays, assuming they might contain primitive types or objects
            for ($i = 0; $i -lt $value.Count; $i++) {
                $element = $value[$i]
                if ($element -is [PSCustomObject] -or $element -is [System.Collections.Hashtable]) {
                    Find-PrimitiveTypeValues -Object $element -ParentKey "$currentKey[$i]" -FindingsList $FindingsList
                } else {
                    # Array element is a primitive type
                    Write-Output "Key: $currentKey[$i], Value: $element"
                    if($element -ne $null){
                        $FindingsList.Add([PSCustomObject]@{
                            Key = $currentKey[$i]
                            Value = $element
                        })
                    }
                }
            }
        } else {
            # Output the key-value pair if the value is a primitive type
            Write-Output "Key: $currentKey, Value: $value"
            if($value -ne $null){
                $FindingsList.Add([PSCustomObject]@{
                    Key = $currentKey
                    Value = $value
                })
            }
            
        }
    }
}

# Start the recursive traversal
# Initialize a list to store findings
$findings = New-Object System.Collections.Generic.List[Object]
Find-PrimitiveTypeValues -Object $jsonObject -FindingsList $findings
# upload to azure key vault
$azureKeyVault = Get-AzKeyVault -VaultName $vaultname -ResourceGroupName $resourcegroup
foreach($finding in $findings){
    $key = $finding.Key
    $value = $finding.Value
    $secret = ConvertTo-SecureString -String $value -AsPlainText -Force
    Set-AzKeyVaultSecret -VaultName $vaultname -Name $key -SecretValue $secret
}