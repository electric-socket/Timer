Dim UserDate As String
Dim Day As Integer
Dim Month As Long
Dim Year As Long
Dim NewYear As String
Dim DMY As Integer
Dim Century As Integer
Dim Weekday As String
Dim TxtDay(7) As String
Dim TxtMonth(12) As String
Dim Suffix As String

Data Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday
Data January,February,March,April,May,June,July
Data August,September,October,November,December

For Count = 0 To 6
    Read TxtDay(Count)
Next Count
For Count = 0 To 11
    Read TxtMonth(Count)
Next Count

Do
    Cls
    Locate 10, 28
    Print "Please type the date"
    Locate 12, 20
    Print "This must be in the format DD MM YYYY"
    Locate 15, 33
    Line Input ; UserDate$
    If Len(UserDate$) = 0 Then End
Loop Until Len(UserDate$) = 10

'*** Split out the day, month and year ***
Day = Val(Left$(UserDate$, 2))
Month = Val(Mid$(UserDate$, 4, 2))
Year = Val(Right$(UserDate$, 4))

'*** start the print out

Suffix$ = "th"
If Day Mod 10 = 1 Then Suffix$ = "st"
If Day Mod 10 = 2 Then Suffix$ = "nd"
If Day Mod 10 = 3 Then Suffix$ = "rd"
If Day > 10 And Day < 14 Then Suffix = "th"

Locate 18, 21
Print RTrim$(Str$(Day)); LTrim$(Suffix$); " of "; TxtMonth$(Month - 1); Year; "is a ";

'*** For any date in Jan or Feb add 12 to the month and
'*** subtract 1 from the year

If Month < 3 Then
    Month = Month + 12
    Year = Year - 1
End If

'*** Add 1 to the month and multiply by 2.61
'*** Drop the fraction (not round) afterwards

Month = Month + 1
Month = Fix(Month * 2.61)

'*** Add Day, Month and the last two digits of the year

NewYear$ = LTrim$(Str$(Year))
Year = Val(Right$(NewYear$, 2))
DMY = Day + Month + Year
Century = Val(Left$(NewYear$, 2))

'*** Add a quarter of the last two digits of the year
'*** (truncated not rounded)

Year = Fix(Year / 4)
DMY = DMY + Year

'*** Add the following factors for the year

If Century = 18 Then Century = 2
If Century = 19 Then Century = 0
If Century = 20 Then Century = 6
If Century = 21 Then Century = 4
DMY = DMY + Century

'*** The day of the week is the modulus of DMY divided by 7

DMY = DMY Mod 7
Print TxtDay(DMY)

End

