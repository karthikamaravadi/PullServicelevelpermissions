﻿$services = get-wmiobject -query 'select * from win32_service'
foreach ($service in $services) {
    $path=$Service.Pathname
    if (-not( test-path $path -ea silentlycontinue)) {
        if ($Service.Pathname -match "(\""([^\""]+)\"")|((^[^\s]+)\s)|(^[^\s]+$)") {
            $path = $matches[0] –replace """",""
        }
    }
    if (test-path "$path") {
        $ServiceName = $service.Displayname
        $secure=get-acl $path
        foreach ($item in $secure.Access) {
            if (
                 ($item.IdentityReference -match "Authenticated Users"  ) -or
                 ($item.IdentityReference -match "Everyone"  ) -or
                 ($item.IdentityReference -match "Users"   ) )  {
                 
                 if ($item.FileSystemRights.tostring() -match "Write|Special Permissions|FullControl|Modify|Change") {
                   
                   $IdentityReferencename=($item.IdentityReference)
                   $AccessControlType= ($item.AccessControlType)
                   $FileSystemRights= ($item.FileSystemRights)
                   $IsInherited= ($item.IsInherited)
                   $InheritanceFlags= ($item.InheritanceFlags)
                   $PropagationFlags= ($item.PropagationFlags)

                   $path
                   $ServiceName
                   $IdentityReferencename
                   $AccessControlType
                   $FileSystemRights 
                   $IsInherited
                   $InheritanceFlags
                   $PropagationFlags
                    
                 if($FileSystemRights -eq "ReadAndExecute, Synchronize"){
                     $Aligned= ("Yes")
                    $report = New-Object psobject
                    $report | Add-Member -MemberType NoteProperty -name Path             -value $path
                    $report | Add-Member -MemberType NoteProperty -name ServiceName     -value $ServiceName.ToString()
                    $report | Add-Member -MemberType NoteProperty -name IdentityReferencename     -value $IdentityReferencename 
                    $report | Add-Member -MemberType NoteProperty -name AccessControlType     -value $AccessControlType 
                    $report | Add-Member -MemberType NoteProperty -name FileSystemRights     -value $FileSystemRights 
                    $report | Add-Member -MemberType NoteProperty -name InheritanceFlags     -value $InheritanceFlags  
                    $report | Add-Member -MemberType NoteProperty -name PropagationFlags     -value $PropagationFlags
                    $report | Add-Member -MemberType NoteProperty -name Aligned     -value $Aligned
                    $report | export-csv "builtinORauthenticated.csv" -Append -NoClobber
                   }
                 else{
                 
                    $NotAligned= ("No")
                    $report = New-Object psobject
                    $report | Add-Member -MemberType NoteProperty -name Path             -value $path
                    $report | Add-Member -MemberType NoteProperty -name ServiceName     -value $ServiceName.ToString()
                    $report | Add-Member -MemberType NoteProperty -name IdentityReferencename     -value $IdentityReferencename 
                    $report | Add-Member -MemberType NoteProperty -name AccessControlType     -value $AccessControlType 
                    $report | Add-Member -MemberType NoteProperty -name FileSystemRights     -value $FileSystemRights 
                    $report | Add-Member -MemberType NoteProperty -name InheritanceFlags     -value $InheritanceFlags  
                    $report | Add-Member -MemberType NoteProperty -name PropagationFlags     -value $PropagationFlags
                    $report | Add-Member -MemberType NoteProperty -name Aligned     -value $Aligned
                    $report | export-csv "builtinORauthenticated.csv" -Append -NoClobber
                   }
                   
                }
            } 
            
            else {         
                
                 
            }

        }
    } else {
            Write ("Service Path Not Found:    "+$service.Displayname)
            Write ("   "+$Path)
    }
}