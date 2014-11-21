#!/bin/bash

SUCCESS_STREAK=0
NEW_WORD=true

#Game loop
until [ "$INPUT" = "q" ]
do

  #Get random word from dictionary.txt
  if [ $NEW_WORD == true ]; then
    WORD=$(tail -$(($((RANDOM/(32767/`wc -l<dictionary.txt`)))+1)) dictionary.txt|head -1)
  fi

  #Store terminal window id
  TERMINAL_WINDOW=$(xdotool getactivewindow)

  #Open Browser with mp3 of word
  MP3=".mp3"
  URL="https://ssl.gstatic.com/dictionary/static/sounds/de/0/$WORD$MP3"
  /usr/bin/chromium-browser --app=$URL 2>/dev/null & 
  chrome_pid=$!

  #Wait for browser to open
  until [ $TERMINAL_WINDOW -ne $(xdotool getactivewindow) ]
  do
    sleep 0.5
  done

  #Put focus back on terminal after browser opens
  xdotool windowfocus $TERMINAL_WINDOW
  xdotool windowactivate $TERMINAL_WINDOW

  read INPUT
  kill "$chrome_pid"

  #Extend or end current streak
  if [[ $INPUT == $WORD ]]; then 
    ((SUCCESS_STREAK++))
    NEW_WORD=true
    echo "Current Streak: $SUCCESS_STREAK"
  else 
    SUCCESS_STREAK=0
    NEW_WORD=false
    echo "Wrong. How most people would spell it: $WORD"
  fi
done
