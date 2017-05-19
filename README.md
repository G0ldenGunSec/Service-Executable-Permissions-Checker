# Service-Executable-Permissions-Checker

serviceExePermissionsChecker v1.0

Used for privilege escalation, looks for misconfigurations in folder security permissions by attempting to directly modify service executable names.  Finds items that other tools miss due to the way they do checks, which is often caused by overlapping permissions on files (ex. 'domain users' and 'everyone' groups have different access rights to the same folder).
    
Usage (in empire): 
  1. scriptimport/path/to/ps1/here/serviceExePermissionChecker.ps1
  2. scriptcmd sepc
  
Example Output:  -- any items displayed are potentially misconfigured executables  
  
       Beginning Search
  
      "C:\Program Files (x86)\Google\Update\GoogleUpdate.exe"
  
       Module execution completed, any hits should be displayed above
