#
# Copyright (C) 2020 Synopsys Inc. http://www.synopsys.com  All rights reserved.
#
#
# Detect Option Mapper powerShell is licensed under Apache License 2.0 
#
#  You may obtain a copy of the License at
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Script will detect if target option is specified multiple times 
# and translate it into multiple invocations of $detectCommand
# E.g.
#   & .\detect-option-mapper.ps1 `
#       --detect.source.path=part1 `
#       --detect.source.path=part2 `
#	   --detect.source.path='part 3'  `
#	   --blackduck.trust.cert=true `
#	   --blackduck.url='https://ec2-3-236-71-181.compute-1.amazonaws.com' `
#	   --blackduck.api.token='MTNlMDZhMjItNmU3ZC00OThhLWJkMGItOGNjZjE5YTg5N2UzOmM3ZmJjZDZmLWVkODUtNDZiYS1hZjE2LWQ4NGNjMGQ2NGI0NA==' `
#	   --detect.project.name=FOO `
#	   --detect.project.version.name=BAR
#	   
#  Will be translated into the following invocation sequence:
#
#    powershell "[Net.ServicePointManager]::SecurityProtocol = 'tls12'; Invoke-RestMethod https://detect.synopsys.com/detect.ps1?$(Get-Random) | Invoke-Expression ; detect " `
#	--detect.source.path=part1 `
#	--blackduck.trust.cert=true `
#	--blackduck.url=https://ec2-3-236-71-181.compute-1.amazonaws.com `
#	--blackduck.api.token=MTNlMDZhMjItNmU3ZC00OThhLWJkMGItOGNjZjE5YTg5N2UzOmM3ZmJjZDZmLWVkODUtNDZiYS1hZjE2LWQ4NGNjMGQ2NGI0NA== `
#	--detect.project.name=FOO `
#	--detect.project.version.name=BAR
#
#    powershell "[Net.ServicePointManager]::SecurityProtocol = 'tls12'; Invoke-RestMethod https://detect.synopsys.com/detect.ps1?$(Get-Random) | Invoke-Expression ; detect " `
#	--detect.source.path=part2 `
#	--blackduck.trust.cert=true `
#	--blackduck.url=https://ec2-3-236-71-181.compute-1.amazonaws.com `
#	--blackduck.api.token=MTNlMDZhMjItNmU3ZC00OThhLWJkMGItOGNjZjE5YTg5N2UzOmM3ZmJjZDZmLWVkODUtNDZiYS1hZjE2LWQ4NGNjMGQ2NGI0NA== `
#	--detect.project.name=FOO `
#	--detect.project.version.name=BAR
#
#    powershell "[Net.ServicePointManager]::SecurityProtocol = 'tls12'; Invoke-RestMethod https://detect.synopsys.com/detect.ps1?$(Get-Random) | Invoke-Expression ; detect " `
#	--detect.source.path=part` 3 `
#	--blackduck.trust.cert=true `
#	--blackduck.url=https://ec2-3-236-71-181.compute-1.amazonaws.com `
#	--blackduck.api.token=MTNlMDZhMjItNmU3ZC00OThhLWJkMGItOGNjZjE5YTg5N2UzOmM3ZmJjZDZmLWVkODUtNDZiYS1hZjE2LWQ4NGNjMGQ2NGI0NA== `
#	--detect.project.name=FOO `
#	--detect.project.version.name=BAR
#
#  Limitations:
#       Note that the script will handle pathnames with spaces gracefully. 
#       However ensure that no spaces are used for parameter assignments.
#       I.e. no spaces in --parameter=value assignments. 


$detectCommand = "[Net.ServicePointManager]::SecurityProtocol = 'tls12'; Invoke-RestMethod https://detect.synopsys.com/detect.ps1?$(Get-Random) | Invoke-Expression ; detect "
$targetOption='--detect.source.path';

$targetValue = @( $args | Where-Object {$_.startsWith($targetOption)} );
$remainigOptions = @( $args | Where-Object {! $_.startsWith($targetOption)} );
 

if (!$targetValue.length) {
    Write-Host "No target option is given, executing as is.";
	Write-Host "";
    Start-Process -Wait -NoNewWindow powershell "$($detectCommand) $($args -replace ' ', '` ')" ;
}
else {
    Write-Host "Target option $($targetOption) specified $($targetValue.length) times";
	foreach ($option in $targetValue ) {
	   Write-Host "detect $($option) $($remainigOptions)";
	   Start-Process -Wait -NoNewWindow powershell "$($detectCommand) $($option -replace ' ', '` ') $($remainigOptions) " ;
	}
}
