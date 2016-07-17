configuration DownloadHostDSC
{
    Import-DscResource -ModuleName 'cSABnzbd'

    cSABnzbdInstall SABnzbdInstaller
    {
        Ensure    = 'Present'
    }
}
