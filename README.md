# option-mapper

Maps multiple instances of the same command line option to multiple invocation of a target program.

I.e.

```

option-mapper.sh. --map-option=1 --map-option=2 --map-option=3 --common-option-two=one --common-option-two=two

```

Will be mapped into threee invocations of the target program as following:

```bash

target.sh --map-option=1 --common-option-two=one --common-option-two=two
target.sh --map-option=2 --common-option-two=one --common-option-two=two
target.sh --map-option=3 --common-option-two=one --common-option-two=two

```


