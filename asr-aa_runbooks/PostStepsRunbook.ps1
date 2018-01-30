<# 
	This PowerShell script was automatically converted to PowerShell Workflow so it can be run as a runbook.
	Specific changes that have been made are marked with a comment starting with “Converter:”
#>

    workflow PostStepsRunbook {
	
	# Converter: Wrapping initial script in an InlineScript activity, and passing any parameters for use within the InlineScript
	# Converter: If you want this InlineScript to execute on another host rather than the Automation worker, simply add some combination of -PSComputerName, -PSCredential, -PSConnectionURI, or other workflow common parameters (http://technet.microsoft.com/en-us/library/jj129719.aspx) as parameters of the InlineScript
	inlineScript {
		$VMName = 'fapp1-test'
    		$Script = 'testEnvPostSteps.ps1'
    		$URI = 'https://raw.githubusercontent.com/airkine/abiPostMigration/master/testEnvPostSteps.ps1'
    		$RG = 'asr' # Resource Group where the VM installing the extension resides
    		$Location = 'North Central US' # Location of the VM
    		$Subscription = 'old msdn'
    		$connectionName = "AzureRunAsConnection"
		
    			try
			{
				# Get the connection "AzureRunAsConnection "
				$servicePrincipalConnection= Get-AutomationConnection -Name $connectionName         
		
        		
		
        		"Logging in to Azure..."
				#Add-AzureRmAccount `
     		Login-AzureRmAccount `
			-ServicePrincipal `
			-TenantId $servicePrincipalConnection.TenantId `
			-ApplicationId $servicePrincipalConnection.ApplicationId `
			-CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint    
			}
	    		catch 
        		{
		    		if (!$servicePrincipalConnection)
		    		{
			    		$ErrorMessage = "Connection $connectionName not found."
			    		throw $ErrorMessage
				} 
        		else
            		{
			    		Write-Error -Message $_.Exception
			    		throw $_.Exception
		    		}   
			}
			
    		
    		Write-Output "Selecting Subscription $Subscription"
    		Select-AzureRmSubscription $Subscription
		
		<#
    If ((Remove-AzureRmVMCustomScriptExtension -ResourceGroupName $RG -VMName $VMName -Name $Script -Confirm:$false -Force -verbose).StatusCode)
    {
        Write-Output "Removing VMExtension from Server $VMname "
        Remove-AzureRmVMCustomScriptExtension -ResourceGroupName $RG -VMName $VMName -Name $Script -Confirm:$false -Force -verbose
    }
#>
		
    		Write-Output "Applying Extension"
    		Set-AzureRmVMCustomScriptExtension -ResourceGroupName $RG -VMName $VMname -Location $Location -FileUri $URI -Run $Script -Name $Script -TypeHandlerVersion '1.9' -Verbose
		
		    
	}
}