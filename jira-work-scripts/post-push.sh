#!/bin/bash

BYPASS="no"
while getopts ":n" opt; do
  case $opt in
    n)
      BYPASS="yes"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

source ~/.settings.cfg

BRANCH="`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`"
TICKET_NUMBER=`echo "${BRANCH}" | sed -n "s|${branch_name}/ST-\([[:digit:]]\+\)\(.*\)|\1|pi"`

git push origin "${BRANCH}"

LINK="${GITHUB_BRANCH_URL}...${BRANCH}"
JIRA_LINK="https://${url}/browse/ST-${TICKET_NUMBER}"

echo "Link to submit a pull request: ${LINK}"
echo "Link To the ticket ${JIRA_LINK}"

NO="no";

if [[ "${BYPASS}" == "${NO}" ]]; then
	#check to see if this code is done. if it is change the transition
	read -p "Ready for code review? (y/n)? " ans;

	YES="y";

	if [[ "${ans}" == "${YES}" ]]; then
		# transition id 141 is Code Review
		curl -s -D- -u "$email":"$password" -X POST --data "{\"transition\":{\"id\": \"141\"}}" -H "Content-Type: application/json"  "$url/rest/api/2/issue/ST-${TICKET_NUMBER}/transitions"
		# sensible-browser "${JIRA_LINK}" &
		# sensible-browser "${LINK}" &
	fi
fi

#create space before the rest of the commit messages start
echo ""
echo "Link to submit a pull request: ${LINK}"
echo ""
