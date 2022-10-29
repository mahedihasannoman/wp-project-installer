#!/bin/bash

# Import Configs
. .config

# exit when any command fails
set -e

echo "Please provide your project path\n"
read project

echo "Provide your Git repo to clone\n"
read gitrepo

echo "Provide your project domain\n"
read projectdomain

read -p "Do you want to setup the DB? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
	echo "Please provide your mysql path\n";
	read mysql
	echo "DB name?\n";
	read dbname
	echo "DB user?\n"
	read dbuser
	echo "DB password?\n"
	read dbpass

	echo "Please provide loop backup DB path\n"
	read backup_dbpath

	# navigate to the directory
	cd ${project}
	
	# clone this repo
	echo "Cloning project\n"
	git clone ${gitrepo}
	echo "Project cloned successfull\n"


	# Download the backup database
	mkdir -p ${project}/temp-db
	echo "Downloading Database\n"
	rsync -avz ${backup_dbpath} ${project}/temp-db/
	
	zst_backup_file=`ls ${project}/temp-db/ | tail -1`

	if [ ! -z "${project}/temp-db/$zst_backup_file" ]
	then
		echo "Database downloaded. Extracting it.\n"
		unzstd ${project}/temp-db/${zst_backup_file}
		rm -rf ${project}/temp-db/${zst_backup_file}
		backup_sql=`ls ${project}/temp-db/ | tail -1`

		if [ ! -z "${project}/temp-db/$backup_sql" ]
		then
			echo "Creating Database\n"
			${mysql} --user="${dbuser}" --password="${dbpass}" --execute="CREATE DATABASE ${dbname};"
			echo "Importing Database\n"
			${mysql} --user="${dbuser}" --password="${dbpass}" ${dbname} < ${project}/temp-db/${backup_sql}
			rm -rf ${project}/temp-db
			echo "Imported successfully. Removing temp DB\n"
		fi

	fi
else
	# navigate to the directory
	cd ${project}

	# clone this repo
	echo "Cloning project\n"
	git clone ${gitrepo}
	echo "Project cloned successfull\n"
fi

echo "Creating vhost\n"

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



echo "Thank you!";