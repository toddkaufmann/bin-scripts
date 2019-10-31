#!/bin/bash
# see:
#  https://www.tutorialkart.com/bash-shell-scripting/bash-split-string/
# and:
#  https://stackoverflow.com/questions/1335815/how-to-slice-an-array-in-bash
 
# 
str="--date a=b&c=d /url/path"
 

# space  is set as delimiter
IFS=' ' read -ra ADDR <<< "$str" # str is read into an array as tokens separated by IFS
for i in "${ADDR[@]}"; do # access each element of array
    echo "$i"
done
#IFS=' ' # reset to default value after usage

echo '-----------------------'
echo slice: "${ADDR[@]:0:2}";
echo last:  "${ADDR[2]}"; 
