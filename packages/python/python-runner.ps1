#Author Simon Dürr
#Date 16.03.2022
#Version Beta 0.1

#Do Not Override This Variable!!!
$RunnerSources = "$env:ProgramData\runner"

#Folders and Filenames, could be overwritten
$packageFolder = "packages"
$XmlTemplate = "latest"
$PackageName = "python"

function Install-Package{
    #create structure
    try{

        $packages = Get-ChildItem -Path $RunnerSources -Verbose

        foreach ($package in $packages){
            If (-Not(Test-Path $RunnerSources\$package\$PackageName)){
                Write-Host -ForegroundColor Cyan "(I): Creating Path $RunnerSources\$package\$PackageName"
                New-Item -Path $RunnerSources\$package\$PackageName -ItemType Directory
                Write-Host -ForegroundColor Green "(S): Creating Path $RunnerSources\$package\$PackageName"
            }
            else{
                Write-Host -ForegroundColor Cyan "(I): Creating Path $RunnerSources\$package\$PackageName already exists"
            }
        }
    }
    catch{
        Debug-UndefinedError
    }
  #Move XML Image to C:\ProgramData\Runner\packages\$PackageName
  try{
    Move-Item -Path ".\$PackageFolder\$PackageName\$XmlTemplate.xml" -Destination "$RunnerSources\packages\$PackageName\$XmlTemplate.xml"
    Write-Host -ForegroundColor Green "(S): File Successful moved to new Destination $RunnerSources\packages\$XmlTemplate.xml"
  }
  catch{
      Write-Host -ForegroundColor Red "Could not Move File from .\demo-packages\$XmlTemplate.xml to Destination $RunnerSources\packages\$PackageName\$XmlTemplate.xml"
   }
 
  #Load XML
  [xml]$XMLPython = Get-Content -Path "$RunnerSources\packages\$PackageName\$XmlTemplate.xml"

  #Variables from XML File
  $XMLPython_DownloadVersion = $XMLPython.Runner.Download.DownloadVersion

  #Download Python
  $webobject = New-Object System.Net.WebClient
  $webobject.DownloadFile($XMLPython.Runner.Download.DownloadUrl,"$RunnerSources\.sources\$PackageName\$XMLPython_DownloadVersion.exe")

  #Create HashValue
  $Python_Hash = Get-FileHash -Path "$RunnerSources\.sources\$PackageName\$XMLPython_DownloadVersion.exe" -Algorithm SHA512
  $Python_Hash | Out-File -FilePath "$RunnerSources\.sources\$PackageName\$XMLPython_DownloadVersion.txt"

  Start-Process -FilePath "$RunnerSources\.sources\$PackageName\$XMLPython_DownloadVersion.exe"  -ArgumentList "/quiet" -Wait
}

Install-Package

# Error Handling
function Debug-UndefinedError{ 
     Write-Host -ForegroundColor Red @"
(E): An undefined Error Occured
"@
 }