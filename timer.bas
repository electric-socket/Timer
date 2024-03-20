'$console:Only
' 1 only if debugging
$Let SAY = 0
'  Timer - a program to provide a stopwatch, for timing events
'  by Paul Robinson
'
'
'

Option _Explicit
'$Include:'CollectExactTimeTop.bi'

Const FALSE = 0
Const TRUE = -1
Const Version = "V1.0"
Const OurName = "TdarcosTimer"

' Command line processing
Dim Cmd$(10), UCmd$(10)
' File name construction
Dim TimerID$, FileName$, D$
' Loop counters
Dim I%, K%
'Action flags
Dim As Integer FlagOn, FlagOff, FlagBatch, FlagVer, FlagAbort, FlagList

Dim As Integer F, Cerr, Result, ConflictCount
' date and time values
Dim Shared As Integer Year, Month, Day, Hour, Minute, Second
Dim Shared Year$, Month$, Day$, WeekDay$, Minute$, Second$, AmPm$
Dim Shared As String DateString, OldDateString
' Special directories
$If WINDOWS Then
    Dim Shared WinDir$, SysDir$
$End If
Dim Shared CurDir$, ProgName$, TempDir$

Dim Shared As Integer Acted
$If SAY Then
    Dim Shared As Integer cf, cb, Acf, Acb
$End If
Dim As String ConflictString

'' **** Main Progran ****
On Error GoTo Recover

FlagOn = FALSE
FlagOff = FALSE
FlagBatch = FALSE
FlagVer = FALSE
FlagAbort = FALSE

Acted = 0

ConflictCount = 0
Const ConflictOn = 1
Const ConflictOff = 2
Const ConflictAbort = 4


TimerID$ = ""
ConflictString = ""


' Help Indents
Const Hi1 = 5
Const Hi2 = 8

$If SAY Then
    'Alt colors
    Acb = 1 'Blue
    Acf = 7 'White
$End If

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
            say " @num=" + Cmd$(K%) + " "

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
                say " @ON "
            $End If
            FlagOn = TRUE
            ' check for errors
            If FlagAbort Then ConflictCount = ConflictCount Or ConflictAbort

            If FlagOff Then ConflictCount = ConflictCount Or ConflictOff
            _Continue
        Case "OFF", "STOP", "END"

            $If SAY Then
                say " @OFF "
            $End If

            FlagOff = TRUE
            If FlagAbort Then ConflictCount = ConflictCount Or ConflictAbort

            If FlagOn Then ConflictCount = ConflictCount Or ConflictOn
            _Continue
        Case "/H", "-H", "-?", "/?", "--HELP"

            $If SAY Then
                say " @HELP "
            $End If

            ' Help overrides all other options
            GoTo GiveHelp

        Case "-B", "/B", "--BATCH"
            $If SAY Then
                say " @BATCH "
            $End If

            FlagBatch = TRUE
            _Continue
        Case "-V", "/V", "--VERSION"

            $If SAY Then
                say " @VER "
            $End If

            ' Version overrides all other option
            FlagVer = TRUE
            GoTo GiveHelp

            ' List events
        Case "-S", "-L", "/S", "/L", "--SHOW", "--LIST"
            $If SAY Then
                say " @LIST "
            $End If

            FlagList = TRUE
            _Continue

            ' Cancel event
        Case "-A", "/A", "/D", "-D", "/C", "-C", "--ABORT", "--CANCEL", "--DELETE"
            $If SAY Then
                say " @ABORT "
            $End If

            FlagAbort = TRUE

            If FlagOff Then ConflictCount = ConflictCount Or ConflictOff
            If FlagOn Then ConflictCount = ConflictCount Or ConflictOn

            _Continue

            ' Unknown
        Case Else

            $If SAY Then
                say " @ELSE"
            $End If

            Print "Command #"; K%; ", '"; Cmd$(K%); "' not understood. Try --help"
            _Continue
    End Select
Next

$If SAY Then
    say " in test"
    say " FlagList =" + Str$(FlagList)
$End If

' check for conflicting op7tions
Dim ConflictMessage As String, CMsg(4) As String, CCOUNT As Integer
If ConflictCount > 0 Then
    ConflictMessage = "?Cannot "

    If FlagOff Then CCOUNT = CCOUNT + 1: CMsg(CCOUNT) = "stop"
    If FlagAbort Then CCOUNT = CCOUNT + 1: CMsg(CCOUNT) = "cancel"
    If FlagOn Then CCOUNT = CCOUNT + 1: CMsg(CCOUNT) = "start"
    ConflictMessage = CMsg(1)
    Select Case CCOUNT
        Case 2: ConflictMessage = ConflictMessage + " and " + CMsg(2)
        Case 3: ConflictMessage = ConflictMessage + ", " + CMsg(2) + " and " + CMsg(3)

    End Select
    Print ConflictMessage; " a timer at the same time."
    GoTo quit
End If

' start event
If FlagOn Then
    Acted = TRUE
    ' Start a timer

    $If SAY Then
        say " @START"
    $End If

    FileName$ = TempDir$ + OurName + TimerID$ + ".tmp"

    On Error GoTo BadName
    Open FileName$ For Output As #F
    On Error GoTo BadWrite
    Print #F, DateString
    Print #F, Year, Month, Day, Hour, Minute, Second


    On Error GoTo Recover

    Print "Timer";
    If TimerID$ <> "" Then Print " ";
    Print TimerID$; " started "; DateString

    Close #F

End If

'  End event
If FlagOff Then
    Acted = TRUE
    $If SAY Then
        say " @OFF"
    $End If
    Dim As Integer SYear, SMonth, SDay, SHour, SMinute, SSecond
    ' Tell listener to quit

    FileName$ = TempDir$ + OurName + TimerID$ + ".tmp"

    On Error GoTo BadOpen
    Open FileName$ For Input As #F

    On Error GoTo BadRead
    Line Input #F, OldDateString
    Input #F, SYear, SMonth, SDay, SHour, SMinute, SSecond

    Close #F
    Print
    Print "Timer";
    If TimerID$ <> "" Then Print " ";
    Print TimerID$; " started "; OldDateString
    Print "Timer";
    If TimerID$ <> "" Then Print " ";
    Print TimerID$; " stopped "; DateString

    ' Calculate elapsed time
    Dim Daycount As Integer
    Daycount = 0

    ' Compute # days between them
    If Month <= 2 Then
        Month = Month + 12
        Year = Year - 1
    End If
    Day = (146097 * Year) / 400 + (153 * Month + 8) / 5 + Day

    If SMonth <= 2 Then
        SMonth = SMonth + 12
        SYear = SYear - 1
    End If
    SDay = (146097 * SYear) / 400 + (153 * SMonth + 8) / 5 + SDay

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

    Dim As Integer PrintAND
    Print "Elapsed Time";
    ' Only print AND before second{s) if there is another item
    PrintAND = 0

    'If Month > 0 Then
    '    PrintAND = 1
    '    Print Month; "month";
    '    If Day > 1 Then Print "s";
    'End If

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
    ' Erase this event
    Kill FileName$
    endOff:
End If

' cancel event
If FlagAbort Then
    Acted = TRUE
    FileName$ = TempDir$ + OurName + TimerID$ + ".tmp"
    On Error GoTo badchoice
    Kill FileName$
    On Error GoTo Recover
    Print "Timer";
    If TimerID$ <> "" Then Print " ";
    Print TimerID$; " successfully deleted."
    GoTo EndAbort
End If
EndAbort:

$If SAY Then
    say "Before list"
$End If

' List events
If FlagList Then
    ' If they have acted a message was printed earlier
    If Acted Then Print
    Acted = TRUE
    Dim As Integer ListLen, ListSpace, Push
    Dim As String ListValue, Event
    FileName$ = TempDir$ + OurName + "*.tmp"
    Dim Item$, chop1, chop2
    chop1 = Len(OurName) + 1
    Event = _Files$(FileName$)
    If Event = "" Then GoSub noEvents: GoTo ListEnd

    Print "       Timer List"
    Print "     ID        Event Started"
    Print " __________    _____________"

    While Event <> ""
        Push = 0
        chop2 = InStr(Event, ".")
        ListLen = chop2 - chop1
        Item$ = Mid$(Event, chop1, ListLen)
        If Len(Item$) > 9 Then Push = TRUE

        If Item$ = "" Then Item$ = "(None)"
        FileName$ = TempDir$ + Event
        On Error GoTo ListSkip

        Open FileName$ For Input As #F
        On Error GoTo ListPass
        Line Input #F, ListValue
        On Error GoTo ListSkip
        ListSpace = 10 - Len(Item$)
        Print " ";
        If Push Then
            Print " "; Item$
            Print Space$(12);
        Else
            Print Space$(ListSpace); Item$; " ";
        End If
        Print ListValue

        ListClose:
        Close #F
        listnext:
        Event = _Files$
    Wend
    Print

End If
ListEnd:
$If SAY Then
    say "After list"
$End If
If Acted Then GoTo quit

Print "%Warning: No command was given. No action was taken."

' Fall thru
GoTo quit

' Used to ignore I/O errors
ListSkip:
Resume listnext

ListPass:
Resume ListClose

badchoice:
Print "?No such timer '"; TimerID$; "' exists."
Resume EndAbort

noEvents:
Print "No timer events are scheduled."
Return

GiveHelp:
Print "TDarcos Timer - Version "; Version

' Exit if only wants version number
If FlagVer GoTo quit

Print "Usage:"
Print Tab(Hi1); ProgName$; " [options] on|off [options]"
Print Tab(Hi1); "Where options are:"
Print Tab(Hi2); "any number            Use this as the timer number."
Print Tab(Hi2); "                      If no number is given the default timer is used. These"
Print Tab(Hi2); "                      allow you to time multiple events simultaneously. Your"
Print Tab(Hi2); "                      results will make no sense if you don't use the same"
Print Tab(Hi2); "                      number (or no number) when turning the timer on or off. "
Print Tab(Hi2); "                      While multiple timers can be active simultaneously, only"
Print Tab(Hi2); "                      one timer at a time can be started or stopped."
Print Tab(Hi2); "--help -h -?          Show this message and quit."
Print Tab(Hi2); "--batch -b            Presume this is running in a batch job or from the console."
Print Tab(Hi2); "                      The program will not pause for a keypress. If this switch is"
Print Tab(Hi2); "                      not set, the program will pause after finishing."
Print Tab(Hi2); "--version -v          Show the version number, then quit."
Print Tab(Hi2); "--list -l             Show list of pending events."
Print
Print Tab(Hi1); "And now, the commands:"
Print Tab(Hi2); "on start (or) begin   Start the timer."
Print Tab(Hi2); "off stop (or) end     Stop the timer."
Print Tab(Hi2); "abort (or) cancel     Cancel a timer."
Print Tab(Hi2); "                      If you used a timer ID to start, you must use the same"
Print Tab(Hi2); "                      number when stopping or canceling."
Print
Print Tab(Hi1); "None of the above is case sensitive."
Print Tab(Hi1); "Single character options may be preceded by / or - :"
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
Print "?No such timer ";
Print "'"; TimerID$; "' exists."
Print "If you gave your timer an ID, is this the correct one? "
Print "try using option --list "

Resume endOff

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

OnlyOne:
Print "Only 1 timer at a time can be set or retrieved."
GoTo quit

quit:
' If they want to exit without a pause, /B triggers this
If FlagBatch Then System

End

'$Include:'directory_environment.bi'
'$Include:'CollectExactTimeBottom.bi'

$If SAY Then
    ' Used for debugging
    Sub say (L$)
    cf = _DefaultColor
    cb = _BackgroundColor
    Color Acf, Acb
    Print L$;
    Color cf, cb
    End Sub
$End If


