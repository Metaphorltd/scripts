iex (iwr https://raw.githubusercontent.com/metaphorltd/scripts/main/utils.ps1).Content
function Invoke-Tailwind {
    param (
        [Parameter(Mandatory)][string]$outputFile
    )
    tailwindcss -i tailwind.css -o $outputFile --minify
}