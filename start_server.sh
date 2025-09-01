systemctl stop memcached redis mysql apache2 
sudo docker compose up -d
sleep 10
sudo docker compose up