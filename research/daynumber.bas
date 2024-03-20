DefLng A-Z
'There is a very handy formula which, when memorized, will allow you to compute the day of the week on which a date falls in your head. The formula for the 2000's is as follows:

'    Take the last two digits of the year, divide by four, disregard the remainder. Add the quotient thus determined to the last two digits of the year.
'    Add a number for the month based on the following: January 1, February 4, March 4, April 0, May 2, June 5, July 0, August 3, September 6, October 1, November 4, December 6, except in a leap year, it is 0 for January and 3 for February.
'    Add the number of the month.
'    Add 6.
'    Divide the result by seven. The remainder indicates the day of the week. For example, if the remainder is 3, the date falls on the third day of the week, or Tuesday. If the remainder is 0, the date falls on the seventh day of the week, or Saturday.

'For example, determine the day of the week on which September 30, 2017, falls. 17 divided by 4 equals 4, disregarding the remainder. Adding 17 and 4 equals 21. Add 6 for September gives us 27. Adding 30 for the day gives us 57. Adding 6 gives us 63. 63 divided by 7 is 9 with a remainder of zero. Since the remainder is zero, September 30, 2017, falls on the seventh day of the week, or Saturday, which is true.
' Input "old m,d,y"; smonth, sday, syear
Do
    Input "new m,d,y"; month, day, year
    If month = 0 Then End

    '    If Month <= 2, then subtract 1 from Year ( if mm <=2 then Year = Year - 1 else Year = Year)
    '    If Month <= 2, then add 13 to month or add 1 to month ( if mm <=2 then mm = mm+13 else mm = mm+1)

    If month <= 2 Then
        year = year - 1
        month = month + 12
    End If
    '    NumDays = (1461 * year) Mod 4 + (153 * month) Mod 5 + day
    NumDays = (146097 * year) / 400 + (153 * month + 8) / 5 + day
    Print NumDays
Loop


