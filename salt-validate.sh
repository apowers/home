#!/bin/bash
# See http://wikit/index.php/Salt_Testing for setup procedure
hg_root=$(hg root)
exit=0
SALTCALL='salt-call --config-dir=${hg_root} --local --log-level=error --retcode-passthrough --out=quiet'

# Run nose tests for everything.
for MODULE in $( ls -1 ${hg_root}/salt ) ; do
    if [[ -d ${hg_root}/salt/$MODULE ]] ; then
        nosetests -w ${hg_root}/salt $MODULE
        exit=$(($exit + $?))
    fi
done

# run lint tests on modified and added files
for FILE in $(hg status|awk '{if ($1 == "M" || $1 == "A") print $2}') ; do
  case $FILE in
  *.py)
    # Python Scripts get Linted
    echo "Linting $FILE"
    pylint --errors-only --rcfile=${hg_root}/.pylintrc $FILE
    exit=$(($exit + $?))
    ;;
  # Salt Top files get compiled
  *top.sls)
    echo "Compiling $FILE"
    STATE=$(echo $FILE|cut -d'.' -f1|cut -d'/' -f2-|tr '/' '.')
    eval $SALTCALL state.show_top $STATE
    exit=$(($exit + $?))
  ;;
  # Salt State files get compiled
  *.sls)
    # Salt State files get compiled
    echo "Compiling $FILE"
    STATE=$(echo $FILE|cut -d'.' -f1|cut -d'/' -f2-|tr '/' '.')
    eval $SALTCALL state.show_sls $STATE
    exit=$(($exit + $?))
  ;;
  *.dll)
    # Don't do anything to DLL files.
  ;;
  *)
    # Everything else is rendered as a template
    echo "Rendering ${hg_root}/$FILE"
    eval $SALTCALL cp.get_template file:${hg_root}/$FILE /tmp/salt_validate_tempfile >/dev/null
    exit=$(($exit + $?))
    rm -f /tmp/salt_validate_tempfile
  ;;
  esac
done

exit $exit

