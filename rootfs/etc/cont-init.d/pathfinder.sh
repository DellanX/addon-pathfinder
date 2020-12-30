#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Pathfinder
# Sets up Pathfinder before the server starts
# ==============================================================================

MYSQL_HOST=$(bashio::services "mysql" "host")
MYSQL_PORT=$(bashio::services "mysql" "port")
MYSQL_USER=$(bashio::services "mysql" "username")
MYSQL_PASSWORD=$(bashio::services "mysql" "password")
CCP_SSO_CLIENT_ID=""
CCP_SSO_SECRET_KEY=""

#!/bin/bash
function replace_setting() {
    sed -i -E "s/$1/$2/g" $3
}
echo "Replacing Server Settings"
replace_setting "^SERVER\s*=\s*.*$" "SERVER                         =   PRODUCTION" "/var/www/pathfinder/app/environment.ini"
echo "Replacing DB DNS settings"
replace_setting "^DB_PF_DNS\s*=\s*.*$" "DB_PF_DNS                         =   mysql:host=${MYSQL_HOST};port=${MYSQL_PORT};" "/var/www/pathfinder/app/environment.ini"
replace_setting "^DB_UNIVERSE_DNS\s*=\s*.*$" "DB_UNIVERSE_DNS                         =   mysql:host=${MYSQL_HOST};port=${MYSQL_PORT};" "/var/www/pathfinder/app/environment.ini"
echo "Replacing URL settings"
replace_setting "^URL\s*=\s*.*$" "URL                         =   https:\/\/nilfgard.duckdns.org:1001" "/var/www/pathfinder/app/environment.ini"
echo "Replacing DB PASS settings"
replace_setting "DB_PF_PASS\s*=\s*.*" "DB_PF_PASS                  =   ${MYSQL_PASSWORD}" "/var/www/pathfinder/app/environment.ini"
echo "Replacing DB USER settings"
replace_setting "DB_PF_USER\s*=\s*.*" "DB_PF_USER                  =   ${MYSQL_USER}" "/var/www/pathfinder/app/environment.ini"
echo "Replacing DB PF DB Name settings"
replace_setting "DB_PF_NAME\s*=\s*.*" "DB_PF_NAME           =   pathfinder" "/var/www/pathfinder/app/environment.ini"
echo "Replacing DB U DB Name settings"
replace_setting "DB_UNIVERSE_NAME\s*=\s*.*" "DB_UNIVERSE_NAME           =   universe" "/var/www/pathfinder/app/environment.ini"
echo "Replacing DB PASS settings"
replace_setting "DB_UNIVERSE_PASS\s*=\s*.*" "DB_UNIVERSE_PASS            =   ${MYSQL_PASSWORD}" "/var/www/pathfinder/app/environment.ini"
echo "Replacing DB USER settings"
replace_setting "DB_UNIVERSE_USER\s*=\s*.*" "DB_UNIVERSE_USER            =   ${MYSQL_USER}" "/var/www/pathfinder/app/environment.ini"
replace_setting "CCP_SSO_CLIENT_ID\s*=\s*.*" "CCP_SSO_CLIENT_ID           =   ${CCP_SSO_CLIENT_ID}" "/var/www/pathfinder/app/environment.ini"
replace_setting "CCP_SSO_SECRET_KEY\s*=\s*.*" "CCP_SSO_SECRET_KEY          =   ${CCP_SSO_SECRET_KEY}" "/var/www/pathfinder/app/environment.ini"
# replace_setting "CHARACTER\s*=\s*.*" "CHARACTER          =   ${CHARACTER}" "/var/www/pathfinder/app/pathfinder.ini"
# replace_setting "CORPORATION\s*=\s*.*" "CORPORATION          =   ${CORPORATION}" "/var/www/pathfinder/app/pathfinder.ini"
# replace_setting "ALLIANCE\s*=\s*.*" "ALLIANCE          =   ${ALLIANCE}" "/var/www/pathfinder/app/pathfinder.ini"
# replace_setting "web\s*=\s*.*" "web     = ${CronWebUI}" "/var/www/pathfinder/app/cron.ini"
# if [ "${SETUP}" != "True" ]; then
#     replace_setting "^GET @setup.*$" "" "/var/www/pathfinder/app/routes.ini"
# fi