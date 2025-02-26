# N00-Shell

Izdelajte lupinsko datoteko (angl. shell file) shell.txt, ki izdela besedilno datoteko z imenom Dockerfile in še eno datoteko izvedljivega tipa imenovano inner-shell.sh, ki je prav tako besedilna. Lupinski program v datoteki shell.txt nato požene datoteko inner-shell.sh in zaključi izvajanje.

Na konec lupinske datoteke shell.txt vstavite še izpis zagona te lupinske datoteke shell.txt (npr. v konzoli označite in prilepite). Zagon datoteke shell.txt naredite npr. s pomočjo Bash:

$ bash shell.txt
Vsebina datoteke Dockerfile po zagonu lupinske datoteke shell.txt naj bo vsaj te štiri vrstice, ki vključujejo:

FROM alpine:latest
RUN apk update && apk add openssh-server
EXPOSE 22
ENTRYPOINT ["/usr/sbin/sshd", "-D"]

Vsebina datoteke inner-shell.sh po zagonu lupinske datoteke shell.txt naj bo vsaj dve vrstici, ki vključujejo:

sudo docker build -t alpine-ssh .
echo "Done: step 1."


Na sistemu o vaji oddajte eno združeno lupinsko skripto (datoteko shell.txt), ki jo preimenujte v končnico .txt (ne ZIP). Ta .txt naj vsebuje: 1) skripto/kodo (to kar niso komentarji), 2) izpis zagona skripte in čas trajanja zagona (navedite v komentarjih te datoteke) in 3) opis delovanja (prav tako navedite v komentarjih s kodiranjem UTF-8).



POLOVIČNE TOČKE: samo shell.txt, ki izdela Dockerfile in požene gradnjo vsebnika zanj.



BONUS +3tč (velja za zagovore v oktobru): navedite primere po vsaj 3 ukazov iz vsaj treh tipov dela v ukazni lupini linux (skupaj min. 9 primerov): procesi, datoteke, programiranje (računanje na CPE)



BONUS +5tč (velja za zagovore v oktobru): datoteka inner-shell.sh izračuna in na standardni izhod izpiše končno oceno tega predmeta (celo število, največ 10) na podlagi vhodnih točk v besedilnih datotekah tipa TXT:
Ns-Intro.txt Ni-SYCL.txt N00-Shell.txt N01-Linux-VM.txt N02-Linux-Cluster.txt N03-MPI-PingPong.txt N04-MPI-Cluster.txt N05-Sync.txt N06-Control.txt N07-Hadoop-Single.txt N08-Hadoop-Cluster.txt N09-Map.txt N10-Reduce.txt N11-Docker.txt BonusSodelovanje.txt ; K1 K2; Izpit;
pri tem ne pozabite, da BonusSodelovanje.txt prištejete le pri pozitivni oceni (6 ali več), vsak kolokvij mora biti nad 35 točk in Izpit nadomesti kolokvija K1, K2.
Za računanje uporabite ukaz awk ali kak drug ukaz po izbiri (lahko je C++, Python, itd.). Na koncu tega izpisa izpišite še datum, do kdaj je potrebno nalogo zagovoriti in podatke o izpitnem roku iz AIPS (datum, ime predmeta, izvajalec, opcijsko: prostor/ura).


NAMIGI:

- primeri ukazov: https://estudij.um.si/pluginfile.php/674769/mod_resource/content/2/primeri-Shell.pdf

========================================

TRANSLATION TO ENGLISH:

========================================

Create a shell file, named shell.txt, which creates a text file named Dockerfile, and another executable file named inner-shell.sh, which is also a text file. The shell file shell.txt then runs the inner-shell.sh file and terminates the execution.

At the end of the shell.txt shell file, insert a printout of running this shell file shell.txt itself (e.g. copy and paste from console). Run the file shell.txt e.g. using Bash:

$ bash shell.txt
The contents of the Dockerfile file after the shell.txt shell file is run should be at least these four lines, which include:

FROM alpine:latest
RUN apk update && apk add openssh-server
EXPOSE 22
ENTRYPOINT ["/usr/sbin/sshd", "-D"]

The contents of the inner-shell.sh file after the shell.txt shell file is run should be at least two lines, including:

sudo docker build -t alpine-ssh .
echo "Done: step 1."
Submit one merged shell script, renaming it with extension .txt (not .ZIP). This .txt should contain: 1) a script / code (which are not comments), 2) printout of the running of the script (specify this as the commented part of the shell script) and 3) a description of the steps (also as comments, with UTF-8 encoding).

HALF POINTS: Only shell.txt that builds the Dockerfile and builds the container with it.



BONUS +3pts: give examples of at least 3 commands from at least three types of working with the linux command shell (min. 9 examples in total): processes, files, programming (computing on CPU)

BONUS +5pts: file inner-shell.sh calculates and prints to standard output the final grade of this course (integer, maximum 10) based on points in text files of type TXT:
Ns-Intro.txt Ni-SYCL.txt N00-Shell.txt N01-Linux-VM.txt N02-Linux-Cluster.txt N03-MPI-PingPong.txt N04-MPI-Cluster.txt N05-Sync.txt N06-Control.txt N07-Hadoop-Single.txt N08-Hadoop-Cluster.txt N09-Map.txt N10-Reduce.txt N11-Docker.txt BonusSodelovanje.txt ; K1 K2; Exam;
do not forget that you only pass BonusSodelovanje.txt with a positive grade (6 or more), each colloquium (K1, K2) must be above 35 points and the Exam is replaced by colloquiums K1, K2. Use the awk command or any other command of your choice (can be C++, Python, etc.) to calculate.
At the end of this printout, write the date by which the assignment must be defended and information about the exam deadline from AIPS (date, course name, provider, optional: place/time).


HINTS:

- command examples: https://estudij.um.si/pluginfile.php/674769/mod_resource/content/2/primeri-Shell.pdf