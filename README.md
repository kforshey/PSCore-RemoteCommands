# PSCoreSSHCommands
PSCoreSSHCommands is a Powershell Core CmdLet that allows you to run commands on any computer over ssh without having to go through the pain of using Remoting.
To use the cmdlet to issue a command on a windows box use the following call to E$xecuteRemoteCommand as a guide:
ExecuteRemoteCommand -UserName 'test' -Password 'testpw' -HostName 'host' -CommandText 'ipconfig' -RunOnWindows $true
To use the Cmdlet to make a call on a non Windows machine, make sure it is set up with passwordless SSH Authentication and use this call as a guide:
(Untested), to use parameters, use a call like the following:
ExecuteRemoteCommand -UserName 'test' -Password 'testpw' -HostName 'windowstest' -CommandText 'ip addr' -RunOnWindows $true -Arguments (a, b, c, d)

The argument names should be pretty self explanatory, but for explanation, the -RunOnWindows argument tells the cmdlet if the remote machine is running on Windows or non Windows and which branch of code to follow.
To use the module, each time you open up a new Poewershell Core window, you need to run Import-Module pathto\PSCore-RemoteCommands.psm1.  I have in the past put this line of code in my $PROFILE file, but that's the way we have to do it until I get this in the official powershell gallery.

Compatability -- This module works in Powershell Core (Tested on both windows and Linux(Fedora)) using version 7.0.3.  It works in Powershell 5 when making calls to remote Windows hosts, but not Linux.
