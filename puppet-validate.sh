#!/bin/bash
FAIL=0

#Parse YAML
for FILE in `find . -name '*.yaml'`;do
  ruby -e "require 'yaml';YAML.parse(File.open('$FILE'))" > /dev/null
  if [ $? -ne 0 ] ; then echo $FILE ; FAIL=1; fi
done

#Parse puppet manifests
# Unfortunatly puppet-parser exits 0 on both OK and warnings.
# And still sends warnings to STDERR
for FILE in `find . -name '*.pp'`;do
  puppet parser validate $FILE > /dev/null
  if [ $? -ne 0 ] ; then echo $FILE ; FAIL=1; fi
done

#Parse ERB templates
for FILE in `find . -name '*.erb'`;do
  erb -x -T - $FILE | ruby -c > /dev/null
  if [ $? -ne 0 ] ; then echo $FILE ; FAIL=1; fi
done

exit $FAIL
