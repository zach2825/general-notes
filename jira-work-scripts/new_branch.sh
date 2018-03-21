#!/bin/bash

NEW_BRANCH_NAME="$1";

git checkout "${NEW_BRANCH_NAME}" 2>/dev/null || git checkout -b "${NEW_BRANCH_NAME}"
echo "switched to the new branch."