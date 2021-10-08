#!/bin/bash
cd /home/dyte/Dropbox/journal
# args howto https://www.baeldung.com/linux/use-command-line-arguments-in-bash-script
while getopts 123456789 flag
do
   case "${flag}" in
      1) daysAgo=1;;
      2) daysAgo=2;;
      3) daysAgo=3;;
      4) daysAgo=4;;
      5) daysAgo=5;;
      6) daysAgo=6;;
      7) daysAgo=7;;
      8) daysAgo=9;;
      9) daysAgo=8;;
   esac
done
if [[ -z $daysAgo ]]; then
   daysAgo=0
fi
journalType="";
tags="";
argJournalType=$1;

if [ "$argJournalType" = "p" ]; then
   journalType="-personal";
   tags="Journal Journal-personal"
else
   journalType="-business";
   tags="Journal Journal-business"
fi

dayStamp=$(date -d "$date -$daysAgo days" +"%Y-%m-%d")
entryName=$dayStamp$journalType
entryPath=/home/dyte/SynologyDrive/TiddlyWiki5/Wikis/dytewiki/tiddlers/$entryName.tid

if test -f "$entryPath"; then
   echo "exists"
else
   timestamp=$(date +"%Y%m%d%H%M%S000")
   echo -e "created: $timestamp\nmodified: $timestamp\ntags: $tags\ntitle: $entryName\ntype: text/vnd.tiddlywiki\n\n" > $entryPath
fi
vim "+normal G" $entryPath
