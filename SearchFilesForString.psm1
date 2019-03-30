#Take in list of files (Array or wilcards)
#Take in search term
#Perform Match on each with for loop.
#Need Table Format, Autosize

Function SearchFilesForString {
param (
[parameter (Mandatory=$false)]$SearchString,
[parameter (Mandatory=$false)]$FileLocation,
[parameter (Mandatory=$false)]$FileFilter
)

#Manual Over-Ride / Testing
#$FileLocation = "C:\TEMP\"  #Change to your location!
#$FileFilter = "*.csv" #Change to your filename filter
#$SearchString = "testservername"

$FileList = Get-ChildItem $FileLocation -Filter $FileFilter 

CLS
Write-Host ("#" * (26 + $SearchString.Length))
write-Host -no "## " -f White;Write-Host -no "Search Results for: " -f Green;Write-Host -no "$SearchString" -f Red;Write-Host " ##" -f White
Write-Host ("#" * (26 + $SearchString.Length))
Write-Host ""

    ForEach ($File in $FileList) {
        
        $LinesReturned = (Import-Csv $File.FullName | where {$_ -like "*$SearchString*"} | Measure-Object).Count

        IF ($LinesReturned -gt 0) {
            Write-Host -no "FileName: " -f Red;Write-Host $File.FullName
            [int]$LinesInFile = 0
            $reader = New-Object IO.StreamReader $File.FullName
            while($reader.ReadLine() -ne $null){ $LinesInFile++ }
            ($reader.Dispose())
        
        Write-Host -no "Records Count Total = " -f White;Write-Host $LinesInFile -f Yellow
        Write-Host -no "Records Returned = " -f White;Write-Host $LinesReturned -f Yellow  
        
        $Global:FoundItem = Import-Csv $File.FullName | where {$_ -like "*$SearchString*"}
        $TableFormatted = $FoundItem | sort Name | Format-Table -AutoSize
        $TableFormatted
        }
    }
}
