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
Next  click on `Run`, `Start` and it will create a time event. To tell Timer the event is completed, in the QB64pe IDE, click on `Run`, 
`Change Command$`, type `off` in the box and click on `Ok`. Nex  click on  `Run`, `Start` and it will show starting time, ending time, and elapsed time.
2. Use the precompiled binary. Checksums are listed below.  

In either case, you will now have timer.exe, which you can use the same way from the DOS command line, by typing `timer on` to start a timer, 
and `timer off`. Or, you can have multiple timers, just give them an identifier starting with a number, like `timer 6 on` or `timer on 6`. If you 
use a timer number, you have to remember that identifier, e.g. the event started by `timer start 5` or `timer on 6`, each has to be stopped 
with `timer off 5` or `timer stop 6`.

You could set up a couple of desktop shortcuts, one running a `timer on` and the other running a `timer off`. 
##Features
The program takes advantage of a QB64 feature, when a program reaches an END statement it keeps the program window open until a requested keypress 
is made. This wait can be dispensed with by using '/b', '-b` or `--batch`. And you can always get the list of commands and options with the --help option. 

MD5 hash of timer.exe:  
e9490b9c5f2b584cc0dcc5d2ed11f84f  
The SHA256 checksum for timer.exe is  
dac83ab3eb48daeef594e604be9363554a0835be74d846d7a2f828118059a9ec  
The SHA512 checksum for timer.exe is  
953bba6c0bfccc2eb4b92a5e01927ef5b3675c1bc86c76d329209ee78659de3f3a18a31b6ee4c8aea00708d8418158272732b7088a82bb9419f6749805f5870c  

Current Version is 1.0.7
# Non-Windows users
While the program was written for windows, conceivably it could be used on Linux or MacOS. The only Windows-specific code is used to retrieve certain file information, and has been marked with `$IF WINDOWS THEN`. Linux and Mac have a simpler, standard method of their own for the information I need.





`
