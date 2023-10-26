<#
 .Synopsis
  Powershell Module to Collect Weather Data.

 .Description
  Collect and export weather data and export it in multiple formats

 .Parameter Sates
  A single or multiple States to collect weather data from.

 .Parameter Type
  The Type of Weather Data to collect. Defaults to Alerts.

 .Parameter OutputDirectory
  The path to output data to.

 .Parameter FileTypes
  One or more File Type to export the data to.

 .Example
   # Get Weather Alerts for the state of California in JSON Format
   Get-WeatherData -State CA

 .Example
   # Get Weather Alerts for the state of California in CSV Format
   Get-WeatherData -State CA - FileType CSV

 .Example
   # Get Weather Alerts for the state of California, Nebraska, Idaho, and Hawaii in CSV and JSON Format. Send the data to a specified Directory.
   Get-WeatherData -State NE, CA, ID, HI, WY -FileTypes "CSV", "JSON" -OutputDirectory c:\temp\test\weather\
#>
Function Get-WeatherData {
    param (
        [string[]]$States,
        [string[]]$Type = "Alerts",
        [string]$OutputDirectory = "C:\Temp\WeatherData",
        [ValidateSet('JSON', 'CSV')]
        [string[]]$FileTypes = @('JSON')
    )

    # Validate and sanitize the state input
    if ($State -notmatch '^[A-Z]{2}$') {
        Write-Host "Invalid state code. State code should be 2 uppercase letters (e.g., 'NY')."
        return
    }

    # Create the output directory if it doesn't exist
    if (-not (Test-Path -Path $OutputDirectory -PathType Container)) {
        New-Item -Path $OutputDirectory -ItemType Directory
    }

    # Construct the URL with URL-encoded state parameter
    
    try {
        # Send the HTTP request
        $Response = Invoke-RestMethod -Uri $Url
        $Alerts = $Response.features

        # Format the file name
        $CurrentDate = Get-Date -Format "yyyyMMdd_HHmmss"

        foreach ($State in $States) {
            $EncodedState = [System.Web.HttpUtility]::UrlEncode($State)
            $Url = "https://api.weather.gov/alerts/active?area=$EncodedState"

            foreach ($FileType in $FileTypes) {
                $FileExtension = if ($FileType -eq 'CSV') { 'csv' } else { 'json' }
                $FileName = "${State}_${CurrentDate}.$FileExtension"
                $FilePath = Join-Path -Path $OutputDirectory -ChildPath $FileName
            
                if ($FileType -eq 'CSV') {
                    # Create an empty array to store the data
                    $CsvData = @()

                    foreach ($Alert in $Alerts) {
                        $PropertiesJson = $Alert.properties | ConvertTo-Json -Depth 10
                        $CsvData += [PSCustomObject]@{
                            id = $Alert.id
                            type = $Alert.type
                            geometry = $Alert.geometry
                            properties = $PropertiesJson
                        }
                    }
                
                    $CsvData | Export-Csv -Path $FilePath -NoTypeInformation
                    Write-Host "CSV alerts saved to $FilePath"
                } else {
                    # Create a JSON file
                    $JsonObjectArray = @()

                    foreach ($Alert in $Alerts) {
                        $PropertiesJson = $Alert.properties
                        $JsonObject = @{
                            id = $Alert.id
                            type = $Alert.type
                            geometry = $Alert.geometry
                            properties = $PropertiesJson
                        }
                        $JsonObjectArray += $JsonObject
                    }

                    # Convert to JSON with proper formatting
                    $JsonContent = $JsonObjectArray | ConvertTo-Json -Depth 10
                    $JsonContent | Out-File -FilePath $FilePath -Force
                    Write-Host "JSON alerts saved to $FilePath"
                }
            }
        }
    }
    catch {
        Write-Host "An error occurred: $_"
    }
}
