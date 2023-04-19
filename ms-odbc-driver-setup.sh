#!/usr/bin/env bash
# ms-odbc-driver-setup.sh
#
# Installs the Microsoft SQL Server ODBC driver for Linux
#
# Adapted from code found on https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server
#
# @author    Matt Harrison <matt.harrison@madefortrade.co>


if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi
if ! [[ "18.04 20.04 22.04" == *"$(lsb_release -rs)"* ]]; then
    echo "Ubuntu $(lsb_release -rs) is not currently supported."
    exit
fi

echo 'Adding Microsoft key to apt'
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list >/etc/apt/sources.list.d/mssql-release.list

echo 'Getting package list'
apt-get update
echo 'Installing msodbcsql18'
ACCEPT_EULA=Y apt-get install -y msodbcsql18
echo 'Installing mssql-tools18'
ACCEPT_EULA=Y apt-get install -y mssql-tools18
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >>~/.bashrc
source ~/.bashrc
echo 'Installing unixodbc-dev'
apt-get install -y unixodbc-dev

exit
