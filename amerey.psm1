#requires -Version 2 -Modules posh-git

function Write-Theme {

    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    $lastColor = $sl.Colors.PromptBackgroundColor

    $prompt = Write-Prompt -Object $sl.PromptSymbols.StartSymbol -ForegroundColor $sl.Colors.SessionInfoForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor

    If ($lastCommandFailed) {
      $prompt += Write-Prompt -Object "$($sl.PromptSymbols.FailedCommandSymbol) " -ForegroundColor $sl.Colors.CommandFailedIconForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
    }

    If (Test-Administrator) {
      $prompt += Write-Prompt -Object "$($sl.PromptSymbols.ElevatedSymbol) " -ForegroundColor $sl.Colors.AdminIconForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
    }

    $timeStamp = Get-Date -UFormat %T
    $timestamp = "[$timeStamp] - "
    $prompt += Write-Prompt $timeStamp -ForegroundColor $sl.Colors.PromptForegroundColor

    $path = (Get-FullPath -dir $pwd)
    $space = " "
    $prompt += Write-Prompt $space $sl.PromptSymbols.StartSymbol -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor  
    $prompt += Write-Prompt -Object $sl.PromptSymbols.FolderSymbol -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor  
    $prompt += Write-Prompt $space $sl.PromptSymbols.StartSymbol -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor  
    $prompt += Write-Prompt -Object $path -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor

    $status = Get-VCSStatus

    if(!$Status)
    {
      $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $sl.Colors.PromptBackgroundColor   
    }
    
    if ($status) {
      $themeInfo = Get-VcsInfo -status ($status)
      $lastColor = $themeInfo.BackgroundColor
      $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $sl.Colors.PromptBackgroundColor -BackgroundColor $lastColor
      $prompt += Write-Prompt -Object " $($themeInfo.VcInfo) " -BackgroundColor $lastColor -ForegroundColor $sl.Colors.GitForegroundColor
      $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $lastColor
    }

    if ($with) {
      $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $lastColor -BackgroundColor $sl.Colors.WithBackgroundColor
      $prompt += Write-Prompt -Object " $($with.ToUpper()) " -BackgroundColor $sl.Colors.WithBackgroundColor -ForegroundColor $sl.Colors.WithForegroundColor
      $lastColor = $sl.Colors.WithBackgroundColor
    }

    $prompt += Set-Newline
    $prompt += Write-Prompt -Object $sl.PromptSymbols.FolderSymbol -ForegroundColor 
    $sl.Colors.PromptSymbolColor
    $prompt += ' '
    $prompt
}

$sl = $global:ThemeSettings 

$sl.PromptSymbols.StartSymbol = ""
$sl.PromptSymbols.SegmentForwardSymbol = [char]::ConvertFromUtf32(0xE0B0)
$sl.PromptSymbols.FolderSymbol = [char]::ConvertFromUtf32(0x2692) 

$sl.Colors.SessionInfoBackgroundColor = [ConsoleColor]::Black
$sl.Colors.PromptHighlightColor = [ConsoleColor]::DarkBlue
$sl.Colors.PromptForegroundColor = [ConsoleColor]::LightRed
$sl.Colors.GitForegroundColor = [ConsoleColor]::Black
$sl.Colors.GitLocalChangesColor = [ConsoleColor]::DarkYellow

$sl.Colors.PromptSymbolColor = [ConsoleColor]::Red
$sl.Colors.WithForegroundColor = [ConsoleColor]::Yellow
$sl.Colors.WithBackgroundColor = [ConsoleColor]::DarkRed
$sl.Colors.VirtualEnvBackgroundColor = [System.ConsoleColor]::Red
$sl.Colors.VirtualEnvForegroundColor = [System.ConsoleColor]::Yellow


