#!/bin/bash

source ~/.settings.cfg

TICKET_NUMBER="$1"

#check to see if this code is done. if it is change the transition
read -p "Ready for task to be marked 'in development'? (y/n)? " ans;

YES="y";

if [[ "${ans}" == "${YES}" ]]
then
    # transition id 91 is Start development
    curl -s -D- -u "$email":"$password" -X POST --data "{\"transition\":{\"id\": \"91\"}}" -H "Content-Type: application/json"  "$url/rest/api/2/issue/ST-${TICKET_NUMBER}/transitions"

    echo "This task has been marked in development";
fi