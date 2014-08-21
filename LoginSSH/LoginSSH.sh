#!/bin/bash

# Put yours emails separated with simple space
# ex: MAIL_TO=(security@domain.org admin@domain.org)
MAIL_TO=()

MAILCMD='/bin/mail'

if [ -n "$SSH_TTY" ]; then
	SSHCLIENT=$(echo $SSH_CLIENT|awk '{print $1}')
        SUBJECT="Urgent - Login in $HOSTNAME"
        MENSAGE="User: $USER login with IP: $SSHCLIENT"
        for ((b=0;$b<${#MAIL_TO[*]};b++)); do
                echo "$MENSAGE"|$MAILCMD -s "$SUBJECT" "${MAIL_TO[$b]}"
        done
fi
