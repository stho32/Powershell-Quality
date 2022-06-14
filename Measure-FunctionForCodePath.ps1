Function Measure-FunctionForCodePath {

    [CmdletBinding()]
    [OutputType([System.Int32])]
    Param (
        [Parameter(Position=0, Mandatory=$True)]
        [System.Management.Automation.Language.FunctionDefinitionAst]$FunctionDefinition
    )
    
    $FunctionText = $FunctionDefinition.Extent.Text
    # Converting the function definition to a generic ScriptBlockAst because the FindAll method of FunctionDefinitionAst object work strangely
    $FunctionAst = [System.Management.Automation.Language.Parser]::ParseInput($FunctionText, [ref]$null, [ref]$null)
    $ForStatements = $FunctionAst.FindAll({ $args[0] -is [System.Management.Automation.Language.ForStatementAst] }, $True)

    # Taking into account the rare cases where For statements don't contain a condition
    $ConditionalForStatements = $ForStatements | Where-Object Condition
    If ( -not($ConditionalForStatements) ) {
        return [int]0
    }
    return $ConditionalForStatements.Count
}
