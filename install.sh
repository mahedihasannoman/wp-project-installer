#!/bin/bash

# Import Configs
. .config

# exit when any command fails
set -e
trap clear_temp_folder EXIT

# Set the color variable
warn='\033[0;33m'
green='\033[0;32m'
clear='\033[0m'

# Get arguments via command line
# `-p` for Project path
# `-g` Fot Git repo
# `-b` for backup db path
# `-d` for project domain
while getopts p:g:b:d:i: flag
do
    case "${flag}" in
        p) project=${OPTARG};;
        g) gitrepo=${OPTARG};;
        b) backup_dbpath=${OPTARG};;
        d) projectdomain=${OPTARG};;
    esac
done

# Get the project path if not passed as argument
if [ "$project" == "" ]; then
  echo "${warn}please provide project path${clear}"
  read project
fi

# Get the gitrepo if not passed as argument
if [ "$gitrepo" == "" ]; then
  echo "${warn}please provide git repo${clear}"
  while [[ $gitrepo = "" ]]; do
    read gitrepo
  done
fi

# Get the backup_dbpath if not passed as argument
if [ "$backup_dbpath" == "" ]; then
  echo "${warn}please provide backup DB path${clear}"
  while [[ $backup_dbpath = "" ]]; do
    read backup_dbpath
  done
fi

# Get the project domain if not passed as argument
if [ "$projectdomain" == "" ]; then
  echo "${warn}please provide project domain${clear}"
  while [[ $projectdomain = "" ]]; do
    read projectdomain
  done
fi

dbname=$projectdomain

# Now we have all the info that required.

# navigate to the directory
cd ${project}

# clone the repo
echo "Cloning project.."
git clone ${gitrepo}
echo "${green}Project has been cloned successfully${clear}"
project_root=$(find * -type d -prune -exec ls -d {} \; |head -1)
cd ${project_root}

# Find the WP root dir.


# Download the backup database
# mkdir -p ${project}/${projectdomain}-db
echo "Downloading Database..."
rsync -avz ${backup_dbpath} ${project}/${projectdomain}-db/

zst_backup_file=`ls ${project}/${projectdomain}-db/ | tail -1`
if [ ! -z "${project}/${projectdomain}-db/$zst_backup_file" ]
then
	echo "${green}Database has been downloaded. Extracting it now...${clear}"
	unzstd ${project}/${projectdomain}-db/${zst_backup_file}
	rm -rf ${project}/${projectdomain}-db/${zst_backup_file}
	backup_sql=`ls ${project}/${projectdomain}-db/ | tail -1`
	if [ ! -z "${project}/${projectdomain}-db/$backup_sql" ]
	then
		echo "Creating Database..."
		${mysql} --user="${dbuser}" --password="${dbpass}" --execute="CREATE DATABASE ${dbname};"
		echo "${green}Database has been creared!${clear}"
		echo "Importing Database..."
		${mysql} --user="${dbuser}" --password="${dbpass}" ${dbname} < ${project}/${projectdomain}-db/${backup_sql}
		rm -rf ${project}/${projectdomain}-db
		echo "${green}Database has been imported successfully.${clear}"
	fi

fi

echo "Creating vhost..."
vhost="<VirtualHost *:80>\n
    \tServerAdmin m.hasan@agentur-loop.com\n
    \tDocumentRoot \"${project}/public\"\n
    \tServerName ${projectdomain}.devlocal\n
    \t<Directory \"${project}/public\">\n
        \t\tOptions All\n
        \t\tAllowOverride All\n
    \t</Directory>\n
    \tErrorLog \"logs/${projectdomain}.devlocal-error_log\"\n
    \tCustomLog \"logs/${projectdomain}.devlocal-access_log\" common\n
</VirtualHost>"

echo $vhost >> /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf

host_content="# Added by project-installer\n127.0.0.1\t${projectdomain}.devlocal\n# End of section"

echo $host_content >> /etc/hosts
echo "${green}vhost setup successful: http://${projectdomain}.devlocal${clear}"
echo "Thank you!";

clear_temp_folder () {
	[ -d "${project}/${projectdomain}-db" ] && rm -rf ${project}/${projectdomain}-db

	if [ "$project_root" != "" ]; then
		[ -d "${project}/${project_root}" ] && rm -rf ${project}/${project_root}
	fi
}