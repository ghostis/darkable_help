# Images are showing up as "skull and cross bones" icon
* Print film rolls that do not exist on disk:
    sqlite3 ~/.config/darktable/library.db 'SELECT * FROM film_rolls;' | awk -F\| '{print $NF}' | while IFS='' read -r line || [[ -n "$line" ]]; do if [ ! -d "${line}" ] ; then echo ${line} ; fi ; done
    
    
