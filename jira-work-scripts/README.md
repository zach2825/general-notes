# jira and feature branch scripts

This is a collection of bash and php scripts that will automatically move tasks in Jira to in progress and create a feature branch to work in.

# Setup

set this up where you want. I have it in my home directory ~/scripts

## Copy the settings.cfg file to the root of your home directory
	cp settings.cfg ~/.settings.cfg

	edit the settings.cfg and make sure email, password, and branch_name match your preferences

## Aliases
* Add aliases to your ~/.bash_aliases file
```
alias gp="~/scripts/post-push.sh"
alias gb="php ~/scripts/generate_tbranch.php -i";
```

# Run

## Create the new branch using the standard subject line template after the aliases are in place
RUN ```gb TASKNUMBER```
For example: `gb 600`
Then follow the prompts

## To push up the completed task, mark it is code review and get link to submit pull request
RUN `gp`
Then follow the prompts and read

# Log
The log will save the date and time the branch was created using this script
