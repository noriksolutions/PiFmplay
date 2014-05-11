#!/bin/bash


PIFM_BINARY="/root/Desktop/pifmplay/pifmplay"
PIFM_FREQUENCY=97.3
LOG_ROOT="/root/Desktop/pifmplay/logs"
now=$(date +"%a")

#####################
LOG="$LOG_ROOT/pifm.log"
mkdir -p "$LOG_ROOT"

if [ $# -eq 1 ]; then
  pat1=$1
   if(pat1="myown");then 
  MUSIC_ROOT="/root/Desktop/pifmplay/Refreshment/Music"
  fi
else
MUSIC_ROOT="/root/Desktop/pifmplay/DEV/$now"
 
fi

{

# Functions:
pause() {
  # pauses the stream of music to pifm by pausing the program doing the conversion
  # this works(ish), but pifm is stuck with the last buffer, so doesn't sound good. now how do we fix that? maybe make a temporary nosound buffer and force feed pifm with it?
  echo "Pausing fm-broadcast"
  pkill -STOP ffmpeg
  pkill -STOP sox
}
resume() {
  # it does what it says it does, or does it?
  echo "Resuming FM-broadcast"
  pkill -CONT ffmpeg
  pkill -CONT sox
}
next() {
	# kills pifm, and that makes pifmplay continue to the next item in list (if there is any)
	pkill pifm
}
stop() {
	# slaughers pifmplay (and everything that goes with it)
	for i in `ps aux | grep pifmplay | awk '{print $2}'`;
	do
	{
		sudo kill $i
	}
	done
}

# And now we run it!! ;)
# if its given one of the control commands as first parameter, do it to it   
if [ "$1" = "pause" ]; then
echo $1
	pause
elif [ "$1" = "resume" ]; then
echo $1	
resume
elif [ "$1" = "next" ]; then
echo $1
	next
elif [ "$1" = "stop" ]; then
echo $1
	stop
else
	# else we play the thing
            command="sh $PIFM_BINARY $MUSIC_ROOT $PIFM_FREQUENCY"
            echo "$command # $( date )"
            bash -c "$command"
fi
} 2>&1 | tee -a "$LOG"