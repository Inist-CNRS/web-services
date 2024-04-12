#!/bin/bash


# Initialisation des variables pour les options
programme=$(basename "$0")
# version='0.1.3'
# modif='17 Août 2022'

function usage
{
echo "Usage : $programme (start|ws|job|stop) "
echo "        $programme help "
}

function aide
{
cat << EOT

Usage
=====
    $programme (start|ws|job|stop)
    $programme help

Options
=======
    help   affiche cette aide
    job    envoie les données au programme "IRC3sp.pl"
    start  lance le programme "IRC3sp.pl" en mode "nohup"
    stop   arrête le programme "IRC3sp.pl"
    ws     lance le programme "IRC3sp.pl" en mode "nohup" et "webservice"

EOT

exit 0
}

function lance_irc3
{
nohup IRC3sp.pl -t CoL.txt -p /tmp/fifo_irc3 -c &
}

function lance_irc3_ws
{
nohup /app/public/v1/IRC3sp.pl -t /app/public/v1/CoL.txt -p /tmp/fifo_irc3 -c -w > /tmp/logIrc3.txt 2>&1 &
}

function arrete_irc3
{
if [[ -p /tmp/fifo_irc3 ]]
then
    echo "%% STOP IRC3" > /tmp/fifo_irc3
fi
}

function travail
{
if [[ -p /tmp/fifo_irc3 ]]
then
    data=$(cat)

    mkfifo -m 0666 /tmp/fifo_job_$$

    (echo "%% JOB POUR FIFO /tmp/fifo_job_$$";
     echo "$data";
     echo "%% FIN JOB") > /tmp/fifo_irc3

    cat /tmp/fifo_job_$$
    rm -f /tmp/fifo_job_$$

fi
}

trap 'if [[ -p /tmp/fifo_job_$$ ]]; then rm /tmp/fifo_job_$$; fi' HUP INT TERM EXIT

# Options
if [[ -z $1 ]]
then
    echo " "
    usage
    exit 1
else
    if [[ $1 = "help" ]]
    then
        aide
    elif [[ $1 = "start" ]]
    then
        lance_irc3
    elif [[ $1 = "ws" ]]
    then
        lance_irc3_ws
    elif [[ $1 = "stop" ]]
    then
        arrete_irc3
    elif [[ $1 = "job" ]]
    then
        travail
    fi
fi


exit 0
