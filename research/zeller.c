/*
	Zeller.c
	Pseudo:	
		h = (q + (13(m+1) / 5) + K + (K/4) + 5 + 6(J)) % 7
		
    h is the day of the week (0 = Saturday, 1 = Sunday, 2 = Monday, ...)
    q is the day of the month
    m is the month (3 = March, 4 = April, 5 = May, ..., 14 = February)
    K the year of the century (year \mod 100).
    J is the century (actually \lfloor year/100 \rfloor) (For example, in 1995 the century would be 19, even though it was the 20th century.)
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
	const char *day[7] = {"Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"};
	int inMonth, inDay, inYear;
	
	printf("Enter number of month e.g, 1 for January: ");
	scanf("%2d", &inMonth);
	if (inMonth == 1 || inMonth == 2)
	{
		inMonth += 12;
	}
	
	else if (inMonth > 12 || inMonth < 1)
	{
		printf("Month number out of range: 1-12");
		return -1;
	}
	
	printf("Enter day, e.g 10: ");
	scanf("%2d", &inDay);
	printf("Enter the year: ");
	scanf("%4d", &inYear);
	
	int century = inYear / 100;
	int yearOfCentury = inYear % 100;
	
	int d = (inDay + ((13 * (inMonth+1)) / 5) + yearOfCentury + (yearOfCentury / 4) + 5 + (6 * century)) % 7;
	printf("%s", day[d]);
	return 0;
}
