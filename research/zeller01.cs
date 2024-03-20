using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project2_DH
{
    class Program
    {
        static void Main(string[] args)
        {
            bool isValid;
            string dayOfWeek;           
            DateTime date = new DateTime();

            Console.WriteLine("Welcome to the Zeller Day/Date Calculator!");
            Console.WriteLine("******************************************\n");

            // This do while loop will prompt the user to enter a date in the proper format. The date will then be validated.
            // If the date is invalid then the user will continue to be prompted to enter a date until it is in the proper format and valid
            do
            { // Start do while
                Console.WriteLine("Please enter a date in the following format:");
                Console.WriteLine("December 7 1941\n");
                string userInputDate = Console.ReadLine();
                try
                {
                    date = Convert.ToDateTime(userInputDate);
                }
                catch (FormatException e)
                {
                    Console.WriteLine("\nThe date you entered is not valid\n\n");
                }

                // isDateValid function call
                isValid = isDateValid(date.Month, date.Day, date.Year);

                // This if will output a message to the user if the date entered was invalid
                if (isValid == false)
                {
                    Console.WriteLine("\nThe date you entered is not valid\n\n");
                }
            } while (isValid == false); // End do while

            // Zeller Calculation function call
            dayOfWeek = zellerCalc(date.Month, date.Day, date.Year);

            // OUtputs to the console the day of the week that the date entered landed on
            Console.WriteLine("\nThe day is " + dayOfWeek + "\n");
        }

        static bool isDateValid(int month, int day, int year)
        {
            bool validation = true;
            int[] daysInMonth = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

            // Checks that a valid month has been entered
            if (month < 1 || month > 12)
            {
                validation = false;
            }

            // This if checks that a valid day was entered for the month entered
            if (day < 1 || day > daysInMonth[month - 1])
            {
                validation = false;
            }

            // This if checks that a valid year was input by the user
            if (year < 1700 || year > 3000)
            {
                validation = false;
            }
            return validation;
        }

        // This function receives month day and year as arguments and calculates the day of week for that date
        static string zellerCalc(int month, int day, int year)
        {
            string dayOfWeek;
            int m = -1; // A variable of type int which holds the numerical value of the month entered by the user
            int h = -1; // A variable of type int which holds the result of Zeller's congruence formula
            int q = day; // A variable of type int which holds the day used in Zeller's congruence formula
            int k; // A variable of type int which holds the year of the century used in Zeller's congruence formula
            int j; // A variable of type int which holds the century used in Zeller's congruence formula

            if (month == 1)
            {
                m = 13;
            }
            else if (month == 2)
            {
                m = 14;
            }
            else
            {
                m = month;
            }

            // Formula to calculate the correct day of the week for the months of January and February
            if (m == 13 || m == 14)
            {
                year--;
            }

            k = year % 100; // Calculates the year of the century
            j = year / 100; // calculates the century

            // Zeller's congruence formula that finds the day of the week for any date
            h = (q + (int)((13 * (m + 1)) / 5.0) + k + (int)(k / 4.0) + (int)(j / 4.0) + (5 * j)) % 7;

            // This if else if determines the day of the week based on the result from Zeller's formula
            if (h == 0)
            {
                dayOfWeek = "Saturday";
            }
            else if (h == 1)
            {
                dayOfWeek = "Sunday";
            }
            else if (h == 2)
            {
                dayOfWeek = "Monday";
            }
            else if (h == 3)
            {
                dayOfWeek = "Tuesday";
            }
            else if (h == 4)
            {
                dayOfWeek = "Wednesday";
            }
            else if (h == 5)
            {
                dayOfWeek = "Thursday";
            }
            else
                dayOfWeek = "Friday";

            return dayOfWeek;
        }
    }
}
