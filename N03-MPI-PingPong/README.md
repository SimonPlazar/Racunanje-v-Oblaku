# N03-MPI-PingPong

V virtualna okolja iz N02 namestite Open MPI.

Nato napišite program PingPong, ki v Open MPI iz glavnega vozlišča (rank 0) pošlje eno število s plavajočo vejico (naključno število med 0,00 do 180,00) na vsakega odjemalca (npr. rank 1 ... rank 3).

Nato vsak odjelamec število pošlje nazaj glavnemu vozlišču (rank 0), ki to prejeto število prišteje vsoti po modulu s 360.

Pošiljanje ping-pong ponovite tako dolgo, da je vsota prejetih števil na krožnici na intervalu med 270,505 in 270,515 (vsota ostankov pri deljenju po modulu s 360).

Na koncu glavno vozlišče izpiše število podaj parov sporočil ping-pong na terminal in v datoteko RESULT.TXT.

Na sistemu o vaji oddajte eno združeno lupinsko skripto, ki jo preimenujte v končnico .txt (ne ZIP). Ta .txt naj vsebuje: 1) skripto/kodo (to kar niso komentarji), 2) izpis zagona skripte in čas trajanja zagona (navedite v komentarjih te datoteke, skupaj z datoteko RESULT.TXT) in 3) opis delovanja (prav tako navedite v komentarjih s kodiranjem UTF-8).

========================================

TRANSLATION TO ENGLISH:

========================================

Install Open MPI in virtual environments of N02.



Then write a PingPong program that sends one floating point number (random number between 0.00 ... 180.00) to each client (e.g. rank 1 ... rank 8) in Open MPI from the master node (rank 0).

Then, each client sends the number back to the master node (rank 0) that adds the received number to a sum by modulo with 360.



Execute the ping-pong so long until the sum of numbers on the arc is angle in interval between 270.505 and 270.515 (sum of remainders after modulo with 360).

In the end, the master rank prints number of ping-pong message pairs on terminal and in file RESULT.TXT.


Submit one merged shell script, renaming it with extension .txt (not .ZIP). This .txt should contain: 1) a script / code (which are not comments), 2) printout of the running of the script (specify this as the commented part of the shell script) and file RESULT.TXT and 3) a description of the steps (also as comments, with UTF-8 encoding); .