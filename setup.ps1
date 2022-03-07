

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# READ ISTRUCTIONS BEFORE EXECUTE SETUP.PS1
#
# Go to to setup.xml
# Go to packages.xml
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#Load XML
[xml]$Packages = Get-Content -Path "./xml-config/packages.xml"
[xml]$Setup = Get-Content -Path "./xml-config/setup.xml"


#main
Write-Host -ForegroundColor Green "Welcome to Runner :)"
try{
    Set-Runner
}
catch{
    Write-Host -ForegroundColor Red "An Error Occured"
}
Set-Setup

#This Block creates folder Structure of Runner at C:\ProgramData\runner
function Set-Runner{
    $Runner_Path = "$env:ProgramData\runner"
    $Runner_Path_Subpaths = @('packages', 'sources','file-templates')

    If (-Not (Test-Path -Path $Runner_Path)){
        New-Item -Path $Runner_Path -ItemType Directory

        for ($i = 0;$i -lt $Runner_Path_Subpaths.Length; $i++){
            New-Item -Name $Runner_Path_Subpaths[$i] -Path $Runner_Path -ItemType Directory
        }
    }
    else {
        return "Path $Runner_Path already exists"
    }
}
function Set-Setup{
    If ($Setup.Runner.OwnList.Value -eq $false){

        Write-Host -ForegroundColor Blue @"
Default Package Libary is used. See Packages at ./xml-config/setup.xml
To Use your Own Libary, Set <OwnList Value="True"> and
paste your URL to Link an XML File https://my-repo.com/packages.xml
"@
    }
    else{
        Write-Host "Alternative set"
    }
}


