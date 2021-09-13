#!/bin/bash 
yum install ${openjdk} tmux wget zsh git -y 
mkdir ${minecraft-core}
cd ${minecraft-core}
wget ${minecraft-download-spigot}-${minecraft-version}.jar -O ${minecraft-core}/spigot${minecraft-version}.jar
echo "eula=true" >> ${minecraft-core}/eula.txt

CHSH=no sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s /bin/zsh

gsutil cp -r  gs://minecraft-server-terraform/world-1an world
#tmux new-session -d -s Minecraft-Server 'java -jar ${minecraft-core}/spigot${minecraft-version}.jar'
#gsutil cp -m world gs://minecraft-server-terraform/world-1an ${minecraft-core}/world
