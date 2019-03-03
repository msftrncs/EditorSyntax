# convert the PowerShell grammar from PLIST to CSON format for use in the Language-PowerShell package for Atom
try {
    # create the output folder if it does not exist
    if (-not (Test-Path 'grammars' -PathType Container)) {
        New-Item 'grammars' -ItemType Directory | Out-Null
    }

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

    # output the Atom CSON grammar
    $grammar_atom | ConvertTo-Cson -depth 100 |
        Set-Content 'grammars\powershell.cson' -Encoding 'UTF8'
}
catch {
    throw # error occured, give it forward to the user
}
