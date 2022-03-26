#Author Simon Dürr
#Date 16.03.2022
#Version Beta 0.1

#Override Variable!
$RunnerSources = "$env:ProgramData\runner"

#Introducing Runner
Write-Host -ForegroundColor Blue @"

########  ##     ## ##    ## ##    ## ######## ########  
##     ## ##     ## ###   ## ###   ## ##       ##     ## 
##     ## ##     ## ####  ## ####  ## ##       ##     ## 
########  ##     ## ## ## ## ## ## ## ######   ########  
##   ##   ##     ## ##  #### ##  #### ##       ##   ##   
##    ##  ##     ## ##   ### ##   ### ##       ##    ##  
##     ##  #######  ##    ## ##    ## ######## ##     ##

Welcome to Runner, a Tool to fullfill your Install wishes ;)

"@
Write-Host "Following Debuging Options Are Available:"
Write-Host -NoNewLine -ForegroundColor Cyan "(I): Information "
Write-Host -NoNewLine -ForegroundColor Green "(S): Success "
Write-Host -ForegroundColor Red "(E): Error "

Set-Runner
#This Block creates folder Structure of Runner at C:\ProgramData\runner
function Set-Runner{
    $Runner_Path = $RunnerSources #There will be soon Option for configuration of own Installation Path with XML
    $Runner_Path_Subpaths = @('packages', '.sources','file-templates','logs')

    Write-Host -ForegroundColor Cyan "(I): Setting Up Runner ..."

    #path exists ?
    If (-Not (Test-Path -Path $Runner_Path)){
        
        New-Item -Path $Runner_Path -ItemType Directory -Verbose
        Write-Host -ForegroundColor Green "(S): Path $Runner_Path created"
    }
    #debug msg
    else{
            Write-Host -ForegroundColor Cyan "(I): Path $Runner_Path already existing, Path not created"
        }
    
    # create Paths in $Runner_Path_Subpaths
    for ($p = 0; $p -lt $Runner_Path_Subpaths.Length; $p++){
            New-Item  -Path $Runner_Path\$($Runner_Path_Subpaths[$p]) -ItemType Directory -Verbose
            Write-Host -ForegroundColor Green "(S): $Runner_Path\$($Runner_Path_Subpaths[$p]) - created"
    
    }
    Write-Host -ForegroundColor Cyan "(I): Successfully Installed, Runner will be closed now"
    Exit-PSSession
}
#Errorhandling
function Debug-UndefinedError{
    Write-Host -ForegroundColor Red @"
(E): An undefined Error Occured!
If Error can't resolved, open Issue https://github.com/simonduerr-coder/Runner/issues/new
"@
}