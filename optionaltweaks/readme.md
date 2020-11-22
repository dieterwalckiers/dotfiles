was needed to make docker containers not hit a "System limit for number of file watchers reached" error:

echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

(on the host machine, not in container!)

