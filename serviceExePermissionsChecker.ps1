<#

    serviceExePermissionsChecker v1.0

    Used for privilege escalation, looks for misconfigurations in folder security permissions by attempting to directly modify service executable names.
    Finds items that powerup misses due to the way the tool does its checks, causing it to miss files that have overlapping permissions 
    (ex. users and authenticated users have different access rights to the same folder)

    Usage: Step 1. import-module serviceExePermissionChecker.ps1 ----- in empire:  scriptimport/path/to/ps1/here/serviceExePermissionChecker.ps1
    Usage: Step 2. sepc  -----  in empire:  scriptcmd sepc

#>

function sepc
{
"Beginning Search `n"
$serviceList = wmic service get pathname
$allPaths = New-Object -TypeName 'System.Collections.ArrayList'
for($i=0; $i -le $serviceList.GetUpperBound(0); $i++)
{
    $exeIndex = $serviceList[$i].IndexOf(".exe")
    if($exeIndex -gt -1)
    {
        $exeName = $serviceList[$i].Substring(0,$exeIndex+4)
        if($exeName.StartsWith('"'))
        {
            $exeName = $exeName + '"'
        }
       [void] $allPaths.add($exeName)	
    }
}
$allPaths = $allPaths | sort -Unique
for($i=0; $i -lt $allPaths.Count; $i++)
{
    $originalExeName = $allPaths[$i].Substring($allPaths[$i].LastIndexOf("\")+1)
    
    if($originalExeName.EndsWith('"'))
    {
        $originalExeName = $originalExeName -replace ".$"
    }
    $modifiedExeName = $originalExeName.insert($originalExeName.indexOf("."),"1")
    $fullPath1 = 'Rename-Item -Path ' + $allPaths[$i] + ' -NewName "' + $modifiedExeName + '" -Force -ErrorAction Stop'

    try
    {
	iex $fullPath1
	"`n "
        $allPaths[$i]
        $modifiedExePath=  $fullPath1.substring(0,$fullPath1.indexOf(".exe")) + "1.exe"
        if($modifiedExePath.indexOf('"') -gt -1)
        {
            $modifiedExePath = $modifiedExePath + '"'
        }
        $modifiedExePath = $modifiedExePath + ' -NewName "' + $originalExeName + '" -Force -ErrorAction Stop'
        iex $modifiedExePath
    }
    catch {}
}
"`nModule execution completed, any hits should be displayed above"
}