#Author Simon Dürr
#Date 07.01.2022
#Version Beta 0.1

$RunnerSources = "$env:ProgramFiles\runner"

###Environment Variables To Override ###
#1.Download URL
$DownloadUrl = "https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe"

#2. Python Version
$PythonVersion = "Python 3.10.0"

#3.Location Python Scripts
#$MyScripts = "C:\tmp" #OVERRIDE!

#4. Additional Install Options for Python 1=True, 0=False
$PythonInstallOptions = @(

    "InstallAllUsers=1",#system wide installation
    "PrependPath=1",     #add PATH to Environment
    "include_pip=1",    #add pip package manager
    "include_test=1"     #install python documentary
)

#5. Additional Pip Installing Options 
$PythonPipInstallOptions = @(
    "virtualenv"
    "--upgrade pip"
)
### End Enviornment Variable Block"

function Install-Python {

    #Download Python
    $webobject = New-Object System.Net.WebClient
    $webobject.DownloadFile($DownloadUrl,"$RUNNER\acutualpythonversion.exe")

    Start-Process -FilePath $RUNNER\*.exe -ArgumentList "/quiet $PythonInstallOptions" -Wait

    if ([string]::IsNullOrEmpty($PythonPipInstallOptions)){
        Write-Output "No Options for Pip Installer set, installation continue ..."
    }
    
    else{
        foreach ($pip in $PythonPipInstallOptions){
        py -m pip install $pip
        }
    }
    if ((python --version) -eq $PythonVersion){
        Write-Output "$PythonVersion installed Sucessfully"
    }
    else {
        Write-Output "$PythonVersion Installation falied"
    }

}

#main
if (Test-Path -Path $RunnerSources){
     Write-Output "Path $RunnerSources already exists"
}
else{
   New-Item -Path $RunnerSources -ItemType directory
}

if ((gp HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName -Match $PythonVersion){
    Write-Host "Selected Version $PythonVersion of Python Already Installed"
    }
    
else {
Write-Output "Installing Python Version: $PythonVersion, Do not Close!"
Install-Python -Wait
}