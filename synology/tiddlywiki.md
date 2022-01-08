- using OokTech/TW5-Bob for multi-user support, which is needed to sync editing files in terminal using vi, with interface

script to start the wiki (currently on <Synology drive folder>/myscripts/startdytewiki.sh):
```
#!/bin/sh
/usr/local/bin/node /var/services/homes/dyte/Drive/TiddlyWiki5/tiddlywiki.js /var/services/homes/dyte/Drive/TiddlyWiki5/Wikis/dytewiki --wsserver 2>&1 >> /var/services/homes/dyte/Drive/myscripts/logs/startdytewiki.log
```


- to restrict access for public users: nginx reverse proxy (many tutorials available to install on synology, I checked https://www.wundertech.net/nginx-proxy-manager-synology-nas-setup-instructions/)
was stuck here for a long time because I didn't pick the right subnet when creating the docker network. should have been 192.168.0.xx and not 192.168.1.xx in my case!
was also hitting the bad gateway the article describes, fixed it by making proxy manager use the Nas's second IP.

then I did https://www.wundertech.net/setup-an-ssl-certificate-for-plex-using-nginx-proxy-manager/ to make the subdomain dytewiki.1983.gent work
additional things
- make a record in combell to point dytewiki.1983.gent to nas ip
- expose ports in telenet router: 80 and 443, pointing them to the IP that the proxy manager runs on (npm_network)
- here aswell I had to use the second IP of the nas in forward hostname/ip to make it work 





little todo here: enable firewall (link in video of above resource at 6:44)
