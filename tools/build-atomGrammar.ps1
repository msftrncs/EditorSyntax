# read in the PList grammar
$grammar_plist = [xml](Get-Content 'PowerShellSyntax.tmLanguage') | ConvertFrom-Plist

# create an empty Atom grammar
$grammar_atom = [ordered]@{}

# move most items from the PList to the Atom grammar, excluding a couple items
foreach ($key in $grammar_plist.keys) {
    if ($key -cnotin 'uuid', 'keyEquivalent') {
        $grammar_atom += [ordered]@{
            $key = $grammar_plist.$key
        }
    }
}

# create the output folder if it does not exist
if (!(Test-Path 'grammars' -PathType Container)) {
    New-Item 'grammars' -ItemType Directory | Out-Null
}

# output the Atom CSON grammar (escaping what appear to be subexpressions)
($grammar_atom | ConvertTo-Json -depth 100 | json2cson ) -replace '(?<!\\)(#\{\()', '\$1' |
    Set-Content 'grammars\powershell.cson'
