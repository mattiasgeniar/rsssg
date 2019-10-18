#!/usr/bin/env bash
# Real Simple Static Site Generator - Version 0.1
# Copyright (C) 2019 Mattias Geniar m@ttias.be
#
# For the latest updates, please visit https://github.com/mattiasgeniar/rsssg
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# license for more details:
#  https://github.com/mattiasgeniar/rsssg/blob/master/LICENSE
#

# Do system basic checks, like checking for wget
if ! [ -x "$(command -v wget)" ]; then
  echo 'Error: wget is not installed.' >&2

  exit 1
fi

# Prepare the config
CONFIG="config.txt"

if [[ ! -f "$CONFIG" ]]; then
    echo "Config file '$CONFIG' does not exist. See Github for examples." >&2
    echo "" >&2
    echo "SOLUTION:" >&2
    echo "$ mv config.txt.example config.txt" >&2
    echo "" >&2
    echo "Without a config file, I don't know what to do. Quitting now." >&2

    exit 1
fi

# Read the config
. $CONFIG

# Validate the config
# TODO: validate the config

# Extract the domain name from the source URL
DOMAIN=$(awk -F/ '{print $3}' <<<$SOURCE_URL)

if [[ ! -d "$DESTINATION_DIR" ]]; then
    echo "Destination directory '$DESTINATION_DIR' does not exist." >&2

    exit 1
fi

if [[ ! -z "$(ls -A $DESTINATION_DIR)" ]]; then
   echo "Destination directory '$DESTINATION_DIR' is not empty." >&2
   echo "This tool does not overwrite files. Please make sure the" >&2
   echo "destination directory is empty before proceeding." >&2

   exit 1
fi

wget \
    --recursive \
    --no-clobber \
    --page-requisites \
    --no-cache \
    --no-host-directories \
    --convert-links \
    --domains $DOMAIN \
    --no-parent \
    --level $LEVELS \
    --directory-prefix $DESTINATION_DIR \
    $SOURCE_URL

# Fix downloaded files with cache-busting URLs like "?v=1.2.3" in them
# We play it safe: copy it to the new location, don't move it (aka: leave original)
find $DESTINATION_DIR -type f -name '*\?*' |\
    while read FILENAME
    do
        STRIPPED_FILENAME="${FILENAME%*\?*}"
        cp "${FILENAME}" "${STRIPPED_FILENAME}"
    done

echo "Done."
echo "Your static version of the website is available at the following location:"
echo $DESTINATION_DIR
echo ""
echo "Note: this should be served via Apache/Lighttpd, URLs will contain absolute values (ie: /contact)."

exit 0