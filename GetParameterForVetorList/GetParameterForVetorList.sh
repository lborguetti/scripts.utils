#!/bin/bash

source etc/hosts.cfg

for var in $(grep -o "HOSTS_.*=" etc/hosts.cfg|sed 's/=//g'); do
	eval qtd="\${#${var}[@]}"
	for((i=0;$i<${qtd};i++)); do
		eval echo \${${var}[$i]}
	done
done
