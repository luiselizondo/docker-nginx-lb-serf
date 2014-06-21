if [ "x${SERF_SELF_ROLE}" != "xlb" ]; then
    echo "Not an lb. Ignoring member leave"
    exit 0
fi

while read line; do
    IP=$(echo $line | awk '{print $2 }')
    sed -i "/${IP}:3000;/d" /etc/nginx/sites-enabled/default.conf
    sed -i "/${IP}:3000;/d" /var/log/supervisor/nginx-available-servers.txt
done

service nginx reload