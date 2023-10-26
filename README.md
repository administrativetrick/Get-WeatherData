# Get-WeatherData
A Powershell Module to collect Weather Data

NAME
    Get-WeatherData
    
SYNOPSIS
    Powershell Module to Collect Weather Data.
    
    
SYNTAX
    Get-WeatherData [[-States] <String[]>] [[-Type] <String[]>] [[-OutputDirectory] <String>] [[-FileTypes] <String[]>] 
    [<CommonParameters>]
    
    
DESCRIPTION
    Collect and export weather data and export it in multiple formats
    

PARAMETERS
    -States <String[]>
        
        Required?                    false
        Position?                    1
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -Type <String[]>
        The Type of Weather Data to collect. Defaults to Alerts.
        
        Required?                    false
        Position?                    2
        Default value                Alerts
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -OutputDirectory <String>
        The path to output data to.
        
        Required?                    false
        Position?                    3
        Default value                C:\Temp\WeatherData
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -FileTypes <String[]>
        One or more File Type to export the data to.
        
        Required?                    false
        Position?                    4
        Default value                @('JSON')
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
INPUTS
    
OUTPUTS
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\># Get Weather Alerts for the state of California in JSON Format
    
    Get-WeatherData -State CA
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\># Get Weather Alerts for the state of California in CSV Format
    
    Get-WeatherData -State CA - FileType CSV
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\># Get Weather Alerts for the state of California, Nebraska, Idaho, and Hawaii in CSV and JSON Format. Send the data to a 
    specified Directory.
    
    Get-WeatherData -State NE, CA, ID, HI, WY -FileTypes "CSV", "JSON" -OutputDirectory c:\temp\test\weather\
    
    
    
    
    
RELATED LINKS
