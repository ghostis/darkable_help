# BEFORE PROCEEDING
* Warning: You can trash your Darktable database with the sqlite3 cli. Be careful. Make backups. This author is not responsible for lost data.
* Quit Darktable to allow access to Darktable's database
* Install sqlite3
* Backup your Darktable database:

```cp ~/.config/darktable/library.db ~/.config/darktable/library.db.`date +%Y%m%d%H%M` ```

# PROBLEM: Images in lighttable are showing up as "skull and cross bones" icon
* Print film rolls that do not exist on disk:

```sqlite3 ~/.config/darktable/library.db 'SELECT * FROM film_rolls;' | awk -F\| '{print $NF}' | while IFS='' read -r line || [[ -n "$line" ]]; do if [ ! -d "${line}" ] ; then sqlite3 ~/.config/darktable/library.db "SELECT * FROM film_rolls WHERE folder = '${line}' ; " ; fi ; done```

* Note the ID number in the first field.

* In your Darktable library on disk, find the correct actual full path to the mis-named film roll.

* Update the row in the the film_rolls table:

```sqlite3 ~/.config/darktable/library.db "UPDATE film_rolls SET folder = '/Full/correct/actual/path/to/missing/film/roll/on/disk' WHERE id = ID_FROM_PREVIOUS_COMMAND ;"```
