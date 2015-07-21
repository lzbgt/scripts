#!/bin/sh

###
# tools for forward local port to remote host
# Bruce.Lu <rikusouhou@gmail.com> 2015

basename $0

TARGETADDR=9922:zjqs.1ding.me:22
PROXYIP=0.0.0.0
REVERT=0
if [ $# -ne 0 ]
then
    if [ "$1" != "" ]
    then
        TARGETADDR=$1
    fi
    if [ "$2" != "" ]
    then
        PROXYIP=$2
    fi
    if [ "$3" != "1" ]
    then
        REVERT=1
    fi
fi

PWD=`pwd`
PROJ=.portmapping

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
EXISTED=\`netstat -antp|grep ssh|grep -c "$TARGETADDR"\`
if [ "\$EXISTED" == "0" ]
then
    if [ "$REVERT" == "1" ]
    then
    ssh -R $TARGETADDR -fgN $PROXYIP 
    else
    ssh -L $TARGETADDR -fgN $PROXYIP
    fi
fi

PROJSH

chmod +x $PROJ.sh
sh $PROJ.sh