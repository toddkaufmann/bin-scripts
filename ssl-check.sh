#!/bin/bash

check_ssl () 
{ 
    local dom="$1";
    echo;
    echo ===== checking cert for "$dom";
    echo;
    openssl s_client -servername "$dom" -connect "$dom":443 < /dev/null 2> /dev/null | openssl x509 -noout -dates;
    echo;
    echo ======== show the chain;
    echo;
    openssl s_client -servername "$dom" -showcerts -connect "$dom":443 < /dev/null 2>&1 > /dev/null;
    echo
}

for dom in "$@"; do
    check_ssl "$dom"
done
