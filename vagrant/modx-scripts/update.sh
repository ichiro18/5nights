#!/bin/bash

echo "Enter username"
read USERNAME

##############

echo "Updating MODx"

cd /var/www/$USERNAME/www/

echo "Getting file from modx.com..."
sudo -u $USERNAME wget -O modx.zip http://modx.com/download/latest/
echo "Unzipping file..."
sudo -u $USERNAME unzip "./modx.zip" -d ./ > /dev/null

ZDIR=`ls -F | grep "modx-" | head -1`
if [ "${ZDIR}" = "/" ]; then
        echo "Failed to find directory..."; exit
fi

if [ -d "${ZDIR}" ]; then
        cd ${ZDIR}
        echo "Moving out of temp dir..."
        sudo -u $USERNAME cp -r ./* ../
        cd ../
        rm -r "./${ZDIR}"

        echo "Removing zip file..."
        rm "./modx.zip"

        cd "setup"
        echo "Running setup..."
        sudo -u $USERNAME php ./index.php --installmode=upgrade --config=/var/www/$USERNAME/config.xml

        echo "Done!"
else
        echo "Failed to find directory: ${ZDIR}"
        exit
fi

echo "Done"