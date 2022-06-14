Function Measure-FunctionIfCodePath {

    [CmdletBinding()]
    [OutputType([System.Int32])]
    Param (
        [Parameter(Position=0, Mandatory)]
        [System.Management.Automation.Language.FunctionDefinitionAst]$FunctionDefinition
    )
    
    $FunctionText = $FunctionDefinition.Extent.Text
    # Converting the function definition to a generic ScriptBlockAst because the FindAll method of FunctionDefinitionAst object work strangely
    $FunctionAst = [System.Management.Automation.Language.Parser]::ParseInput($FunctionText, [ref]$null, [ref]$null)
    $IfStatements = $FunctionAst.FindAll({ $args[0] -is [System.Management.Automation.Language.IfStatementAst] }, $True)

    If ( -not($IfStatements) ) {
        return [int]0
    }
    # If and ElseIf clauses are creating an additional path, not Else clauses
    return $IfStatements.Clauses.Count
}
