#!/bin/bash

# script used to publish RPMS

set -e

TITLE="Sailfish OS Maps Repositories"

# write index header
echo '<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>$TITLE</title>
        <meta name="description" contents="$TITLE">
    </head>
    <body>
      <h1>$TITLE</h1>
      <ul>
' > RPMS/index.html


# generate index.html used to show overview page
cd RPMS
for release in `echo SailfishOS-* | sort -V`; do
    pwd
    ls
    echo $release
    (cd $release && \
	 tree -h -T "$TITLE: <br>$release" --noreport \
	      -D -L 1 -F --dirsfirst -P "*.rpm" -H . . > index.html)
    echo "<li><a href=\"$release/index.html\">$release</a></li>" >> index.html
done
cd ..

# finish main index page
echo '
      </ul>
    </body>
</html>
' >> RPMS/index.html

# default error page
echo "Error, file or directory not found or not accessible via this URL" > RPMS/error.txt

# sync
minmc mirror --remove --overwrite RPMS/ scw/sailfishos-maps/
