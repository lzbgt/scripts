#!/bin/sh

###
# tools for forward local port to remote host
# Bruce.Lu <rikusouhou@gmail.com> 2015/07/20

SERVERADDR=tts2.zjqunshuo.com:8080
PORT=80
if [ $# -ne 0 ]
then
    if [ "$1" != "" ]
    then
        PORT=$1
    fi
    if [ "$2" != "" ]
    then
        SERVERADDR=$2
    fi
fi

PWD=`pwd`
PROJ=.forward-tts

#cron
CRONFILE=cron.tmp
tee $CRONFILE << CRONT >/dev/null 2>&1
*/5 * * * * $PWD/$PROJ.sh
CRONT
crontab $CRONFILE
rm -fr $CRONFILE

#proj
rm -fr $PROJ.sh
tee $PROJ.sh << PROJSH >/dev/null 2>&1
#!/bin/sh
EXISTED=\`netstat -antp|grep ssh|grep -wc $PORT\`
if [ "\$EXISTED" == "0" ]
then
ssh -L $PORT:$SERVERADDR -fgN 0.0.0.0
fi
PROJSH
chmod +x $PROJ.sh
sh $PROJ.sh