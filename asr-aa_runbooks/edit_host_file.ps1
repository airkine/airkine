
    $VMName = 'fapp1-test'
    $Script = 'edit_hostfile.ps1'
    $URI = 'https://raw.githubusercontent.com/airkine/sampleScripts/master/edit_hostfile.ps1'
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
    If (Get-AzureRmVMCustomScriptExtension -ResourceGroupName $RG -VMName $VMName -Name $Script)
    {
        Write-Output "Removing VMExtension from Server $VMname "
        Remove-AzureRmVMCustomScriptExtension -ResourceGroupName $RG -VMName $VMName -Name $Script -Confirm:$false -Force -verbose
    }
#>


    Set-AzureRmVMCustomScriptExtension -ResourceGroupName $RG -Verbose -VMName $VMname -Location $Location -FileUri $URI -Run $Script -Name $Script -TypeHandlerVersion '1.9'

    