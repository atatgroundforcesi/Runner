# Runner
Automate Installation of Programms on Windows Systems with Powershell

## Pyton Installer
Automate Python Installation with Additional Params

|Param                  |Meaning                                                 |no|yes                   |
|-----------------------|--------------------------------------------------------|--|----------------------|
|InstallAllUsers=       | System Wide Installation                               |0 |1                     |
|PrependPath=           | Add Path to Environment                                |0 |1                     |
|Include_pip=           | Include Pip Package Manager                            |0 |1                     |
|include_test=          | Install Python Documentary                             |0 |1                     |

## Docker Installer

Not Testetd Yet

### Version Beta

No Longer Configuration in Script will be needed.
Configure your Installation with XML File.

Beta Version is Recommended for Using it Temporary. No Changes at the
Environment of the System will be made.

### How To Use with Beta in 4 Steps (Short) ?

1. Execute Setup.1 Script as Adminstrator with Powershell

2. Go To Package and Open XML File

3. Change Your DownloadString, VersionNumber, InstallOptions as you like.

4. Save XML and Execute Script python-runner.ps1

## Developer Mode
> How Can i Add a New Feature ?

To add a new Feature First set a New XML Tag at Additional. Second Create your Own PowerShell Function to Process your own
written XML Tag