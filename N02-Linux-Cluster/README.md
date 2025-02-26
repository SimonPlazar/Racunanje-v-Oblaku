# N02-Linux-Cluster

Virtualno okolje iz naloge N01 klonirajte na skupno vsaj N=3 instance tega okolja, s pomočjo parameterizirane programske skripte za vrednost N.

Nato uredite mrežne nastavitve (tudi programsko) za vsako klonirano instanco, tako da ima ta svojo lokalno številko naslova internetnega protokola (IP) in omogočena komunikacija do strežnika OpenSSH med temi instancami in do njih.

Nato pokažite, da se lahko iz gostiteljskega računalnika (računalnik 0) povežete na vsako gostovano okolje (računalnik 1) in iz tega gostovanega okolja naprej na drugo gostovano okolje (računalnik 2) ter na tem slednjem (računalnik 2) poženite ukaz `hostname -I`. To pokažite za vse kombinacije in ker bi bilo npr. pri N=10 za 90 kombinacij povezav, ta izpis naredite s pomočjo skripte Bash in ukaza `pssh` (Alpine Linux) ali `parallel-ssh` (Ubuntu Linux).

Primer za nekaj kombinacij: ssh rac1 parallel-ssh -i -H rac2 -H rac3 -H rac4 -H rac5 -H rac6 -H rac7 -H rac8 -H rac9 -H rac10 hostname -I

Več namigov:

host# echo 'deb http://archive.ubuntu.com/ubuntu bionic universe' >> /etc/apt/sources.list; apt-get update; apt-get install pssh

host$ for rac in rac{1..10}; do echo ssh $rac parallel-ssh $(echo rac{1..10} | sed -e 's/'$rac'//g'); done

host$ vboxmanage clonevm Ubuntu

host$ vboxmanage controlvm Linux savestate

host$ vboxmanage startvm Linux -type headless

Na sistemu o vaji oddajte eno združeno lupinsko skripto, ki jo preimenujte v končnico .txt (ne ZIP). Ta .txt naj vsebuje: 1) skripto/kodo (to kar niso komentarji), 2) izpis zagona skripte in čas trajanja zagona (navedite v komentarjih te datoteke) in 3) opis delovanja (prav tako navedite v komentarjih s kodiranjem UTF-8).

ZA POLOVIČNE TOČKE (velja za zagovore v oktobru): brez demonstracije odjemalca za vse kombinacije (le 1 popolna kombinacija)

BONUS (za zagovore v oktobru) =+1tč: N=5, BONUS=+2tč: N=10, BONUS=+10tč: N=500

Še nekaj napotkov - FAQ:
1.
Vprašanje: zakaj mi v Ubuntu 20.04 ne nastavi različnih IP-naslovov, če instance kloniram in imajo tudi različne naslove MAC?
Odgovor: v tej verziji Ubuntu je znan hrošč pri poizvedbah DNS, saj se v jedru ne osveži naslov MAC. Za osvežitev stanja MAC v jedru poženite naslednje ukaze:

sudo rm -f /etc/machine-id
sudo dbus-uuidgen --ensure=/etc/machine-id
sudo rm /var/lib/dbus/machine-id
sudo dbus-uuidgen --ensure
sudo reboot
2.
Vprašanje: imam primer, ko sem v virtualno okolje instaliral Linux in OpenSSH, nato pa se mi vanj ne gre povezati iz gostiteljskega računalnika.
Odgovor: najprej preverite, da imate nastavljen tip omrežja za to virtualko na "Host Only" - to vam zagotavlja, da VirtualBox simulira omrežje med virtualnim okoljem in gostiteljem. Nato preverite, da imate pravilno dodeljene naslove IP.
V kolikor naslove dodeljujete preko interenega VirtualBox strežnika za DNS, preverite, da se predvideno podomrežje ne prekriva s katerim drugim na gostitelju. Primer: na gostitelju imamo omrežno povezavo LAN, brezžiščno omrežje WLAN, nameščeno še podomrežje za Docker ter nekaj vmesnikov za VirtualBox - v tem primeru preverite, na katerega od vmesnikov je povezana želena gostujoča instanca in da se razpon IP-jev ne prekriva z ostalimi. V kolikor gre za prekrivanje, prenastavite velikosti podomrežij (maske!), npr. namesto 16-bitnih na 8-bitne ali pa premaknite naslove na drug razpon.

Primer:      

inet 192.168.122.1  netmask 255.255.255.0  broadcast 192.168.122.255
V gostitelju lahko naslove IP nato določite tudi ročno, npr. za prvo instanco je zadnja številka ".3", za drugo ".4", za tretjo ".5" itd. (torej 192.168.122.3, 192.168.122.4, 192.122.5, ...):

rac1$ ifconfig enp3s0 192.168.122.3 netmask 255.255.255.0
rac2$ ifconfig enp3s0 192.168.122.4 netmask 255.255.255.0
rac3$ ifconfig enp3s0 192.168.122.5 netmask 255.255.255.0


3.
Vprašanje: Ali lahko uporabim Microsoft Azure?
Odgovor: Da, seveda. Za to boste prejeli tudi bonus točke pri oddaji za bonus.
Povezava: https://azure.microsoft.com/en-us/free/services/virtual-machines/


========================================
TRANSLATION TO ENGLISH:

========================================

Clone the virtual environment from task N01 to a total of 3 instances of this environment, using a programmable script that has a parameter for N.

Then edit the network settings (also programatically) for each cloned instance so that it has its own local Internet Protocol (IP) address and the communication to the OpenSSH server is enabled between these instances.

Then show that you can connect to each hosted environment (computer 1) from the host computer (computer 0) and from this hosted environment to another hosted environment (computer 2), and then run the `hostname -i` command at the very latest (computer 2).

Show this for all combinations, and since for e.g. N=10 there would be 90 combinations of links, make this printout using a Bash script and command `pssh` (on Alpine Linux) or `parallel-ssh` (on Ubuntu).

Example for few combinations: ssh comp1 parallel-ssh -i -H comp2 -H comp3 -H comp4 -H comp5 -H comp6 -H comp7 -H comp8 -H comp9 -H comp10 hostname -I

More tips:

host# echo 'deb http://archive.ubuntu.com/ubuntu bionic universe' >> /etc/apt/sources.list; apt-get update; apt-get install pssh

host$ for rac in rac{1..10}; do echo ssh $rac parallel-ssh $(echo rac{1..10} | sed -e 's/'$rac'//g'); done

host$ vboxmanage clonevm Ubuntu

host$ vboxmanage controlvm Linux savestate

host$ vboxmanage startvm Linux -type headless

Submit one merged shell script, renaming it with extension .txt (not .ZIP). This .txt should contain: 1) a script / code (which are not comments), 2) printout of the running of the script (specify this as the commented part of the shell script) and 3) a description of the steps (also as comments, with UTF-8 encoding).
FOR HALF POINTS: without creating a script for all combinations (only 1 complete combination)

BONUS=+1pt: N=5, BONUS=+2pts: N=10, BONUS=+10pts: N=500



Few more guidelines - FAQ:

1.
Question: why doesn't it set different IP addresses for me in Ubuntu 20.04 if I clone instances and they also have different MAC addresses?
Answer: In this version of Ubuntu, there is a known bug in DNS queries because the kernel does not refresh the MAC address. To refresh the MAC state in the kernel, run the following commands:

sudo rm -f /etc/machine-id
sudo dbus-uuidgen --ensure=/etc/machine-id
sudo rm /var/lib/dbus/machine-id
sudo dbus-uuidgen --ensure
sudo reboot
2.
Question: I have a case where I installed Linux and OpenSSH in a virtual environment and then I can't connect to it from the host computer.
Answer: First, make sure you have the network type set for this virtual machine to "Host Only" - this ensures that VirtualBox simulates the network between the virtual environment and the host. Then make sure you have the IP addresses assigned correctly.
If you assign addresses via an internal VirtualBox DNS server, verify that the intended subnet does not overlap with any other on the host. Example: The host has a LAN connection, a wireless WLAN, a Docker subnet installed, and some VirtualBox interfaces - in this case, check which interfaces the desired hosting instance is connected to and that the IP range does not overlap with the others. If it is an overlay, resize the subnets (masks!), E.g. instead of 16-bit to 8-bit, or move addresses to another range.

Example:

inet 192.168.122.1  netmask 255.255.255.0  broadcast 192.168.122.255
You can also specify IP addresses manually in the host, e.g. for the first instance the last number is ".3", for the second ".4", for the third ".5", etc. (therefore 192.168.122.3, 192.168.122.4, 192.122.5, ...):

comp1$ ifconfig enp3s0 192.168.122.3 netmask 255.255.255.0
comp2$ ifconfig enp3s0 192.168.122.4 netmask 255.255.255.0
comp3$ ifconfig enp3s0 192.168.122.5 netmask 255.255.255.0
3.
Question: May I use Microsoft Azure?
Answer: Yes, of course. For doing this, you are also eligible for bonus points at bonus scoring.
Link: https://azure.microsoft.com/en-us/free/services/virtual-machines/






Shematska slika s prikazom primera internetnih povezav / Schematic figure displaying an example of internet connections:



VIEW 1 (zunanji računalnik -> gruča - outer computer -> cluster) 







VIEW 2: zunanji računalnik -> en notranji računalnik (rac1) -> ostali notranji računalniki (rac2..rac9) -- outer computer -> one inner computer (rac1) -> other inner computers (rac2..rac9)







VIEW 3: pari javnih-zasebnih ključev (key + key.pub) in povezave --- public-private key pairs (key + key.pub) and connections







VIEW 4: tipi ključev: uporabnik vs. strežniki (ssh_key, key) -- key types: users vs. servers (ssh_key, key)





STEP 5: na rac0:  for r in {1..9}; do ssh-keyscan rac$r; done; docker CP ~/.ssh/.known_hosts na rac{1..9}:/root/.ssh/known_hosts













HNY












