# read in the PList grammar
$grammar_plist = [xml](Get-Content 'PowerShellSyntax.tmLanguage') | ConvertFrom-Plist

# create the atom grammar heading, including the commit version
$grammar_atom = [ordered]@{}

# move select items from the PList to the JSON grammar in a specific order, if they exist in the PList
foreach($key in $grammar_plist.keys) {
    if ($key -cnotin 'uuid', 'keyEquivalent') {
        $grammar_atom += [ordered]@{
            $key = $grammar_plist.$key
        }
    }
}

# create the output folder if it does not exist
if (!(Test-Path 'grammars' -PathType Container)) {
    New-Item 'grammars' -ItemType Directory
}

# output the final JSON grammar (changing the leading double spaces to tabs)
# Note: on PS <= 5.1, ConvertTo-JSON uses 4 spaces or alignment with the parent property,
#       PS >= 6.0 uses 2, so the `-replace` only works correctly with PS >= 6.0
($grammar_atom | ConvertTo-Json -depth 100 | json2cson ) -replace "(?<!\\)(#\{\()", "\`$1" |
    Set-Content 'grammars\powershell.cson'
