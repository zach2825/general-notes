#!/bin/bash

source ~/.settings.cfg

BRANCH="`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`"
TICKET_NUMBER=`echo "${BRANCH}" | sed -n "s|${branch_name}/ST-\([[:digit:]]\+\)\(.*\)|\1|pi"`

echo "${TICKET_NUMBER}"

cat ~/scripts/create_log.log | grep "${TICKET_NUMBER}"