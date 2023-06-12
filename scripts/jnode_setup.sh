#!/bin/bash

# Source proxy for java installation.
#cd ~/

#source proxy.sh

#PROXY=proxy.sh
SERVICE_NAME="jnode.service"
agent="agent.jar"
wget=/usr/bin/wget
java=/usr/bin/java
ret=$?
# SYNC_APP=~/frappe-bench/apps/invoice_sync
# FRONTEND=~/ezy-invoice-production
# BACKEND=~/frappe-bench/apps/version2_app
# PARSER=~/frappe-bench/apps/version2_app/version2_app/parsers_invoice/invoice_parsers

##### Adding safe.directory
#sudo git config --system --add safe.directory /home/frappe/frappe-bench/apps/invoice_sync
#sudo git config --system --add safe.directory /home/frappe/frappe-bench/apps/version2_app
#sudo git config --system --add safe.directory /home/frappe/frappe-bench/apps/version2_app/version2_app/parsers_invoice/invoice_parsers

# Adding new repo url for frontend

# cd $FRONTEND || exit
#     echo "current path:$PWD"
#         sudo git config --system --add safe.directory $FRONTEND
#     echo "Added 'frontend' safe.directory"
# # command to remove old repo url's
#         git remote remove origin
#     echo "Old origin removed"
#         git remote remove upstream
#     echo "Old repo url's are removed"
#         sleep 1
#         git remote add origin https://bharani:ek35zeobnsxm4ugbv6gdcifyd2paigmv2zp4465wghj2lwalqmpa@dev.azure.com/caratred/EzyInvoicing/_git/ezy-invoice-production.git
#     echo "New origin repo url added successfully for 'FRONTEND'"
#         git remote add upstream https://bharani:ek35zeobnsxm4ugbv6gdcifyd2paigmv2zp4465wghj2lwalqmpa@dev.azure.com/caratred/EzyInvoicing/_git/ezy-invoice-production.git
#     echo "New upstream repo url added successfully for 'FRONTEND'"

# # Adding new repo url for backend
# cd $BACKEND  || exit
#     echo "current path:$PWD"
#         sudo git config --system --add safe.directory $BACKEND
#     echo "Added 'backend' safe.directory"
# # command to remove old repo url's
#         git remote remove origin
#     echo "Old origin repo url removed"
#         git remote remove upstream
#     echo "Old upstream repo url's removed"
#         sleep 1
#         git remote add origin https://bharani:cmmbgjlouzg66mstbezadlhmyulfq4kypwosp4yc76p37slugzyq@dev.azure.com/caratred/EzyInvoicing/_git/Ezyinvoice_Backend.git
#     echo "New origin repo url added successfully for 'BACKEND'"
#         git remote add upstream https://bharani:cmmbgjlouzg66mstbezadlhmyulfq4kypwosp4yc76p37slugzyq@dev.azure.com/caratred/EzyInvoicing/_git/Ezyinvoice_Backend.git
#     echo "New upstream repo url added successfully for 'BACKEND'"

# # Adding new repo url for parser
# cd $PARSER || exit
#     echo "current path:$PWD"
#         sudo git config --system --add safe.directory $PARSER
#     echo "Added 'parser' safe.directory"
# # command to remove old repo url's
#         git remote remove origin
#     echo "Old origin repo url removed"
#         git remote remove upstream
#     echo "Old upstream repo url's removed"
#         sleep 1
#         git remote add origin https://bharani:6admufoiq7ftu5677hop3vegwsqg724h4cbmnvre2zl2wmvcquba@dev.azure.com/caratred/EzyInvoicing/_git/invoice_parsers
#     echo "New origin repo url added successfully for 'PARSER'"
#         #git remote add upstream https://GIT_CI_TOKEN:glpat-_DiMvF-rreUMypxhSGqm@gitlab.caratred.com/prasanthvajja/invoice_parsers.git

# # Adding new repo url for invoice-sync
# if [ -n "$SYNC_APP" ]; then
# 	cd $SYNC_APP || exit
# 	    sudo git config --system --add safe.directory $SYNC_APP
# 	echo "Added 'invoice-sync' safe.directory"
# 	    git remote remove origin
#     echo "Old origin url removed"
# 	    git remote remove upstream
# 	echo "Old upstream url removed"
# 	    git remote add origin https://bharani:urktaplg25az77fmu3mi4yc2oanijs4qm3m2ygqbicfird6w6lga@dev.azure.com/caratred/EzyInvoicing/_git/invoice-sync.git
#     echo "New origin repo url added successfully for 'SYNC_APP'"
#         git remote add upstream https://bharani:urktaplg25az77fmu3mi4yc2oanijs4qm3m2ygqbicfird6w6lga@dev.azure.com/caratred/EzyInvoicing/_git/invoice-sync.git
#     echo "New UPSTREAM repo url added successfully for 'SYNC_APP'"    
# else
# 	echo "SYNC_APP is not available"
# fi

#who=whoami

#if [ -f "$PROXY" ]; then
     #source "$PROXY"
#else
     #echo "Not a Accor property"
#fi

# After source for internet wait for 1 sec.
sleep 1

# Enter your sudo passwd form installing the packges
echo "Enter sudo passwd: "
read -s passwd
echo ""

cd ~/ || exit

# installing wget to ping the internet availability
if command -v $wget
then
    echo "wget is installed...."
else
    echo "### Installing wget....."
    echo "$passwd" | sudo -S apt update && sudo apt install wget -y
fi

# Checking internet availability
wget -q --spider http://google.com
if [ $ret -eq 0 ]; then

    echo "Network availability :online"

elif [ $ret -ne 0 ]; then

    echo "Network availability :offline"
    exit
fi
# After checking for the network availability then will download the jenkins agent.
#
read -p "Enter the agent url to download the agent:" url_var
# echo "$url_var"

if [[ $url_var == "https://"* ]] || [[ $url_var == "http://"* ]]; then

    wget "$url_var"
else
    echo "not valid url"
fi

# Rename jenkins agent.jar to company code .jar

# Take the original filename

read -p "Enter the company code to rename the agent file:" rename

if [ -f "$agent" ]; then
     (mv "$agent" "$rename")
     echo "The file is renamed."
fi

# Installing java for jenkins agent
if command -v $java
then
    echo "java is installed...."
else
    echo "## Installing java.."
    echo "$passwd" | sudo -S apt install openjdk-11-jre-headless -y
    echo "java is installed now.."
fi

# So after installing java, create a jnode.sh file with the agent secret key url.

read -p "Enter the agent secret url:" agent_secret
if [[ $agent_secret =~ https://cd.ezyinvoicing.com/* ]]; then
    echo "The URL is valid."
{
        echo "#!/bin/bash"
        echo  "java -jar $HOME/$rename -jnlpUrl" "$agent_secret"
} > ~/jnode.sh

else
    echo "not valid url"
fi

# Now provide the executable permissions to jnode.sh file to execute

if [ ! -x "jnode.sh" ]
then
  echo "$passwd" | sudo -S chmod 777 "jnode.sh" && echo "The file is now executable"
else
  echo "The file is already executable"
fi

# Now we have to add the jnode.service file to start the service on the startup.

cat > ~/$SERVICE_NAME << EOL

[Unit]
Description=Reboot message systemd service.

[Service]
Type=simple
ExecStart=$HOME/jnode.sh start

[Install]
WantedBy=multi-user.target

EOL

# Now provide the executable permissions to jnode.service file to execute

echo "$passwd" | sudo -S chmod 777 "$HOME/$SERVICE_NAME" && echo "The file is now executable"
#
echo "$passwd" | sudo -S mv "$HOME/$SERVICE_NAME" /etc/systemd/system

# After add the jnode.service to the service then we have to start it.

# Start the service of jnode
echo "$passwd" | sudo -S systemctl start $SERVICE_NAME && echo "$SERVICE_NAME is started"

#     echo "jnode.service is not started.."
echo "$passwd" | sudo -S systemctl status $SERVICE_NAME

# Enable the jnode service
echo "$passwd" | sudo -S systemctl enable $SERVICE_NAME && echo "$SERVICE_NAME is enabled"

#
# Now adding jnode.service file to crontab to restart every 7 days

sleep 1

echo "Now adding $SERVICE_NAME file to crontab to restart every 7 days..."

# Below command will add the service file to crontab.

line="0 0 * * 0 /etc/systemd/system/$SERVICE_NAME"
(crontab -u "$(whoami)" -l; echo "$line" ) | crontab -u "$(whoami)" -

sleep 1

echo "jnode setup is done now please check in jenkins..."





