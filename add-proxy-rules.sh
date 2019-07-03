#!/bin/sh

# Generate the ProxyPass block for apache 2.4
# because i have trouble remembering

# PREFIX is something like '/myapp' -- a tree of your website you want to redirect
PREFIX=$1

# DEST is the url (relative to apache -- will never be exposed)
# eg http://localhost:8080/  or
# eg https://testserver.mycompany.com/
# (you need some addition SSL proxy directives and possibly module for that)
DEST=$2

# these trailing slash rules not always right ?


cat <<EOF
# send requests for $PREFIX to $DEST
ProxyPass        $PREFIX/ $DEST$PREFIX/
ProxyPassReverse $PREFIX/ $DEST$PREFIX/

<Location "$PREFIX">
   Options Indexes FollowSymLinks MultiViews
    AllowOverride all
    Order allow,deny
    Allow from all
</Location>

EOF
