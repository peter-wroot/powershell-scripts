# Restart-VSSWriters.ps1
# A PowerShell Script to locate any failing VSS writers and gently persuade them to work again. 
# Based off of a script posted by "Swarfega" on Reddit: https://www.reddit.com/r/PowerShell/comments/80ua5i/vss_writers_restart_script_if_failed/

# List VSS writers and then format the output to only show the writer names. 
$writers = vssadmin list writers | Select-String -Context 0,4 'Writer name:' | ? {$_.Context.PostContext[2].Trim() -ne "Last error: No error"} | Select Line | % {$_.Line.tostring().Split("'")[1]}

# The VSS writer names don't match what their respective services are called, so this function works as a lookup table to return the service name.
$ServiceNames = $writers | 
    ForEach-Object {
        switch ($_) {
            'ASR Writer' { $Result = 'VSS' }
            'Bits Writer' { $Result = 'BITS'}
            'Certificate Authority' { $Result = 'EventSystem'}
            'COM+ REGDB Writer' { $Result = 'VSS'}
            'DFS Replication service writer' { $Result = 'DFSR'}
            'Dhcp Jet Writer' { $Result = 'DHCPServer'}
            'FRS Writer' { $Result = 'NtFrs' }
            'IIS Config Writer' { $Result = 'AppHostSvc'}
            'IIS Metabase Writer' { $Result = 'IISADMIN'}
            'Microsoft Exchange Writer' { $Result = 'MSExchangeIS'}
            'Microsoft Hyper-V VSS Writer' { $Result = 'vmms'}
            'MS Search Service Writer' { $Result = 'EventSystem'}
            'NPS VSS Writer' { $Result = 'EventSystem'}
            'NTDS' { 'EventSystem'}
            'OSearch VSS Writer' { $Result = 'OSearch'}
            'OSearch14 VSS Writer' { $Result = 'OSearch14'}
            'Registry Writer' { $Result = 'VSS'}
            'Shadow Copy Optimization Writer' { $Result = 'VSS'}
            'Sharepoint Services Writer' { $Result = 'SPWriter'}
            'SPSearch VSS Writer' { $Result = 'SPSearch'}
            'SPSearch4 VSS Writer' { $Result = 'SPSearch4'}
            'SqlServerWriter' { $Result = 'SQLWriter'}
            'System Writer' { $Result = 'CryptSvc'}
            'WMI Writer' { $Result = 'Winmgmt'}
            'TermServLicensing' { $Result = 'TermServLicensing'}
        }
        $result
    }

# Re-starts the services 
If ($ServiceNames) { Restart-Service -Name ($ServiceNames | Select-Object -Unique) -Force}
If ($Result) { Restart-Service -Name ($ServiceNames | Select-Object -Unique) -Force}
