$Console:Only
$Let SAY = 0

Option _Explicit
'$Include:'CollectExactTimeTop.bi'

Const FALSE = 0
Const TRUE = -1
Const Version = "V1.0.7"
Const OurName = "TdarcosTimer"


Dim Cmd$(10), UCmd$(10), TimerID$, FileName$, D$, I%, K%
Dim As Integer FlagOn, FlagOff, FlagBatch, FlagVer, F, Cerr, Result
Dim Shared As Integer Year, Month, Day, Hour, Minute, Second
Dim Shared Year$, Month$, Day$, WeekDay$, Minute$, Second$, AmPm$
Dim Shared As String DateString, OldDateString
Dim Shared WinDir$, SysDir$, CurDir$, ProgName$, TempDir$
Dim Shared As Integer cf, cb, Acf, Acb

'' **** Main Progran ****
On Error GoTo Recover

FlagOn = FALSE
FlagOff = FALSE
FlagBatch = FALSE
FlagVer = FALSE
TimerID$ = ""

' Help Indents
Const Hi1 = 5
Const Hi2 = 8

'Alt colors
Acb = 1 'Blue
Acf = 7 'White


If _CommandCount = 0 Then
    Print "No command given; try --help"
    ' We do want to pause here
    End
End If
$If SAY Then
    Print "Cmd Count" + Str$(_CommandCount)
$End If

F = FreeFile
GetDateAndTIME
GoSub GetSpecialDirs
For I% = 1 To _CommandCount
    If I% > 10 Then GoTo TooMany
    Cmd$(I%) = Command$(I%)
    UCmd$(I%) = UCase$(Cmd$(I%))
Next

' Process the commands
For K% = 1 To _CommandCount

    $If SAY Then
        say "K%=" + Str$(K%)
    $End If

    D$ = Left$(UCmd$(K%), 1)
    If (D$ >= "0") And (D$ <= "9") Then

        $If SAY Then
            say " @num=" + Cmd$(K%)

        $End If
        If TimerID$ <> "" Then GoTo OnlyOne
        TimerID$ = Cmd$(K%)
        _Continue
    End If
    $If SAY Then
        say " IH CASE #" + Str$(K%) + "UCmd=" + UCmd$(K%)
    $End If

    Select Case UCmd$(K%)
        Case "ON", "START", "BEGIN"

            $If SAY Then
                say " @ON"
            $End If
            FlagOn = TRUE
            If FlagOff Then GoTo ChooseOne
            _Continue
        Case "OFF", "STOP", "END"

            $If SAY Then
                say " @OFF"
            $End If

            FlagOff = TRUE
            If FlagOn Then GoTo ChooseOne
            _Continue
        Case "/H", "-H", "--HELP"

            $If SAY Then
                say " @HELP"
            $End If

            ' Help overrides all other options
            GoTo GiveHelp
        Case "-B", "/B", "--BATCH"
            $If SAY Then
                say " @BATCH"
            $End If

            FlagBatch = TRUE
            _Continue
        Case "-V", "/V", "--VERSION"

            $If SAY Then
                say " @VER"
            $End If

            ' Version overrides all other option
            FlagVer = TRUE
            GoTo GiveHelp
        Case Else

            $If SAY Then
                say " @ELSE"
            $End If

            Print "Command #"; K%; ", '"; Cmd$(K%); "' not understood. Try --help"
            GoTo quit
    End Select
Next

$If SAY Then
    say " in test" + Chr$(13) + Chr$(10)
$End If



If FlagOn Then
    ' Start a timer

    $If SAY Then
        say " @START"
    $End If

    FileName$ = TempDir$ + OurName + TimerID$ + ".tmp"

    On Error GoTo BadName
    Open FileName$ For Output As #F
    On Error GoTo BadWrite
    Print #F, Year, Month, Day, Hour, Minute, Second
    Print #F, DateString

    On Error GoTo Recover

    Print "Timer";
    If TimerID$ <> "" Then Print " ";
    Print TimerID$; " started "; DateString

    Close #F

    GoTo quit
End If

If FlagOff Then
    $If SAY Then
        say " @OFF"
    $End If
    Dim As Integer PrintAND, SYear, SMonth, SDay, SHour, SMinute, SSecond
    ' Tell listener to quit

    FileName$ = TempDir$ + OurName + TimerID$ + ".tmp"

    On Error GoTo BadOpen
    Open FileName$ For Input As #F

    On Error GoTo BadRead
    Input #F, SYear, SMonth, SDay, SHour, SMinute, SSecond
    Line Input #F, OldDateString
    Close #F
    Print
    Print "Timer";
    If TimerID$ <> "" Then Print " ";
    Print TimerID$; " started "; OldDateString
    Print "Timer";
    If TimerID$ <> "" Then Print " ";
    Print TimerID$; " stopped "; DateString

    ' Calculate elapsed time

    If Day < SDay Then
        Day = Day + MonthDays(SMonth)
        Month = Month - 1
    End If
    Day = Day - SDay

    If Hour < SHour Then
        Day = Day - 1
        Hour = Hour + 24
    End If
    Hour = Hour - SHour

    If Minute < SMinute Then
        Hour = Hour - 1
        Minute = Minute + 60
    End If
    Minute = Minute - SMinute

    If Second < SSecond Then
        Minute = Minute - 1
        Second = Second + 60
    End If
    Second = Second - SSecond

    Print "Elapsed Time";
    PrintAND = 0
    If Day > 0 Then
        PrintAND = 1
        Print Day; "day";
        If Day > 1 Then Print "s";
    End If

    If Hour > 0 Then
        PrintAND = 1
        Print Hour; "hour";
        If Hour > 1 Then Print "s";
    End If

    If Minute > 0 Then
        PrintAND = 1
        Print Minute; "minute";
        If Minute > 1 Then Print "s";
    End If
    If PrintAND Then Print " and";
    Print Second; "second";
    If Second > 1 Then Print "s";
    Print "."

    'Clean up after ourselves
    On Error GoTo bounce
    Kill FileName$

    GoTo quit
End If

Print "%Warning: No command was given. No action was taken."

' Fall thru
GoTo quit
GiveHelp:
Print "TDarcos Timer - Version "; Version
' Exit if only wants version number
If FlagVer GoTo quit
Print "Usage:"
Print Tab(Hi1); ProgName$; " [options] on|off [options]"
Print Tab(Hi1); "Where options are:"
Print Tab(Hi2); "any number            Use this as the timer number."
Print Tab(Hi2); "                      If no number is given the default timer is used."
Print Tab(Hi2); "                      These allow you to time multiple events simultaneously."
Print Tab(Hi2); "                      Your results will make no sense if you don't use the"
Print Tab(Hi2); "                      same number (or no number) when turning "
Print Tab(Hi2); "                      the timer on or off."
Print Tab(Hi2); "                      While multiple timers can be active simultaneously,"
Print Tab(Hi2); "                      only one timer at a time can be started or stopped."
Print Tab(Hi2); "--help -h (or) /h     Show this message and quit."
Print Tab(Hi2); "--batch -b (or) /b    Presume this is running in a batch job or from the console."
Print Tab(Hi2); "                      The program will not pause for a keypress. If this switch is"
Print Tab(Hi2); "                      not set, the program will pause after finishing."
Print Tab(Hi2); "--version -v (or) /v  Show the version number, then quit."
Print
Print Tab(Hi1); "And now, the commands:"
Print Tab(Hi2); "on start (or) begin   Start the timer."
Print Tab(Hi2); "off stop (or) end     Stop the timer."
Print Tab(Hi2); "                      If you used a timer number to start, you must use the same"
Print Tab(Hi2); "                      number when stopping."
Print
Print Tab(Hi1); "None of the above is case sensitive."
Print
GoTo quit

' We save ERR in Cerr because ERR is cleared by RESUME
Recover:
Print "?Program failed";
Cerr = Err
Resume ShowError

BadName:
Cerr = Err
Print "?Can't open file "; FileName$;
Resume ShowError

BadWrite:
Cerr = Err
Print "?Can't write current time to temporary file "; FileName$;
Resume ShowError

BadRead:
Cerr = Err
Print "?Can't read start time from temporary file "; FileName$;
Resume ShowError

BadOpen:
Cerr = Err
Print "If you gave your timer an ID, is this the correct one?"
Print "?Can't read start time from temporary file "; FileName$;
Resume ShowError

ShowError:
Print " due to error "; Cerr; " at line "; _ErrorLine; "."
Print "*** Execution terminated."
Close #F
GoTo quit
bounce:
' Error not important
Print "% Warning: Could not delete temporary file "; FileName$
Resume Next
TooMany:
Print "?Too many parameters, try --help"
GoTo quit
ChooseOne:
Print "?Turn timer on or off, not both."
GoTo quit
OnlyOne:
Print "Only 1 timer at a time can be set or retrieved."
GoTo quit

quit:
If FlagBatch Then System

End

'$Include:'directory_environment.bi'
'$Include:'CollectExactTimeBottom.bi'

Sub say (L$)
    cf = _DefaultColor
    cb = _BackgroundColor
    Color Acf, Acb
    Print L$
    Color cf, cb
End Sub
