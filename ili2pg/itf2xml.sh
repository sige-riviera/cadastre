#!/bin/bash

set -e


ftp -n -v ftp.infogrips.ch <<-EOF
user itf2xml denis.rouzaud@sige.ch
prompt
binary
put $1 $1
bye
EOF
