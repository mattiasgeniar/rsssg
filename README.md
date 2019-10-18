# Real Simple Static Site Generator (RSSSG)

The goal: make a dead-simple static site generator.

Usage:

```
$ cat config.txt
SOURCE_URL=http://source.example.org
LEVELS=5
DESTINATION_DIR=/var/www/vhosts/site.tld/static

$ ./generate.sh
```

The result will be stored in `/var/www/vhosts/site.tld/static` as defined in your config.
