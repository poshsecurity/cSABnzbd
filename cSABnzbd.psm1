enum Ensure
{
    Absent
    Present
}

[DscResource()]
class cSABnzbd 
{
    [DscProperty(Key)]
    [string] $Ensure
    
    [DscProperty()]
    [PSCredential]$ServiceCredential
    
    [DscProperty()]
    [bool]$EnableWindowsFirewall
        
    # Gets the resource's current state.
    [cSABnzbd] Get() 
    {
        # If SABnzbd is installed, check we have the latest version installed
        $Package = Get-Package -Name 'Sabnzbd' -ErrorAction SilentlyContinue
        if ($null -ne $Package) 
        { 
            $this.Ensure = [Ensure]::Present 
        }
        else 
        {
            $this.Ensure = [Ensure]::Absent
        }
        return $this
    }
    
    # Sets the desired state of the resource.
    [void] Set() 
    {
        if ($this.Ensure -eq [Ensure]::Present)
        {
            # Get Sabnzbd info from github
            $ReleaseInfo = $this.GetLatestVersion()
            $SetupAsset = $ReleaseInfo.assets | where {$_.name.contains('.exe')}
            $DownloadURI = $SetupAsset.browser_download_url
            
            # Download from Github
            $DownloadDestination = Join-Path -Path $ENV:temp -ChildPath 'SABnzbd-setup.exe'
            Invoke-WebRequest -Uri $DownloadURI -OutFile $DownloadDestination
            
            # Start install
            Start-Process -FilePath $DownloadDestination -ArgumentList '/S' -Wait
            
            # Make program data location
            $SABProgramData = Join-Path -Path $env:ProgramData -ChildPath 'sabnzbd'
            $null = mkdir -Path $SABProgramData
            
            # Service install paths (and ini)
            $SABIni = Join-Path -Path $SABProgramData -ChildPath 'sabnzbd.ini'
            $SABInstall = Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath 'SABnzbd'
            $SABhelper = Join-Path -Path $SABInstall -ChildPath 'SABnzbd-helper.exe' 
            $SABService = Join-Path -Path $SABInstall -ChildPath 'SABnzbd-service.exe'
            
            # Install Services
            if ($null -eq $this.ServiceCredential)
            {
                & $SABhelper --startup auto install
                & $SABService --startup auto -f $SABIni install
            }
            else 
            {
                $Username = $this.ServiceCredential.UserName
                $Password = $this.ServiceCredential.GetNetworkCredential().Password
                & $SABhelper --startup auto --username $Username --password $Password install
                & $SABService --startup auto --username $Username --password $Password -f $SABIni install
            }
            
            # Start service
            start-service sabnzbd
        }
        else
        {
            $SABInstall = Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath 'SABnzbd'
            $SABUninstaller = Join-Path -Path $SABInstall -ChildPath 'uninstall.exe'
            Start-Process -FilePath $SABUninstaller -ArgumentList '/S' -Wait
        }
    }
    
    # Tests if the resource is in the desired state.
    [bool] Test() 
    {
        # If SABnzbd is installed, check we have the latest version installed
        $Package = Get-Package -Name 'Sabnzbd' -ErrorAction SilentlyContinue
        
        if ($this.Ensure -eq [Ensure]::Present)
        {
            if ($null -eq $Package)
            {
                return $false
            }
            else 
            {
                # Get Sabnzbd info from github
                $GitVersion = $this.GetLatestVersion().tag_name
                return ($Package.version -eq $GitVersion)    
            }
        }
        else 
        {
           # If it should be absent, check if null and return result
           return ($null -eq $Package) 
        }
    }
    
    [PSCustomObject] GetLatestVersion ()
    {
        $ReleaseInfo = Invoke-RestMethod -Uri 'https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest'
        return $ReleaseInfo
    }
}