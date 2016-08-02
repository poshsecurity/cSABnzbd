#cSABnzbd

A simple DSC module for maintaining a SABnzbd+ install

## Resources

* **SABnzbdInstall** controls installation of SABnzbd

### SABnzbdInstall

Controls the installation (absent or present) of SABNzbd, also ensure that the software is automatically updated.

* **Ensure**: Ensure either Absent or Present (Installed and Updated)
* **ServiceCredential**: Credential of service to run as

## Versions

### 1.5

* Code optimisation and clean-up
* Updated examples and documentation

### 1.4

* Work to ensure that the DSC module meets community guidelines and DSC guidelines
* Added PS5 requirements to PSD
* Not released to PowerShell Gallery

### 1.3

* Switched from standard web parsing to basic web parsing and not reliant on IE
* Released to PowerShell Gallery

### 1.2

* Cleaned up unrequired parameter
* Released to PowerShell Gallery

### 1.1

* Fixed incorrect resource name
* Released to PowerShell Gallery

### 1.0

* Initial version
* Released to PowerShell Gallery


## Examples
### Ensure SABnzbd Installed

```powershell
configuration DownloadHostDSC
{
    Import-DscResource -ModuleName 'cSABnzbd'

    cSABnzbdInstall SABnzbdInstaller
    {
        Ensure    = 'Present'
    }
}
```

Ensures that SABnzbd is installed.

### Ensure SABnzbd not installed

```powershell
configuration DownloadHostDSC
{
    Import-DscResource -ModuleName 'cSABnzbd'

    cSABnzbdInstall SABnzbdInstaller
    {
        Ensure    = 'Absent'
    }
}
```

Ensures that SABnzbd is not installed.
