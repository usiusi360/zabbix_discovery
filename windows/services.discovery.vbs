
computerName = "\\."
sql = "select * from Win32_Service"

FIRST= "1"
 
Set obj = GetObject("winmgmts:{impersonationLevel=impersonate}!" & computerName & "\root\cimv2").ExecQuery(sql)

WScript.Echo "{"
WScript.Echo "     ""data"":["


For Each serviceName In obj
  If serviceName.StartMode = "Auto" Then

     If FIRST = 1 Then
          WScript.Echo ""
          FIRST= "0"
     Else
          WScript.Echo  ","
     End If

     WScript.StdOut.Write "          { ""{#SERVICE_NAME}"":""" & serviceName.Name &""" , ""{#SERVICE_DISPLAYNAME}"":""" & serviceName.DisplayName & """ }"

  End If

Next

WScript.Echo ""
WScript.Echo "     ]"
WScript.Echo "}"


