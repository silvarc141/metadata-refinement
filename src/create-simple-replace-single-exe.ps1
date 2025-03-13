Install-Module ps2exe -SkipPublisherCheck -AcceptLicense -Force -AllowClobber -Confirm:$False
ps2exe -inputFile ./simple-replace-gui.ps1
