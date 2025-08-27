systemctl start memcached redis mysql apache2 
sudo docker compose down
python3 manage.py runserver