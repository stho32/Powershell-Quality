Function Measure-FunctionMaxNestingDepth {

    [CmdletBinding()]
    [OutputType([Int32])]
    Param (
        [Parameter(Position=0, Mandatory)]
        [System.Management.Automation.Language.FunctionDefinitionAst]$FunctionDefinition
    )
    $FunctionText = $FunctionDefinition.Extent.Text
    $Tokens = $Null
    $Null = [System.Management.Automation.Language.Parser]::ParseInput($FunctionText, [ref]$Tokens, [ref]$Null)

    [System.Collections.ArrayList]$NestingDepthValues = @()
    [Int32]$NestingDepth = 0
    [System.Collections.ArrayList]$CurlyBrackets = $Tokens | Where-Object { $_.Kind -in 'AtCurly','LCurly','RCurly' }

    # Removing the first opening curly and the last closing curly because they belong to the function itself
    $CurlyBrackets.RemoveAt(0)
    $CurlyBrackets.RemoveAt(($CurlyBrackets.Count - 1))
    If ( -not $CurlyBrackets ) {
        return $NestingDepth
    }
    Foreach ( $CurlyBracket in $CurlyBrackets ) {

        If ( $CurlyBracket.Kind -in 'AtCurly','LCurly' ) {
            $NestingDepth++
        }
        ElseIf ( $CurlyBracket.Kind -eq 'RCurly' ) {
            $NestingDepth--
        }
        $NestingDepthValues += $NestingDepth
    }
    Write-Verbose "Number of nesting depth values : $($NestingDepthValues.Count)"
    $MaxDepthValue = ($NestingDepthValues | Measure-Object -Maximum).Maximum -as [Int32]
    return $MaxDepthValue
}
