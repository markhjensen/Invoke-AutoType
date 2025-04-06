$type = Read-Host "String to type"
$sleepmschar = 1

function Get-ValidInteger {
    param (
        [string]$prompt,
        [int]$default
    )
   
    while ($true) {
        $input = Read-Host $prompt
        if (-not $input) {
            return $default
        }
        if ($input -as [int] -ne $null) {
            return [int]$input
        } else {
            Write-Host "Please enter a valid integer."
        }
    }
}

$sleepcountdown = Get-ValidInteger -prompt "Delay before start (Default 5)" -default 5

while ($sleepcountdown -gt 0) {
    Write-Host "Typing begins in: $sleepcountdown"
    Start-Sleep -Seconds 1
    $sleepcountdown--
}
Write-Host "hacking"

# Escape special char
function Escape-SendKeys {
    param (
        [string]$char
    )
    switch ($char) {
        '{' { return '{{}' }
        '}' { return '{}}' }
        '+' { return '{+}' }
        '^' { return '{^}' }
        '%' { return '{%}' }
        '~' { return '{~}' }
        '(' { return '{(}' }
        ')' { return '{)}' }
        default { return $char }
    }
}

# Loop string
foreach ($char in $type.ToCharArray()) {
    # Escape special char
    $escapedChar = Escape-SendKeys -char $char

    # Send char
    [System.Windows.Forms.SendKeys]::SendWait($escapedChar)

    # Sleep 5 ms mellem char
    Start-Sleep -Milliseconds $sleepmschar
}
