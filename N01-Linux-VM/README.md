# N01-Linux-VM

Na enem fizičnem računalniku gostitelju izdelajte eno instanco virtualnega okolja v orodju Docker (ali VirtualBox).

Nato namestite linux in vanj strežnik OpenSSH (https://www.openssh.com/) ter izdelajte OpenSSH ključe za dostop za enega oddaljenega uporabnika.

Nato pokažite še, da se v odjemalcu na gostiteljskem računalniku lahko preko avtentifikacije s ključi povežete v to gostovano virtualno okolje s pomočjo odjemalca za OpenSSH.

Na sistemu o vaji oddajte eno združeno lupinsko skripto, ki jo preimenujte v končnico .txt (ne ZIP). Ta .txt naj vsebuje: 1) skripto/kodo (to kar niso komentarji), 2) izpis zagona skripte in čas trajanja zagona (navedite v komentarjih te datoteke, v sekundah na vsaj 3 decimalna mesta) in 3) opis delovanja (prav tako navedite v komentarjih s kodiranjem UTF-8).

ZA POLOVIČNE TOČKE: brez demonstracije odjemalca za OpenSSH

8tč (to pomeni 2 točki manj kot vse točke): če naredite nalogo Docker brez ukaza COPY, je to 2 točki manj.

Namigi:

https://estudij.um.si/pluginfile.php/674769/mod_resource/content/2/primeri-Shell.pdf

https://help.ubuntu.com/community/SSH/OpenSSH/Keys

https://www.virtualbox.org/

https://www.ubuntu.com/download/server

https://www.alpinelinux.org/about/

http://www.damnsmalllinux.org/

https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.2.1-amd64-netinst.iso (brez X)

https://2nwiki.2n.cz/pages/viewpage.action?pageId=75202968

https://azure.microsoft.com/en-us/free/services/virtual-machines/

Live USB ubuntu+Docker: https://docs.docker.com/storage/storagedriver/overlayfs-driver/ v /etc/docker/daemon.json:
{
  "storage-driver": "overlay2"
}

https://releases.ubuntu.com/16.04/ - 32-bit PC (i386) server install image - https://releases.ubuntu.com/16.04/ubuntu-16.04.6-server-i386.iso

#!/bin/bash
cat ODDANA_DATOTEKA.txt | sed -n 100,350p > izvedljiva_skripta.sh; bash izvedljiva_skripta.sh
echo "Skripta izpiše:"
cat ODDANA_DATOTEKA.txt | sed -n 500,550p

#!/bin/bash
echo "Pozdravljeni, začenjam operacijo izdelave oblaka..."

cat $0 | sed -n 12,14p > izvedi.sh
bash izvedi.sh

cat $0 | sed -n 16,18p > Dockerfile

exit


echo "Nova skripta"
echo "Še vedno nova skripta"
echo "Tudi še vedno nova skripta"

FROM ubuntu
...
...


Ta skripta počne to in to....





========================================

TRANSLATION TO ENGLISH:

========================================

Create one instances of a virtual environment (e.g. using Docker or VirtualBox) on one physical host computer.

Then install linux and the OpenSSH server (and https://www.openssh.com/) and create OpenSSH access keys for one remote user.

Then, show that you can connect to this hosted virtual environment using the OpenSSH client from the host computer, passwordless using SSH key authentication.




Submit one merged shell script, renaming it with extension .txt (not .ZIP). This .txt should contain: 1) a script / code (which are not comments), 2) printout of the running of the script (specify this as the commented part of the shell script) and 3) a description of the steps (also as comments, with UTF-8 encoding).


FOR HALF POINTS: without client demonstration for OpenSSH




Tips:

https://estudij.um.si/pluginfile.php/674769/mod_resource/content/2/primeri-Shell.pdf

https://help.ubuntu.com/community/SSH/OpenSSH/Keys

https://www.virtualbox.org/

https://www.ubuntu.com/download/server

https://www.alpinelinux.org/about/

http://www.damnsmalllinux.org/

https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.2.1-amd64-netinst.iso (install without X)

https://2nwiki.2n.cz/pages/viewpage.action?pageId=75202968

https://azure.microsoft.com/en-us/free/services/virtual-machines/

Live USB ubuntu+Docker: https://docs.docker.com/storage/storagedriver/overlayfs-driver/ into /etc/docker/daemon.json:
{
  "storage-driver": "overlay2"
}

#!/bin/bash
cat SUBMITTED_FILE.txt | sed -n 100,350p > executable_script.sh; bash -c executable_script.sh
echo "The script prints:"
cat SUBMITTED_FILE.txt | sed -n 500,550p



#!/bin/bash
cat prva.txt  druga.txt > ODDAJA.txt

#!/bin/bash
mkdir extract
sed < ODDAJA.txt > extract/prva.txt -e 1,$(wc -l prva.txt | awk '{print $1}')p -n
sed < ODDAJA.txt > extract/druga.txt -e 1,$(wc -l druga.txt | awk '{print $1}')p -n