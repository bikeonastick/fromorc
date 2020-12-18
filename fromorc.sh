#!/usr/bin/env bash


THUMBS_DOWN=$'\360\237\221\216'
THUMBS_UP=$'\360\237\221\215'
CROSSED_FINGERS=$'\360\237\244\236'

function getTrails() 
{
  local trails=`curl -s https://api.morcmtb.org/v1/trails | jq '.[]|{name: .trailName, status: .trailStatus, updated: .updatedAt}'`
  echo "$trails"
}

ALL_TRAILS=$(getTrails)

