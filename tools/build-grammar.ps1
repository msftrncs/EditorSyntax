# read in the PList grammar
$grammar_plist = [xml](Get-Content 'PowerShellSyntax.tmLanguage') | ConvertFrom-Plist

# create the JSON grammar heading, including the commit version
$grammar_json = [ordered]@{
    information_for_contributors =
    'This file has been converted from source and may not be in line with the official build.',
    'The current master branch for this syntax can be found here: https://github.com/PowerShell/EditorSyntax',
    'If you want to provide a fix or improvement, please create a pull request against the original repository.'
    version                      = git rev-parse HEAD
}

# move select items from the PList to the JSON grammar in a specific order, if they exist in the PList
foreach ($key in 'name', 'scopeName', 'comment', 'injections', 'patterns', 'repository') {
    if ($grammar_plist.$key) {
        $grammar_json += [ordered]@{
            $key = $grammar_plist.$key
        }
    }
}

# create the output folder if it does not exist
if (!(Test-Path 'grammars' -PathType Container)) {
    New-Item 'grammars' -ItemType Directory | Out-Null
}

# output the final JSON grammar (changing the leading double spaces to tabs)
# Note: on PS <= 5.1, ConvertTo-JSON uses 4 spaces or alignment with the parent property,
#       PS >= 6.0 uses 2, so the `-replace` only works correctly with PS >= 6.0
($grammar_json | ConvertTo-Json -depth 100) -replace "(?m)  (?<=^(?:  )*)", "`t" |
    Set-Content 'grammars\powershell.tmLanguage.json' -Encoding 'UTF8'
