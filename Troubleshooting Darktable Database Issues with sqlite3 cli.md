# BEFORE PROCEEDING
* Warning: You can trash your Darktable database with the sqlite3 cli. Be careful. Make backups. This author is not responsible for lost data.
* Quit Darktable to allow access to Darktable's database
* Install sqlite3
* Backup your Darktable database:

```cp ~/.config/darktable/library.db ~/Documents/Darktable.library.db.backup.`date +%Y%m%d%H%M` ```

# PROBLEM: Images in lighttable are showing up as "skull and crossbones" icon
## Film roll folder in database differs from actual path on disk
* If you have imported a film roll, the metadata for that film roll contains the full file system path to that film roll. If you rename that location on disk, you will see black and white "skull and cross bones" icons in lighttable instead of your photos. This can also happen if you rename an individual photo file.
* Print database entries for film rolls that do not exist on disk with this bash snippet:

```#!/usr/bin/env bash
sqlite3 ~/.config/darktable/library.db 'SELECT * FROM film_rolls;' | \
awk -F\| '{print $NF}' | \
while IFS='' read -r line || [[ -n "$line" ]];
do
  if [ ! -d "${line}" ]
  then line_cleaned="`echo ${line} | sed -e \"s_'_''_g\" `" && sqlite3 ~/.config/darktable/library.db "SELECT * FROM film_rolls WHERE folder = '${line_cleaned}' ; "
  fi
done```

* Note the ID number in the first field.

* In your Darktable library on disk, find the correct actual full path to the mis-named film roll.

* Update the row in the the film_rolls table. Replace */Full/correct/actual/path/to/missing/film/roll/on/disk* with the actual path. Replace *ID_FROM_PREVIOUS_COMMAND* with the actual numerical ID of the broken film roll. Remember to use two single quotes when you have single ' characters in the path, e.g., 
```Ted's -> Ted''s``` :

```sqlite3 ~/.config/darktable/library.db "UPDATE film_rolls SET folder = '/Full/correct/actual/path/to/missing/film/roll/on/disk' WHERE id = ID_FROM_PREVIOUS_COMMAND ;"```
