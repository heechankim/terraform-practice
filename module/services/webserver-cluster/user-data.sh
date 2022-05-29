#!/bin/bash
echo "<h1>Hello, World!!</h1><br><br><br><hr>" > index.html
echo "Host: `uname -a`<br>" >> index.html
echo "DB Address: ${db_address}" >> index.html
echo "DB Port: ${db_port}" >> index.html
nohup busybox httpd -f -p ${server_port} 1>/dev/null 2>&1 &
