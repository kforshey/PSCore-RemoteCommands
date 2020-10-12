function  createCredentials {

    param(
        [Parameter(Mandatory)]
        [string]
        [Alias("Uname")]
        $credusername,

        [Parameter(Mandatory)]
        [string]
        [Alias("pwd")]
        $credpassword
    )
    $pwd = ConvertTo-SecureString -Force -AsPlainText -String $credpassword;
    $credential = New-Object -TypeName System.Management.Automation.PSCredential($credusername, $pwd );
    return $credential;
}

function  CreateSession {
    param (
        [Parameter(Mandatory)]
        [string]
        [Alias("SessionUser")]
        $SUser,

        [Parameter(Mandatory)]
        [String]
        [Alias("SessionPassword")]
        $SPassword,

        [Parameter(Mandatory)]
        [string]
        [Alias("Sessionhost")]
        $SHost
    )
    $securepwd = ConvertTo-SecureString -Force -AsPlainText -String $SPassword;
    $creds = New-Object -TypeName System.Management.Automation.PSCredential($SUser, $securepwd)
    
    $session = New-PSSession -ComputerName $SHost -Credential $creds;
    return $session;
}

function ExecuteRemoteCommand() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        [Alias("UserName")]
        $Uname,

        [Parameter(Mandatory)]
            [string]
            [Alias("Password")]
            $userpassword,
        
            [Parameter(Mandatory)]
            [string]
            [Alias("HostName")]
            $computer,

            [Parameter(Mandatory)]
            [string]
            [Alias("CommandText")]
            $script,

            [Parameter(Mandatory)]
            [bool]
            [Alias("RunOnWindows")]
            $iswindowshost,

            [Parameter()]
            [string[]]
            [Alias("Arguments")]
            $parms
    )
        $commandscript = [scriptblock]::Create($script);
        
            
        
        if ($iswindowshost)
        {
            "Windows";

            try {
                $session = CreateSession -SessionUser $UName -SessionPassword $userpassword -Sessionhost $computer;
            }
            catch {
                "Cant create session, running in SSH";
            }
            
            if ($null -eq $parms)
            {
               # $session = New-PSSession -HostName $Uname@$computer
                if ($null -ne $session)
                {
                    "session created"
                    $results = Invoke-Command -Session $session -ScriptBlock $commandscript;
                    return $results;
                }
                else {
                    return "Unable to create the connection to run the command.  ;-(";
                }
            
            }
            else {
                $results = Invoke-Command -Session $session -ArgumentList $parms -ScriptBlock $commandscript;
            }
        }       
        ###  we're running in Linux or some other non-windows OS
        ###  so we're going to do SSH Remoting.
        else {
            $session = New-PSSession -hostname "$Uname@$computer"
            if ($null -ne $session)
            {
            $results = Invoke-Command -Session $session -ScriptBlock $commandscript;
            return $results;
            }
            else {
                return "Unable to establish a connection to run the command remotely. ;-("
            }
        }
}