#!/bin/bash

########################################################
# AutoM8 - Linux Server Post-Install Automation Tool   #
# Author: Marcio Moreira junior                        #
# email: mdmjunior@gmail.com                           #
# Version 1.0                                          #
########################################################

echo "This script will install AutoM8 Tool in your server, please wait..."

# Collecting Distribution Information
DISTRO=$(lsb_release -is 2>/dev/null)
RELEASE=$(lsb_release -rs 2>/dev/null)
CODENAME=$(lsb_release -cs 2>/dev/null)
DATEINSTALL=$(ls -lct /etc/| tail -1 | awk '{print $6, $7, $8}')

