#Title: 	Find Disk Space
#Purpose:	This script retrieves system information from either a local machine or a group of servers
#Use:		Uncomment lines below in order to change from local/remote server or csv_output/grid_view

#Name:		LOCAL-MACHINE	
#Use:		if you just want to run this on your local machine uncomment this line below
#$CompName = get-content env:computername

#Name:		REMOTE-MACHINE	
#Use:		if you want to check a list of computers, uncomment the line below and make a txt file with the remote hostnames in it/place 			 it in the path below 
#$CompName = Get-Content c:\temp\servers.txt

#Name:		GATHER_INFO
#Use:		Checks for System Name, DeviceID and attached Drives, Size of Disk, Free Space (GB), and Perecent of Free Space 
Get-WMIObject Win32_LogicalDisk -filter "DriveType=3" -computer $CompName |
 Select SystemName,DeviceID,VolumeName,
 @{Name="Size(GB)";Expression={[decimal]("{0:N1}" -f($_.size/1gb))}},
 @{Name="Free Space(GB)";Expression={[decimal]("{0:N1}" -f($_.freespace/1gb))}},
 @{Name="Free Space(%)";Expression={"{0:P2}" -f(($_.freespace/1gb) / ($_.size/1gb))}} |
 sort-object "Free Space(%)" |

#Name:		EXPORT_AS_CSV			
#Use:		Uncomment the line below to export the output as a csv
#If you want to export it to a csv, use this
#Export-CSV C:\temp\drivesizes.csv

#Name:		EXPORT_AS_GRID
#Use:		Uncomment the line below to export the output as a grid
#or if you want to see it in a grid, use this:
# Out-GridView -Title "Drive Space" 
