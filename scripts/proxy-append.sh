#!/bin/bash

read -p "Enter your proxy username:" proxy_user
read -p "Enter your proxy password:" proxy_passwd

if [ -f "/etc/apt/apt.conf.d/proxy.conf" ]; then
        echo "proxy.conf already exits.."
else
sudo tee /etc/apt/apt.conf.d/proxy.conf <<EOF
Acquire::http::Proxy "http://$proxy_user:$proxy_passwd@172.21.244.195:3128/";
Acquire::https::Proxy "http://$proxy_user:$proxy_passwd@172.21.244.195:3128/";
EOF
        echo "proxy.conf added successfully..."
fi

# git commands to set proxy to global 
#git config --global http.proxy=http://"$proxy_user":"$proxy_passwd"@172.21.244.195:3128
#git config --global https.proxy=http://"$proxy_user":"$proxy_passwd"@172.21.244.195:3128

# wget to donwload any files
if [ -f ~/.wgetrc ]; then
        echo ".wgetrc already exits.."
else
    {
        echo http_proxy = http://"$proxy_user":"$proxy_passwd"@172.21.244.195:3128
        echo https_proxy = http://"$proxy_user":"$proxy_passwd"@172.21.244.195:3128
        echo ftp_proxy = http://"$proxy_user":"$proxy_passwd"@172.21.244.195:3128
    }>~/.wgetrc
        echo ".wgetrc added successfully..."
fi

# curl to ping or to donwload
if [ -f ~/.curlrc ]; then
        echo ".curlrc already exits.."
else
    {
        echo proxy = http://"$proxy_user":"$proxy_passwd"@172.21.244.195:3128
    }>~/.curlrc
        echo ".curlrc added successfully..."
fi

# pip to install any modules
mkdir ~/.pip

if [ -f ~/.pip/pip.conf ]; then
        echo "pip.conf already exits.."
else
    {
        echo [global]
        echo proxy = http://"$proxy_user":"$proxy_passwd"@172.21.244.195:3128
    }>~/.pip/pip.conf
        echo "pip.conf added successfully..."
fi

if [ -f ~/.gitconfig ]; then
        echo ".gitconfig already exits.."
else
    {
    echo [http]
        echo proxy = http://"$proxy_user":"$proxy_passwd"@172.21.244.195:3128
    echo [https]
        echo proxy = http://"$proxy_user":"$proxy_passwd"@172.21.244.195:3128
    }>~/.gitconfig
fi 
        echo ".gitconfig added successfully..."     


# To check git config list

#git config --list
