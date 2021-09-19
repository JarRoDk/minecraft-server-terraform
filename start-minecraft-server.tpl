#!/bin/bash 
yum install ${openjdk} tmux wget zsh git unzip nginx htop -y
mkdir -p ${minecraft-core}/${minecraft-bin}
mkdir -p ${minecraft-core}/${minecraft-maps}/${map-prefix}-${realm}

cd ${minecraft-core}

CHSH=no sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s /bin/zsh

gsutil -m cp -r gs://minecraft-server-terraform/maps/ ${minecraft-core}
gsutil -m cp -r gs://minecraft-server-terraform/${minecraft-version}/spigot-server ${minecraft-core}

cd ${minecraft-core}/${minecraft-bin}
tmux new-session -d -s Minecraft-Server 'java -Xmx7G -Xms3G -jar ${minecraft-core}/${minecraft-bin}/spigot${minecraft-version}.jar --world-container ${minecraft-core}/${minecraft-maps}/${map-prefix}-${realm}'


cat <<EOF >${minecraft-core}/backup-map.sh
gsutil -m cp -r ${minecraft-core}/${minecraft-maps} gs://minecraft-server-terraform
EOF

cat <<EOF >${minecraft-core}/backup-server.sh
gsutil -m cp -r ${minecraft-core}/${minecraft-bin} gs://minecraft-server-terraform/${minecraft-version}
EOF

cat <<EOF >${minecraft-core}/backup-all.sh
gsutil -m cp -r ${minecraft-core}/${minecraft-maps} gs://minecraft-server-terraform
gsutil -m cp -r ${minecraft-core}/${minecraft-bin} gs://minecraft-server-terraform/${minecraft-version}
EOF

cat <<EOF >${minecraft-core}/${minecraft-bin}/plugins/SimpleBackup/config.yml
backup-interval-hours: ${simplybackup-interval-hours}
backup-file: ${minecraft-core}/${minecraft-maps}/${realm}/backups/
backup-date-format: yyyy-MM-dd-HH-mm-ss
backup-empty-server: false
disable-zipping: false
broadcast-message: true
backup-message: '[SimpleBackup]'
custom-backup-message: Backup starting
custom-backup-message-end: Backup completed
backup-completed-hook: ''
delete-schedule:
  intervals:
  - 1d
  - 3d
  - 4w
  - 30w
  interval-frequencies:
  - 4h
  - 1d
  - 5d
  - 30d
EOF
