#!/bin/bash 
yum install ${openjdk} tmux wget zsh git -y 
mkdir -p ${minecraft-core}/world
mkdir -p ${minecraft-core}/world_nether
mkdir -p ${minecraft-core}/world_the_end
mkdir -p ${minecraft-core}/plugins
cd ${minecraft-core}
wget ${minecraft-download-spigot}-${minecraft-version}.jar -O ${minecraft-core}/spigot${minecraft-version}.jar
echo "eula=true" >> ${minecraft-core}/eula.txt

CHSH=no sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s /bin/zsh

gsutil -m cp -r gs://minecraft-server-terraform/world-1an world
gsutil -m cp -r gs://minecraft-server-terraform/world_nether-1an world_nether
gsutil -m cp -r gs://minecraft-server-terraform/world_the_end-1an world_the_end

gsutil -m cp -r gs://minecraft-server-terraform/plugins-1an plugins

tmux new-session -d -s Minecraft-Server 'java -jar ${minecraft-core}/spigot${minecraft-version}.jar'

#gsutil -m cp -r world_nether gs://minecraft-server-terraform/world_nether-1an/
#gsutil -m cp -r world_the_end gs://minecraft-server-terraform/world_the_end-1an/
#gsutil -m cp -r plugins gs://minecraft-server-terraform/plugins-1an/
