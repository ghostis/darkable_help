#!/usr/bin/env bash
sqlite3 ~/.config/darktable/library.db 'SELECT * FROM film_rolls;' | \
awk -F\| '{print $NF}' | \
while IFS='' read -r line || [[ -n "$line" ]];
do
  if [ ! -d "${line}" ]
  then line_cleaned="`echo ${line} | sed -e \"s_'_''_g\" `" && sqlite3 ~/.config/darktable/library.db "SELECT * FROM film_rolls WHERE folder = '${line_cleaned}' ; "
  fi
done
