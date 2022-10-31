# Loop WordPress Project Installer

A very simple tool to install and setup loop wordpress projects in localhost!

## Intro

By using this tool you can install and setup loop wordpress projects in localhost just in one single command including vitual host create, database import from remote server & domain replacement.

## Getting Started

Getting started with this tool is pretty straight forward. All you have to do is just type a command in terminal.


### Requirements

* You need to have `Apache` installed on your computer. It's not fully compatible with nginx.
* You need to have `php` installed on your computer.
* You need to have `mysql` installed on your computer. Also the `mysql` command should be executable in terminal. If not, then you can create a symbolic link like this `sudo ln -s /Applications/MAMP/Library/bin/mysql /usr/local/bin/mysql`

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

That's all!

### Usage

Use the below command inside the project

```
sh install.sh
```

or

```
sh install.sh -d "example.com" -p "/Users/mahedi/wp" -b "root@example.com:/var/backups/db.zst" -g "git@gitlab.agentur-loop.com:example-website-2019.git" -h "Yes"
```
