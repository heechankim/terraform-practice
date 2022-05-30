#!/bin/bash
cat > index.html <<EOF
<h1>${server_text}</h1>
<br/><br/><hr/>
<p>Host: `uname -a`</p>
<p>DB Address: ${db_address}</p>
<p>DB Port: ${db_port}</p>
EOF

nohup busybox httpd -f -p ${server_port} 1>/dev/null 2>&1 &
