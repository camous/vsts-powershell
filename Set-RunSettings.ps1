param([string]$RunSettingsPath)

"RunSettings Path :`t" + $RunSettingsPath

$xml = [xml](Get-Content $RunSettingsPath)

foreach($setting in (Get-ChildItem ENV:) | ? { $_.Name -like "__*"})
{
    # we prefix our parameters with "__" in order to be able to extract it from all systems ENV: variables. 
    # but when sending to azure, we remove those extra prefix
    $name = $setting.Name.Substring(2)
    $value = $setting.Value

    $name + ' : ' + $value
	
	$node = $xml.RunSettings.TestRunParameters.Parameter | ? { $_.name -eq $name}
	$node.Value = $value;
}

$xml.Save($RunSettingsPath);