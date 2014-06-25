#!/bin/bash

MAIL_TO=()

MAILCMD='/bin/mail'

if [ -n "$SSH_TTY" ]; then
	SSHCLIENT=$(echo $SSH_CLIENT|awk '{print $1}')
        SUBJECT="URGENTE - Login realizado em $HOSTNAME"
        MENSAGEM="Usuario: $USER realizou o login partir do IP: $SSHCLIENT"
        for ((b=0;$b<${#TO[*]};b++)); do
                echo "$MENSAGEM"|$MAILCMD -s "$SUBJECT" "${TO[$b]}"
        done
fi
