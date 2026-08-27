#!/bin/bash

function check_ssl () 
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

function check_ssl2 () 
{ 
    local dom="$1"; local server="$2";
    echo;
    echo ===== checking cert for "$dom" on $server;
    echo;
    openssl s_client -servername "$dom" -connect "$server":443 < /dev/null 2> /dev/null | openssl x509 -noout -dates;
    echo;
    echo ======== show the chain;
    echo;
    openssl s_client -servername "$dom" -showcerts -connect "$server":443 < /dev/null 2>&1 > /dev/null;
    echo
}

# for sslh in $( host api.dev.bloomfield.ai | sed -e 's=.* has address ==;'); do echo ssl-check.sh $sslh; ssl-check.sh $sslh; done
# but only for certain subs of dom above

for dom in "$@"; do
    check_ssl "$dom"
done
