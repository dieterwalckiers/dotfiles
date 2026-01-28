Increase swap to prevent system freezes when memory fills up.
Default Ubuntu swap (2GB) is too small for heavy dev workloads.

# Create 8GB swap file
sudo fallocate -l 8G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Install earlyoom - kills memory hogs before system freezes
sudo apt install earlyoom
sudo systemctl enable --now earlyoom
