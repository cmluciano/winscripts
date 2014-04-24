$hname = $env:computername

(Get-Content C:\file.exe.config) | 
Foreach-Object {$_ -replace "look_for", "$hname.domain"} | 
Set-Content C:\file.exe.config
