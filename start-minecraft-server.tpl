#!/bin/bash env
yum install ${openjdk} tmux
mkdir ${minecraft-core}
cd ${minecraft-core}
wget minecraft-download-spigot
