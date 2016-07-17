#xSABnzbd

A simple DSC module for maintaining a SABnzbd+ install

## Resources

* **SABnzbdInstall** controls installation of SABnzbd

### SABnzbdInstall

Controls the installation (absent or present) of SABNzbd, also ensure that the software is automatically updated.

* **Ensure**: Ensure either Absent or Present (Installed and Updated)
* **ServiceCredential**: Credential of service to run as

## Versions

### Unreleased

* 1.4 has not been released to PS Gallery

### 1.4

* Work to ensure that the DSC module meets community guidelines and DSC guidelines
* Developing test cases

### 1.3

* Switched from standard web parsing to basic web parsing and not reliant on IE

### 1.2

* Cleaned up unrequired parameter

### 1.1

* Initial version


## Examples
### Ensure SABnzbd Installed

`
configuration DownloadHostDSC
{
    Import-DscResource -ModuleName 'cSABnzbd'

    cSABnzbdInstall SABnzbdInstaller
    {
        Ensure    = 'Present'
    }
}


Ensures that SABnzbd is installed.

### Ensure SABnzbd not installed

`
configuration DownloadHostDSC
{
    Import-DscResource -ModuleName 'cSABnzbd'

    cSABnzbdInstall SABnzbdInstaller
    {
        Ensure    = 'Absent'
    }
}


Ensures that SABnzbd is not installed.
