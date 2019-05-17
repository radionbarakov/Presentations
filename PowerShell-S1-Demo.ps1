#Radion Barakov
#15-5-2019
#Demo and Examples for PowerShell Basics

#HELP commands
    Get-Help -Name Add-Computer -Parameter DomainName
    Help *Computer*

    #Get-Commands w/ Module example - try running the command before and after getting the module to see the different resultys
    Install-Module​ azuread
    Get-Command *azure*

    #Get-Member continuing previous example
    Get-Command Connect-AzureAD | Get-Member
    Get-Command Get-ChildItem | gm

#Properties
    #Say you're interested in just the name property and not the rest (feel free to play around with property output)
    (Get-ChildItem C:\Users).name

#Parameters
    #Positional not defined, yet default position at [0]
    Get-ChildItem C:\Users

    #Explicit parameter - A defined and written one, if a positional Parameter is also written in the command it is becoming explicit
    Get-ChildItem -Path C:\Users

#Functions; Personal Connect-Office365.psm1:
    Function Connect-Office365 {

    #Assigning Username and prompting for Password, Change UserName to yours!
    $UserName = 'YOUR UPN HERE'
    $Password = Read-Host -Prompt 'Enter Password' -AsSecureString

    #Create a PSCredentiaObject with Credential Input.
    $Credentials = New-Object -TypeName System.Management.Automation.PSCredential($UserName,$Password)

    #Starting Session with the Exchange Server.
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Credentials  -Authentication Basic -AllowRedirection
    Import-PSSession $Session -DisableNameChecking | Select-Object -Skip 1 
    }

#Parameters example
    Function Connect-Remote{

    #Assign a name and predefine, else will be prompter
    Param(
        [Parameter(Mandatory=$true)]
        $ServerName,
        [Parameter(Mandatory=$true)]
        $UserName,
        [Parameter(Mandatory=$true)]
        [Security.SecureString]
        $Password
        )
        #Object conversion - converted $Password from String to SecureString

    #Creating a new Object example - credential
    $Credentials = New-Object -TypeName System.Management.Automation.PSCredential($UserName,$Password)
    #Using the new Object in a Variable
    $Session = New-PSSession -ComputerName $ServerName -Credential $Credentials 
    }

#Variables
    #Variable holding characters + numeric 
    $21 = "9" + "10"
    $212 = "nine" + "ten"

    #Int (variable holding numeric intiger - converted object like in the example above)
    $42 = [int]"9" + [int]"10"
    $42 | gm

    #Using Method (Action) to convert to capital letters 
    $212 | gm
    $212.ToUpper()

    #Pulling Property (Information) from the converted Object - How long is the sting?
    $42.ToString().Length | gm

    #Variable Fine-graining - Only using the length of the string for specific purposes
    $42Length = $42.ToString().Length

    #Auto Variables examples
    $HOME # user home die
    $PSHome #PowerShell dir

    #Preference Variables examples
    $MaximumAliasCount
    $MaximumHistoryCount

#Aliases 
    Get-Alias
    #cr = 'C'onnect-'R'emote - from the function above
    New-Alias cr Connect-Remote

#Pipeline; Filter | Format    
    #Transfer of 'Name' object and modify view
    Get-Alias | Where-Object {$_.Name -like 'c*'} | Select-Object Name,CommandType | Format-Table -AutoSize
    #Customising the output 'Name' to 'Customized Object Name'
    Get-Alias | Select-Object -Property @{Name = "Customized Object Name"; Expression = {$_.Name}}

#Arrays
    #Creating an Integer array
    [int[]]$ThisArray = 10,20,30,40
    #Selecting the 4th object (Counting starts with 0!)
    $ThisArray[3]

    #Rage operator - setting a range between 1 and 9
    $ThatArray = 1..9
    $ThatArray[8]

    $AnotherArray = 'bread','peanutbutter','hagelslag','banana'

    #Object type - a friendlier looking array of objects
    $ExtraArray = @(
    'this'
    'good'
    'example'
    )

#HashTables
#Simply put -a dictionary | add [ordered] before @{ to make it ordered: $Table = [ordered]@{key=value}
$Hash = [ordered]@{
    Apples = 4
    WaterMelons = 2
    Hotel = 'Trivao'
    love = "baby don't hurt me"
}

    #Creating objects from the key and its value using Hashtables
    $Object = New-Object -TypeName PSObject -Property $Hash
    $Object | gm

#Foreach - pulls all the results at once and then runs the foreach against results - think what can happen if you have hundreds of objects in output, is it efficient?
    #gt= Greater Than, all at once.
    $ProcessName = (Get-Process).Name
    Foreach ($Name in $ProcessName) {

        if ($Name.Length -gt 10) {

        Write-Host "look ma, no '$Name' !" } 
    
    #Remove comments from line below and run the foreach command with it, see results change (don't forget the curly bracket below!)
    #elseif ($Name.Length -gt 11) {

    #Write-Host "look ma, almost!"

    else{

    Write-Host "don't look ma!"
            }
        }
    #}

#Foreach-Object - unlike its counterpart forach (which is also an alias for this command - just to make it extra confusing) it runs the command agains each object one-by-one during the pull
    (Get-Process).name | ForEach-Object {Write-Host "Pa?! $_"}

    #With Scriptblock - running command in blocks, don't confuse with Invoke-Command -ScriptBlock (runs local script against remote environment)
    (Get-Process).name | ForEach-Object -Begin {get-date} -Process {Write-Host "Pa?! $_"} -End {Write-Host "done"}

    #Using with Arrays - multiplying output by 4, you can also perform other kinds of calculations
    $hash | ForEach-Object {$_.count * 4}

#Conditions
    #Stop wupdate example
    Stop-Service -Name wuauserv 
    #hybernate command for 60sec and run it until service status up
    do { 
        Start-Sleep -Seconds 60
        Start-Service wuauserv 

    } until ((Get-Service wuauserv).Status -eq 'Running') 

    #Do-while will run as long as while condition is true

#Profile 
    #check where your PowerShell profile file is located, here you can write functions which will load along with the shell or preload modules, magical place to costumise your PS experience
    $profile

#Repositories
    #psgallery is the defalt rep, which can wait for it.... be changed!
    Get-PSRepository
    Install-Module -Name azure -Repository psgallery

#Hope you all find it useful and if you have any question feel free to contact me on:
#Twitter: https://twitter.com/Radion_Barakov
#Email: radion.barakov@outlook.com
#Website: radionbarakov.com