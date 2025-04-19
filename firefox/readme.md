### concerning two-finger-swipe-to-navigate in firefox
works by default on wayland but not on x11.
solution
1. run `echo export MOZ_USE_XINPUT2=1 | sudo tee /etc/profile.d/use-xinput2.sh`
2. log out and back in
(from https://www.reddit.com/r/linux/comments/72mfv8/psa_for_firefox_users_set_moz_use_xinput21_to/)


