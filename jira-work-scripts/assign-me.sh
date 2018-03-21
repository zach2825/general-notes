#!/bin/bash

source ~/.settings.cfg

TICKET_NUMBER="$1"

#check to see if this code is done. if it is change the transition
read -p "Mark your self? (y/n)? " ans;

YES="y";

if [[ "${ans}" == "${YES}" ]]
then
    # transition id 91 is Start development
    curl -s -D- -u "$email":"$password" -X PUT --data "{\"name\":\"$name\"}" -H "Content-Type: application/json"  "https://${url}/rest/api/2/issue/ST-${TICKET_NUMBER}/assignee"

    echo "This task has been assigned to $email";
fi
