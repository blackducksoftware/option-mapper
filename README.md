# option-mapper

Maps multiple instances of the same command line option to multiple invocation of a target program.

I.e.

```

option-mapper.sh. --map-option=1 --map-option=2 --map-option=3 --common-option-one=one --common-option-two=two

```

Will be mapped into threee invocations of the target program as following:

```bash

target.sh --map-option=1 --common-option-one=one --common-option-two=two
target.sh --map-option=2 --common-option-one=one --common-option-two=two
target.sh --map-option=3 --common-option-one=one --common-option-two=two

```

Mapper supports dependent options to prevent collisions between multiple invocations.

## Example:

```
option-mapper.sh. --map-option=1 --map-option=2 --map-option=3 --common-option-two=one --dependent-option-one=two
```

Will be mapped as following:

```bash

target.sh --map-option=1 --common-option-one=one --dependent-option-one=invocation_1_two
target.sh --map-option=2 --common-option-one=one --dependent-option-one=invocation_2_two
target.sh --map-option=3 --common-option-one=one --dependent-option-one=invocation_3_two

```

## Synopsys Detect Example

detect-example.sh will utilize option mapper to allow specifying multiple --detect.source.path options at once.

This will place scans generated by each invocation of synopsys detect under the same project and version.


## PowerShell Detect example

detect-option-mapper.ps1 will implement similar functionality with windows PowerShell

E.g.

```

   & .\detect-option-mapper.ps1 `
     --detect.source.path=part1 `
     --detect.source.path=part2 `
	   --detect.source.path='part 3'  `
	   --blackduck.trust.cert=true `
	   --blackduck.url='https://ec2-3-236-71-181.compute-1.amazonaws.com' `
	   --blackduck.api.token='MTNlMDZhMjItNmU3ZC00OThhLWJkMGItOGNjZjE5YTg5N2UzOmM3ZmJjZDZmLWVkODUtNDZiYS1hZjE2LWQ4NGNjMGQ2NGI0NA==' `
	   --detect.project.name=FOO `
	   --detect.project.version.name=BAR

```
	   
  Will be translated into the following invocation sequence:

```
    powershell "[Net.ServicePointManager]::SecurityProtocol = 'tls12'; Invoke-RestMethod https://detect.synopsys.com/detect.ps1?$(Get-Random) | Invoke-Expression ; detect " `
	--detect.source.path=part1 `
	--blackduck.trust.cert=true `
	--blackduck.url=https://ec2-3-236-71-181.compute-1.amazonaws.com `
	--blackduck.api.token=MTNlMDZhMjItNmU3ZC00OThhLWJkMGItOGNjZjE5YTg5N2UzOmM3ZmJjZDZmLWVkODUtNDZiYS1hZjE2LWQ4NGNjMGQ2NGI0NA== `
	--detect.project.name=FOO `
	--detect.project.version.name=BAR

. . .
    powershell "[Net.ServicePointManager]::SecurityProtocol = 'tls12'; Invoke-RestMethod https://detect.synopsys.com/detect.ps1?$(Get-Random) | Invoke-Expression ; detect " `
	--detect.source.path=part2 `
	--blackduck.trust.cert=true `
	--blackduck.url=https://ec2-3-236-71-181.compute-1.amazonaws.com `
	--blackduck.api.token=MTNlMDZhMjItNmU3ZC00OThhLWJkMGItOGNjZjE5YTg5N2UzOmM3ZmJjZDZmLWVkODUtNDZiYS1hZjE2LWQ4NGNjMGQ2NGI0NA== `
	--detect.project.name=FOO `
	--detect.project.version.name=BAR

. . .
    powershell "[Net.ServicePointManager]::SecurityProtocol = 'tls12'; Invoke-RestMethod https://detect.synopsys.com/detect.ps1?$(Get-Random) | Invoke-Expression ; detect " `
	--detect.source.path=part` 3 `
	--blackduck.trust.cert=true `
	--blackduck.url=https://ec2-3-236-71-181.compute-1.amazonaws.com `
	--blackduck.api.token=MTNlMDZhMjItNmU3ZC00OThhLWJkMGItOGNjZjE5YTg5N2UzOmM3ZmJjZDZmLWVkODUtNDZiYS1hZjE2LWQ4NGNjMGQ2NGI0NA== `
	--detect.project.name=FOO `
	--detect.project.version.name=BAR

. . .

```

