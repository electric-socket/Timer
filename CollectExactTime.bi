'        11111111112222222223333333333344444444445555555555666666666677777777778
'2345678901234567890123456789012345678901234567890123456789012345678901234567890
Option _Explicit
Dim Shared DayList(0 To 6) As String
DayList(0) = "Sunday"
DayList(1) = "Monday"
DayList(2) = "Tuesday"
DayList(3) = "Wednesday"
DayList(4) = "Thursday"
DayList(5) = "Friday"
DayList(6) = "Saturday"

Dim Shared MonthList(1 To 12) As String
Dim Shared As Integer Year, Month, Day, Hour, Minute, Second
Dim Shared Year$, Month$, Day$, WeekDay$, Minute$, Second$, AmPm$
Dim Shared As String DateString

MonthList(1) = "January"
MonthList(2) = "February"
MonthList(3) = "March"
MonthList(4) = "April"
MonthList(5) = "May"
MonthList(6) = "June"
MonthList(7) = "July"
MonthList(8) = "August"
MonthList(9) = "September"
MonthList(10) = "October"
MonthList(11) = "November"
MonthList(12) = "December"

GetDateAndTIME
Print DateString$
End

Sub GetDateAndTIME
    Dim Date1$, Date2$, DateA$, TimeA$, Hour$

    ' The following makes the time and date match exactly.
    ' While it is extremely unlikely, the date could change between the time
    ' and the date is collected. So we get the Date first, then the time,
    ' then the date again.
    Date1$ = Date$
    TimeA$ = Time$
    Date2$ = Date$
    Hour$ = Left$(TimeA$, 2): Hour = Val(Hour$)
    Minute$ = Mid$(TimeA$, 4, 2): Minute = Val(Minute$)
    Second$ = Right$(TimeA$, 2): Second = Val(Second$)

    ' Now, all we need is to look at is the hour. If the hour is 0, there is
    ' a small chance the date changed between the first date and we got the time,
    ' which would mean the first date would be wrong, so we use the date
    ' collected after the time. In all ither cases, even at 1 second before
    ' midnight, the date _cannot_ have changed before the time was collected, so
    ' we use the first date.
    If Hour = 0 Then
        DateA$ = Date2$
    Else
        DateA$ = Date1$
    End If


    '    We keep certain variables as shared
    '    Year, Month, Day, Hour, Minute, Second  are the number values
    '    Year$, Month$, Day$, WeekDay$, AmPm$    are the strings for display
    '    Minute$   because time display of 9 minutes after is "09"
    '    Second$   for the same reason

    Year$ = Right$(DateA$, 4)
    Month$ = Left$(DateA$, 2)
    Day$ = Mid$(DateA$, 4, 2)
    Year = Val(Year$)
    Month = Val(Month$):
    Day = Val(Day$)
    WeekDay$ = GetDay$
    If Hour > 12 Then
        Hour = Hour - 12
        AmPm$ = "P.M."
    Else
        AmPm$ = "A.M."
    End If
    Month$ = MonthList(Month)
    ' On this string, if a number should show with leading 0, string value is used
    ' Where the number should show without it, Str$ is used
    DateString = WeekDay$ + ", " + Month$ + Str$(Day) + ", " + Year$ + " at" + Str$(Hour) + ":" + Minute$ + ":" + Second$ + " " + AmPm$
End Sub

Function GetDay$
    Dim As Integer M, Y, C, S1, S2, S3, WkDay
    ' It doesn't specify, but this is probably Zeller's Congruence
    If M < 3 Then M = M + 12: Y = Y - 1
    C = Y \ 100: Y = Y Mod 100
    S1 = (C \ 4) - (2 * C) - 1
    S2 = (5 * Y) \ 4
    S3 = 26 * (M + 1) \ 10
    WkDay = (S1 + S2 + S3 + Day) Mod 7
    If WkDay < 0 Then WkDay = WkDay + 7
    GetDay$ = DayList(WkDay)
End Function
