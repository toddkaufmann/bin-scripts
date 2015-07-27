#!/bin/sh
# $Id: wf.sh 750 2012-11-11 00:13:47Z todd $

# 'classic' word freq

tr -c 0-9a-zA-Z '\n' | sort | uniq -i -c | sort -nr 

exit 0

================================= wf spelled out:
tr -cs A-Za-z\' '\n' |         
# Replace nonletters with newlines
  tr A-Z a-z |                 
#Map uppercase to lowercase
    sort |                     
#Sort the words in ascending order
      uniq -c |                
#Eliminate duplicates, showing their counts
        sort -k1,1nr -k2 |     
#Sort by descending count, and then by ascending word
          sed ${1:-25}q        
#Print only the first n (default: 25) lines

...
Use the following one liner to identify which command you execute a lot from your command line.

$ cat ~/.bash_history | tr "\|\;" "\n" | sed -e "s/^ //g" | cut -d " " -f 1 | sort | uniq -c | sort -n | tail -n 15