#!/bin/bash
# 
# Command line option mapper.
# Script will detect command line option that is included more than once
# and will map it to a separate invocation of a target program
# 
# Option that would be mapped is defined by OPTION variable
# targe program is defined by the TARGET variable.
# All other options will be passed to the target unchanged.
# For options that are specified as dependent parameter value will be
# augumented with invocation number.
#
# Limitations:
#   Works with long command line options only.
#set -x

OPTION=detect.source.path
#OPT_DEPEND="detect.code.location.name"
OPT_DEPEND="detect.code.location.name detect.bom.aggregate.name"

TARGET="<(curl -s https://detect.synopsys.com/detect.sh)"

# Save the original command line and convert it into array
#
CMDLINE=$*
STRING=$(echo $CMDLINE | sed -E 's/ *\-\-/\,/g')
IFS=',' read -r -a array <<< "${STRING:1}"

OPT_COMMON=()
OPT_ITER=()

for i in "${array[@]}"
do
  echo $i | grep $OPTION && OPT_ITER+=("$i") || OPT_COMMON+=("--$i")
done

echo "${OPT_COMMON[@]}"

echo "${OPT_ITER[@]}"

COUNT=0
COMMAND_PREFIX="echo bash \"$TARGET\" --${i} ${OPT_COMMON[@]} "
for i in "${OPT_ITER[@]}"
do
  COUNT=$(( $COUNT + 1 ))
  unset SED_SCRIPT
  for j in $OPT_DEPEND
  do
    SED_SCRIPT="${SED_SCRIPT} -e s/${j}=/${j}=invocation_${COUNT}_/ "
  done
  #echo $SED_SCRIPT
  if [ "$SED_SCRIPT" ]
  then
    COMMAND=$(eval $COMMAND_PREFIX --${i} | sed $SED_SCRIPT)
  else
    COMMAND=$(eval $COMMAND_PREFIX --${i})
  fi
  echo $COMMAND
  eval $COMMAND
done

