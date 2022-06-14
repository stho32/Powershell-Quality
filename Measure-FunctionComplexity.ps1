Function Measure-FunctionComplexity {
    [CmdletBinding()]
    [OutputType([System.Int32])]
    Param (
        [Parameter(Position=0, Mandatory=$True)]
        [System.Management.Automation.Language.FunctionDefinitionAst]$FunctionDefinition
    )
    # Default complexity value for code which contains no branching statement (1 code path)
    [int]$DefaultComplexity = 1

    $ForPaths = Measure-FunctionForCodePath $FunctionDefinition
    $IfPaths = Measure-FunctionIfCodePath $FunctionDefinition
    $LogicalOpPaths = Measure-FunctionLogicalOpCodePath $FunctionDefinition
    $SwitchPaths = Measure-FunctionSwitchCodePath $FunctionDefinition
    $TrapCatchPaths = Measure-FunctionTrapCatchCodePath $FunctionDefinition
    $WhilePaths = Measure-FunctionWhileCodePath $FunctionDefinition
    [int]$TotalComplexity = $DefaultComplexity + $ForPaths + $IfPaths + $LogicalOpPaths + $SwitchPaths + $TrapCatchPaths + $WhilePaths
    return $TotalComplexity
}
