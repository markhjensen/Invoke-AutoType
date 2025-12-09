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

# Escape special char
function Escape-SendKeys {
    param (
        [string]$char
    )
    switch ($char) {
        '{' { return '{{}' }
        '}' { return '{}}' }
        '+' { return '{+}' }
        '%' { return '{%}' }
        '~' { return '{~}' }
        '(' { return '{(}' }
        ')' { return '{)}' }
        '^' { return '{^}' }
        default { return $char }
    }
}

function Sleep-Countdown {

    param (
        [int]$sleepcountdown
    )

    while ($sleepcountdown -gt 0) {
        Write-Host "Typing begins in: $sleepcountdown"
        Start-Sleep -Seconds 1
        $sleepcountdown--
    }
}

# Loop string
function SendKeys {

    if ($type -ne $null) {

        $input = Read-Host "String to type ($type)"
        
        if ($input -ne "") {
            $type = $input
        }

    } else {
        $type = Read-Host "String to type"
    }

    $typelength = $type.Length
    $sleepmschar = 1
    $sleepcountdown = Get-ValidInteger -prompt "Delay before start (Default 5)" -default 5
    Sleep-Countdown -sleepcountdown $sleepcountdown

    Write-Host "hacking"

    foreach ($char in $type.ToCharArray()) {
        Write-Host "$char $typelength"
        # Escape special char
        $escapedChar = Escape-SendKeys -char $char

        # Define problematic dead keys
        $manualKeys = @("{^}")

        # Send char
        if ($manualKeys -contains $escapedChar) {
            $null = Read-Host "Please manually type '^' (Shift+^, then space) in the console, then press Enter to continue..."
            if ($typelength -gt 1) {
                Sleep-Countdown -sleepcountdown $sleepcountdown
            }
        } else {
            [System.Windows.Forms.SendKeys]::SendWait($escapedChar)

            # Sleep 1 ms mellem char
            Start-Sleep -Milliseconds $sleepmschar
        }
        $typelength--
    }

    Sendkeys

}

SendKeys 
