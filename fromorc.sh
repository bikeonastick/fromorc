#!/usr/bin/env bash

THUMBS_DOWN="\xF0\x9F\x91\x8E"
THUMBS_UP="\xF0\x9F\x91\x8D"

#WHITE_HEAVY_CHECK_MARK
GOOD="\xe2\x9c\x85"
#CROSSED_FINGERS
MAYBE="\xf0\x9f\xa4\x9e"
#POOP
FUHGETABOUTIT="\xf0\x9f\x92\xa9"


function strQuotes()
{
  temp="${1%\"}"
  temp="${temp#\"}"
  echo "$temp"
}

function getThumb()
{
  local arg=$(strQuotes $1)
  if [ $arg == 'Open' ]
  then
    echo "$THUMBS_UP"
  else
    echo "$THUMBS_DOWN"
  fi
}

function getTrails() 
{
  local trails=`curl -s https://api.morcmtb.org/v1/trails | jq '.'`
  echo "$trails"
}

function trailCount()
{
  local count=`curl -s https://api.morcmtb.org/v1/trails | jq length`
  echo "$count"
}

function getTrailName()
{
  local index=$1
  local key='trailName'
  echo "$(getValAt $1 $key)"
}

function getTrailStatus()
{
  local index=$1
  local key='trailStatus'
  echo "$(getValAt $1 $key)"
}

function getUpdatedAt()
{
  local index=$1
  local key='updatedAt'
  echo "$(getValAt $1 $key)"
}

function getValAt()
{
  if [ -z "$ALL_TRAILS" ]; then
    ALL_TRAILS=$(getTrails)
  fi
  local index=$1
  local key=$2
  local name=`echo $ALL_TRAILS | jq ".[$index].$key"`
  echo "$name"
}

function getTrailNames()
{
  if [ -z "$ALL_TRAILS" ]; then
    ALL_TRAILS=$(getTrails)
  fi
  local trailNames=`echo $ALL_TRAILS | jq ".[].trailName"`
  echo "$trailNames"
}

function rateUpdated()
{
  local updatedAt=$1
  local current=$(($(date +'%s * 1000 + %-N / 1000000'))) 
  local diff_milli=$(expr $current - $1)
  # updated in 
  # last 48 hrs - good
  if [[ $diff_milli -le $(( 1000 * 60 * 60 * 48 )) ]]
  then
    echo "$GOOD"
  elif [[ $diff_milli -le $(( 1000 * 60 * 60 * 168 )) ]]
  then
    # 49-168 hrs - maybe
    echo "$MAYBE"
  else
    # > 168 - all bets are off
    echo "$FUHGETABOUTIT"
  fi
  echo ""
}

# parse millis to date
# date -r $((1607721206257 / 1000)) 
# get current time in millis
# echo $(($(date +'%s * 1000 + %-N / 1000000'))) 

# echo "$(getTrailName 0) - $(getTrailStatus 0) - $(getUpdatedAt 0)"

ALL_TRAILS="$(getTrails)"


#echo "count $(trailCount) ##"
#echo "names $(getTrailNames) ##"
 #
 endIndex=$(expr $(trailCount) - 1)
 for num in $(seq 0 $endIndex); do
   echo -e "$(getTrailName $num) - $(getThumb $(getTrailStatus $num)) - $(rateUpdated $(getUpdatedAt $num))";
 done
