# Loop WordPress Project Installer

A very simple tool to install and setup loop wordpress projects in localhost!

## Intro

By using this tool you can install and setup loop wordpress projects in localhost just in one single command including vitual host create, database import from remote server & domain replacement.

## Getting Started

Getting started with this tool is pretty straight forward. All you have to do is just type a command in terminal.


### Requirements

* Make sure you have access to the git repo.
* Make sure you have access to backup db path.
* You need to have `php` installed on your computer.
* You need to have `mysql` installed on your computer. Also the `mysql` command should be executable in terminal. If not, then you can create a symbolic link like this `sudo ln -s /Applications/MAMP/Library/bin/mysql /usr/local/bin/mysql`
* You need to have `Apache` installed on your computer (if you want to setup vhost). It's not fully compatible with nginx.

### Install

Use git to clone this repository into your computer.

```
git clone https://github.com/mahedihasannoman/wp-project-installer.git
```
After that go to the project directory

```
cd wp-project-installer
```

Then open the `.config` file in a text editor and add your own value for these variables
`mysql`, `dbuser`, `dbpass` & `php`

If you want to create vhost automatically then you may need to change the values for the below variables as well. Currently it is just configured for MAMP.
* `vhost_config` virtual host config file.
* `stopApache` executable file path for stoping Apache.
* `startApache` executable file path for starting Apache.

That's all!

### Usage

Use the below command inside the project

```
sh install.sh
```
It will collect required information by asking questions in terminal.

or

```
sh install.sh -d "example.com" -p "/Users/mahedi/wp" -b "root@example.com:/var/backups/db.zst" -g "git@gitlab.com:example-website-2019.git" -h "Yes"
```

### Aruguments

These are the following arguments you can to pass in terminal.

* `-p` (Optional) for Project path. Where you want to install the wp project. If you do not put anything then it will install the project in current directory.
* `-g` (Required) Fot Git repo. e.g: git@gitlab.com:example-website-2019.git or https://gitlab.com/example-website-2019.git
* `-b` (Required) for backup db path. e.g: root@example.com:/var/backups/db.zst
* `-d` (Required) for project domain. e.g: example.com
* `-h` (Optional) for vhost (y/n). If you want to create vhost.
