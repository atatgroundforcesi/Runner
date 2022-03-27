#Author Simon Dürr
#Date 16.03.2022
#Version Beta 0.1

#Do Not Override!
$global:RunnerSources = "$env:ProgramData\runner"

#Folders and Filenames, could be overwritten
$global:packageFolder = "packages"
$global:XmlTemplate = "latest" #name of the XML file
$global:PackageName = "python" #pathname

#Main
New-Package #tag f1

Move-Package #tag f2

Get-XmlFile #tag f3

Get-Package #tag f4

Install-Package #tag f5

Install-PackageAddOns #tag f6

#------------ Install Part---------------#
#Write your Own Functions to Add More Features
#To Follow the Intuition: 1 Function = 1 One Job

#Function 1. Create PackageDir at Runner
#f1
function New-Package{
    try{

        $packages = Get-ChildItem -Path $RunnerSources -Verbose

        foreach ($package in $packages){
            If (-Not(Test-Path $RunnerSources\$package\$PackageName)){
                Write-Host -ForegroundColor Cyan "(I): Creating Path $RunnerSources\$package\$PackageName"
                New-Item -Path $RunnerSources\$package\$PackageName -ItemType Directory -Verbose
                Write-Host -ForegroundColor Green "(S): Creating Path $RunnerSources\$package\$PackageName"
            }
            else{
                Write-Host -ForegroundColor Cyan "(I): Creating Path $RunnerSources\$package\$PackageName already exists"
            }
        }
        Move-Package
    }
    catch{
        Debug-UndefinedError
        Exit-PSSession
    }
}
#Function 2. Moves XML File to the Template folder to Execute
#f2
function Move-Package{  #Move XML Image to C:\ProgramData\Runner\packages\$PackageName
    try{
        Move-Item -Path ".\beta\$PackageFolder\$PackageName\$XmlTemplate.xml" -Destination "$RunnerSources\packages\$PackageName\$XmlTemplate.xml"
        Write-Host -ForegroundColor Green "(S): File Successful moved to new Destination $RunnerSources\packages\$XmlTemplate.xml"
      }
      catch{
          Write-Host -ForegroundColor Red "Could not Move File from .\$PackageFolder\$XmlTemplate.xml to Destination $RunnerSources\packages\$PackageName\$XmlTemplate.xml"
          Exit-PSSession
       }
}
#Function 3. Load XML File
#f3
function Get-XmlFile{
    try{
        #Load XML
        [xml]$XMLFile = Get-Content -Path "$RunnerSources\packages\$PackageName\$XmlTemplate.xml" -Verbose
        $XMLFile.Runner
    
      }
      catch{
        Debug-SyntaxError
        Exit-PSSession
      }
}
#Function 4. Download Package
#f4
function Get-Package{ #Download Package

    [xml]$XMLFile = Get-Content -Path "$RunnerSources\packages\$PackageName\$XmlTemplate.xml" -Verbose

    $XMLFile_DownloadVersion = $XMLFile.Runner.Download.DownloadVersion
    $XMLFile_DownloadFile = $XMLFile.Runner.Download.DownloadUrl

      try{
        $webobject = New-Object System.Net.WebClient
        $webobject.DownloadFile($XMLFile_DownloadFile,"$RunnerSources\.sources\$PackageName\$XMLFile_DownloadVersion.exe")
        Write-Host -ForegroundColor Green "(S): File Successful Downloaded from Source $XMLFile_DownloadFile to Destination $RunnerSources\.sources\$PackageName\ $XMLFile_DownloadVersion.exe"
      }
      catch{
        Debug-DownloadError
        Exit-PSSession
      }
}

#Function 5. InstallPackage
#f5
function Install-Package{
    [xml]$XMLFile = Get-Content -Path "$RunnerSources\packages\$PackageName\$XmlTemplate.xml" -Verbose
    $XMLFile_InstallOption = $XMLFile.Runner.InstallFile.Option
    $XMLFile_DownloadVersion = $XMLFile.Runner.Download.DownloadVersion

  #Install Package
  Write-Host -ForegroundColor Cyan  "(I): Installstring: $RunnerSources\.sources\$PackageName\$XMLFile_DownloadVersion.exe /quiet $XMLFile_InstallOption"
  Start-Process -FilePath "$RunnerSources\.sources\$PackageName\$XMLFile_DownloadVersion.exe"  -ArgumentList "/quiet $XMLFile_InstallOption" -Wait
}

#Function 6. Install Package Addons (This Function is specific for the Package)
#f6
function Install-PackageAddOns{
    [xml]$XMLFile = Get-Content -Path "$RunnerSources\packages\$PackageName\$XmlTemplate.xml" -Verbose
    $XMLFile_InstallAddOns = $XMLFile.Runner.InstallAddOns.Value
    #First Check if Pip Installer is installed
    try{
        cmd.exe /c "python -m pip install  $XMLFile_InstallAddOns"
    }
    catch{
      Debug-InstallationError
    }
    #Install Addons for Pip Installer
}
#------------ Uninstall Package---------------#

#Coming Soon :)

#------------ Error Handling Messgae Part---------------#
#Write your Own Functions to Debug 
#To Follow the Intuition: 1 Function = 1 One Job
function Debug-UndefinedError{ 
     Write-Host -ForegroundColor Red @"
(E): An undefined Error Occured
"@
    Exit-PSSession    
 }
 function Debug-DownloadError{
    Write-Host -ForegroundColor Red @"
(E): Connection could not be established."
1. Check if you are able to reach any URL
2. Check if Url $XMLFile_DownloadFile exists
"@
 }
 function Debug-SyntaxError{
     Write-Host -ForegroundColor Red @"
(E): Could not Read Data from XML. Please Check XML Syntax https://www.w3schools.com/xml/xml_validator.asp or if File exists
"@
    Exit-PSSession
 }
 function Debug-InstallationError{
    Write-Host -ForegroundColor Red @"
(E): Installation Failed
"@
 }