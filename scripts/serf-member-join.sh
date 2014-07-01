if [ "x${SERF_SELF_ROLE}" != "xlb" ]; then
    echo "Not an lb. Ignoring member join."
    exit 0
fi

while read line; do
    ROLE=`echo $line | awk '{print \$3 }'`
    if [ "x${ROLE}" != "xweb" ]; then
        continue
    fi

    SERVER=`echo $line | awk '{printf "server %s:3000;", $2}'`
    sed -i "/upstream/a\  $SERVER" /etc/nginx/sites-enabled/default
    echo $SERVER >> /var/log/supervisor/nginx-available-servers.txt
done

service nginx reload