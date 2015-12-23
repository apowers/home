#!/bin/bash

# Check Chef files for stlye and syntax

## Checks not valid here:
# knife cookbook test ## Depricated in favor of rubocop
# ChefSpec ## for unit tests
# ServerSpec ## for intergration tests

RET=0

# Checks for Ruby, doesn't work for ERB
# https://github.com/bbatsov/rubocop
# https://github.com/bbatsov/ruby-style-guide
rubocop --format emacs
[ $? -ne 0 ] && RET=1
# In rakefile:
# require 'rubocop/rake_task'
# RuboCop::RakeTask.new(:ruby)

# Checks specifically for cookbooks
foodcritic
[ $? -ne 0 ] && RET=1
# FoodCritic::Rake::LintTask.new in rakefile

# Check ERB templates by compiling them into ruby and then validating that ruby.
for FILE in `find . -name '*.erb'`;do
  erb -x -T - $FILE | ruby -c > /dev/null
  if [ $? -ne 0 ] ; then echo $FILE : ERB Parse Error; RET=1; fi
done

# Check JSON for data bags etc. by passing them into a JSON parser.
for FILE in `find . -name '*.json'`;do
  cat $FILE | jq 'any' > /dev/null
  if [ $? -ne 0 ] ; then echo $FILE : JSON Parse Error; RET=1; fi
done

exit $RET
