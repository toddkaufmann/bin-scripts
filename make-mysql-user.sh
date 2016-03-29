#!/bin/sh
# this just helps me remember the syntax...

# user=user
# password=password
# dbhost=localhost

: ${user:=$1}
: ${password:=$2}
: ${dbhost:=$3}

cat <<EOF
-- dbhost is where you access from -- can be localhost or % for any, or a specific hostname or ip (eg your webserver)
-- all privileges for $user@$dbhost  (with password '$password')
CREATE USER '$user'@'$dbhost' IDENTIFIED BY '$password';
GRANT ALL PRIVILEGES ON *.* TO '$user'@'$dbhost' IDENTIFIED BY '$password' 
  WITH GRANT OPTION ;

-- database schema with same name?
create database \`$user\`;

-- sufficient for backups or export, no modifications
CREATE USER '$user'@'$dbhost' IDENTIFIED BY '$password'
GRANT SELECT , LOCK TABLES ON *.* TO '$user'@'$dbhost' 
-- to limit, can also set these:
WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;

EOF
