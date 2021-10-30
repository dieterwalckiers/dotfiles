- using OokTech/TW5-Bob for multi-user support, which is needed to sync editing files in terminal using vi, with interface

script to start the wiki (currently on <Synology drive folder>/myscripts/startdytewiki.sh):
```
#!/bin/sh
/usr/local/bin/node /var/services/homes/dyte/Drive/TiddlyWiki5/tiddlywiki.js /var/services/homes/dyte/Drive/TiddlyWiki5/Wikis/dytewiki --wsserver 2>&1 >> /var/services/homes/dyte/Drive/myscripts/logs/startdytewiki.log
```

- to provide security: nginx reverse proxy (many tutorials available to install on synology, I checked https://www.wundertech.net/nginx-proxy-manager-synology-nas-setup-instructions/)
