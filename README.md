# Timer
I wanted to time an event in a batch file, come back to it later, and see how long the activity took. Using the command  
`TIME <NUL >>RESULT.TXT `  
before and after was doable, but clumsy. It also doesn't show elapsed time, I have to figure it. So I decided I needed a timer program, 
and it shouldn't be too hard to do (famous last words). By the time I got finished, it had takem two days. (Maybe I should have seen if 
there already is one. Then again, if everyone does that, nothing new would be created.) But anyway, here it is.  

## Usage
There are two ways to use this program:  
1. To build from source, you need to already have installed, or download and install a copy, of QB64 Phoenix Edition, available from
the [QB64 Phoenix Edition repository](https://github.com/QB64-Phoenix-Edition/QB64pe)  
Having installed QB64pe, just load timer.bas in the QB64pe IDE, click on `Run`, `Change Command$`, type `on` in the box and click on `Ok`. 
Next  click on `Run`, `Start` and it will compile and run the program, which will create a time event. To tell Timer the event is completed, in the QB64pe IDE, click on `Run`, 
`Change Command$`, type `off` in the box and click on `Ok`. Nex  click on  `Run`, `Start` and it will show starting time, ending time, and elapsed time.
2. Use the precompiled binary. Checksums are listed below.  

In either case, you will now have timer.exe, which you can use the same way from the DOS command line, by typing `timer on` to start a timer, 
and `timer off`. Or, you can have multiple timers, just give them an identifier starting with a number, like `timer 6 on` or `timer on 6`. If you 
use a timer number, you have to remember that identifier, e.g. the event started by `timer start 5` or `timer on 6`, each has to be stopped 
with `timer off 5` or `timer stop 6`. If you're not sure, you can type `timer --list` and all pending timers will be listed. This can be used in a batch file,
by   
1. Placing `timer on /b` in the batch file before some activity you want to time
2. put in the commands to be executed
3. place `timer off /b` after all of them. It will report start and stop times and elapsed time between them.
You could set up a couple of desktop shortcuts, one running a `timer on` and the other running a `timer off`.
## Features
The program takes advantage of a QB64 feature, when a program reaches an END statement it keeps the program window open until a requested keypress 
is made. This wait can be dispensed with by using `/b`, `-b` or `--batch`. And you can always get the list of commands and options with the `--help` option. 
### Version 1.1
A number of bug fixes, mostly cosmetic, added some exampls, and stopped the creation of a second console window when run from the command line.

MD5 hash of timer.exe:  
866cd0d04e173409d6ab37b481ba049c
The SHA256 checksum for timer.exe is  
eda3011045d9db12345c5246838bac0bbdb3be0081e0d64243d513eeb26312e4
The SHA512 checksum for timer.exe is  
799d147f881e7f74ba4305f71b64328eca5acafb7ae2388f45b4ff414c658a14ced12c53cdef15a30861cc21fce1b6a1e72a7031221686f1babc794b1aecc9f8

# Non-Windows users
While the program was written for windows, conceivably it could be used on Linux or MacOS. The only Windows-specific code is used to retrieve certain file information, and has been marked with `$IF WINDOWS THEN`. Linux and Mac have a simpler, standard method of their own for the information I need.





`
