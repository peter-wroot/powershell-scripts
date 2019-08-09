# TimeSync: An open-source PowerShell script for correcting the time on Windows systems.
# Written by Peter Wroot, on the 9th August 2019. github.com/peter-wroot
# Licensed under the GNU GPL 3.0 license.

# First things first: Let's clear the shell window. 
Clear-Host

# We'll print a new line here, just to maintain the / a e s t h e t i c /
Write-Host("`n")

# Next up: Let's print off the opening logo. 
Write-host("`t============================================================")
Write-host("`t     ________ _                 ____________________________")
Write-host("`t    |___   __(_)               / ___________________________")
Write-host("`t        | |   _ _ __ ___   ___| (___  _   _ _ __   ___      ")
Write-host("`t        | |  | | '_ ' _ \ / _ \\___ \| | | | '_ \ / __|     ")
Write-host("`t        | |  | | | | | | |  __/____) | |_| | | | | (__      ")
Write-host("`t        | |  |_|_| |_| |_|\_________/ \__, |_| | |\___|     ")
Write-host("`t________| |______________________________/ |   | |          ")
Write-host("`t________| |_______________________________/    | |          ")
Write-host("`t        | |                                    | |          ")
Write-host("`t============================================================")

# We'll print a new line here, to keep things clean.
Write-Host("`n")

# Let's kick the script off by printing some text to tell the user what we're doing!
Write-host("`tRe-synchronizing windows Time...")
Write-host("`n")

# We'll record the time before the sync command, the time the sync command takes to run, and the time after the sync command.
[datetime]$PreviousSystemTime = Get-Date



$ResyncRuntime = Measure-Command {net time \\pool.ntp.org /set /y} | Select-Object -ExpandProperty Milliseconds

[datetime]$CurrentSystemTime = Get-Date

# Now, we're going to present these times to the user. `t represents a 'tab' character, so everything is spaced out nicely!
Write-Host("`tTime before synchronization:          `t"   + $PreviousSystemTime.ToString("HH:mm:ss:fff"))
Write-host("`tTime after synchronization:           `t"   + $CurrentSystemTime.ToString("HH:mm:ss:fff"))
Write-Host("`tRuntime of synchronization command:   `t"   + $ResyncRuntime + " Milliseconds")
Write-host("`n")

# Here we figure out the difference between the time before the re-sync, and the time after the re-sync. 
# Then, we minus the time the re-sync took to run from the difference. This (should) equal zero if the system is keeping perfect time.
$TimeDifference = New-TimeSpan -start $PreviousSystemTime -End $CurrentSystemTime | Select-Object -expandproperty Milliseconds
$TimeDifferenceExcludingResyncRuntime = $TimeDifference - $ResyncRuntime

# Now we're presenting the time differences to the user. more 'tab' characters are used to line things up. 
Write-Host("`tActual Difference: `t`t`t" + $TimeDifference + " Milliseconds")
Write-host("`tDifference Accounting for runtime: `t" + $TimeDifferenceExcludingResyncRuntime + " Milliseconds")
Write-host("`n")

#
Write-host("`t============================================================")

# And another new-line here, just to top it off!
Write-host("`n")