' Directory Environment
$If WINDOWS Then
    Declare Library 'Directory Information using KERNEL32 provided by Dav
        Function WINDirectory Alias GetWindowsDirectoryA (lpBuffer As String, Byval nSize As Long)
        Function SYSDirectory Alias GetSystemDirectoryA (lpBuffer As String, Byval nSize As Long)
        Function CURDirectory Alias GetCurrentDirectoryA (ByVal nBufferLen As Long, lpBuffer As String)
        Function TempPath Alias GetTempPathA (ByVal nBufferLen As Long, lpBuffer As String)
        Function GetModuleFileNameA (ByVal hModule As Long, lpFileName As String, Byval nSize As Long)
    End Declare
$End If
GetSpecialDirs:
$If WINDOWS Then
    '=== Get WINDOWS DIRECTORY
    TempDir$ = Space$(144)
    Result = WINDirectory(TempDir$, Len(TempDir$))
    If Result Then WinDir$ = Left$(TempDir$, Result)
    WinDir$ = _Trim$(WinDir$)


    '=== Get SYSTEM DIRECTORY
    TempDir$ = Space$(144)
    Result = SYSDirectory(TempDir$, Len(TempDir$))
    If Result Then SysDir$ = Left$(TempDir$, Result)
    SysDir$ = _Trim$(SysDir$)


    '=== Get CURRENT DIRECTORY
    TempDir$ = Space$(255)
    Result = CURDirectory(Len(TempDir$), TempDir$)
    If Result Then CurDir$ = Left$(TempDir$, Result)
    CurDir$ = _Trim$(CurDir$)


    '=== SHOW CURRENT PROGRAM
    TempDir$ = Space$(256)
    Result = GetModuleFileNameA(0, TempDir$, Len(TempDir$))
    If Result Then ProgName$ = Left$(TempDir$, Result)
    ProgName$ = _Trim$(ProgName$)


    '=== SHOW TEMP DIRECTORY
    TempDir$ = Space$(100)
    Result = TempPath(Len(TempDir$), TempDir$)
    If Result Then TempDir$ = Left$(TempDir$, Result)
    TempDir$ = _Trim$(TempDir$)
$Else
    ' Linux and MacOs use same
    TempDir$="/tmp/"
    ProgName$=command$(0) ' Argc[0] is program name
$End If
Return
'   WinDir$  SysDir$  CurDir$  ProgName$  TempDir$

