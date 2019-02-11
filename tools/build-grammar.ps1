$grammar_plist = [xml](get-content "PowerShellSyntax.tmLanguage") |
    .\plist` reader
$grammar_json = [ordered]@{
    information_for_contributors =
    'This file has been converted from source and may not be in line with the official build.',
    'The current master branch for this syntax can be found here: https://github.com/PowerShell/EditorSyntax',
    'If you want to provide a fix or improvement, please create a pull request against the original repository.'
    version                      = git rev-parse HEAD
}

foreach ($key in ('name', 'scopeName', 'comment', 'injections', 'patterns', 'repository')) {
    if ($grammar_plist.$key) {$grammar_json += [ordered]@{ $key = $grammar_plist.$key}
    }
}

$grammar_json | convertto-json -depth 100 |
    foreach-object {$_ -replace "(?m)  (?<=^(?:  )*)", "`t" } |
    set-content "grammars\powershell.tmLanguage.json"