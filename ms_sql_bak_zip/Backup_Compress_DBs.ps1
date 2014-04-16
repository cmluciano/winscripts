#Title:     Backup_Compress_DBs
#Purpose:   This script backs up the SQL databases from a file and compresses them to a zip drive
#Use:       Place this file under the the path listed below or an alternative path that you created
#           Create a txt file in your specififed path that contains all of the databases that you want to backup
#           Specify the output location under the output function
#Necessary dlls
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO")| out-null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended")| out-null
 
#can also add instance here
$server = new-object ("Microsoft.SqlServer.Management.Smo.Server") #("USE THIS SPOT TO SPECIFY A SERVER\INSTANCE")

#Name:       Add ZIP file     
#Use:        Create the zip folders for the .bak files
function Add-Zip
{
    param([string]$zipfilename)

    if(-not (test-path($zipfilename)))
    {
        set-content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
        (dir $zipfilename).IsReadOnly = $false  
    }
    
    $shellApplication = new-object -com shell.application
    $zipPackage = $shellApplication.NameSpace($zipfilename)
    
    foreach($file in $input) 
    { 
            $zipPackage.CopyHere($file.FullName)
            Start-sleep -milliseconds 2000
    }
}

#Name:       Import DB list        
#Use:        Imports text file with defined databases
#            Txt file must be defined in the below path and path should be undated depending on specific system drives
$dbs = Get-Content "E:\temp\Databases.txt"

#Name:       Export Path       
#Use:        Export path location listed below will house all zip files 
$bkdir = "E:\Temp\Dbs"
 

#Name:       Create_BAK_DB       
#Use:        Assign name to bak folder according to year,month,day,hr,mm format
#            Create .bak file of databases in designated folder
#            Zip .bak into created folders
#            Delete original bak files
if (!(Test-Path $bkdir)) {New-Item $bkdir -Type Directory | Out-Null}

ForEach ($line in $dbs)
    {
     $dbname = $line
     $dt = get-date -format yyyyMMddHHmm 
     $dbBackup = new-object ("Microsoft.SqlServer.Management.Smo.Backup")
     $dbBackup.Action = "Database"
     $dbBackup.Database = $dbname
     
     $bckfile = $bkdir + "\" + $dbname   + $dt + ".bak"
     $bckfilezip = $bkdir + "\" + $dbname   + $dt + ".zip"

     $dbBackup.Devices.AddDevice($bckfile, "File")
     $dbBackup.SqlBackup($server)

     dir $bckfile  | add-Zip $bckfilezip -force

     Remove-Item $bckfile
    }