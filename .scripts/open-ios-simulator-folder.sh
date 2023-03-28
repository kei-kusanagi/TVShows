#!/bin/zsh
set -euxo pipefail

CURRENT_SIM_DATA=$(xcrun simctl get_app_container booted juancarlosrobledomorales.com.tvShow data);
open $CURRENT_SIM_DATA;

CURRENT_REALM_FILE=$(find $CURRENT_SIM_DATA -name dbestech.db -print);
echo "Realm file found at:\n$CURRENT_REALM_FILE\n";
echo "Opening realm file...";
open $CURRENT_REALM_FILE;