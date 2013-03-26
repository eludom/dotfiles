#! /bin/bash
# script to determine where I am

whereAmI=
if [ -x /usr/sbin/airport ]; then
  # http://osxdaily.com/2012/02/28/find-scan-wireless-networks-from-the-command-line-in-mac-os-x/
#  if grep -q '^[ \t]*foo' <<<`/usr/sbin/airport -s`; then
  if grep -q '[ \t]foo' <<<`/usr/sbin/airport -s`; then
      whereAmI="home"
  fi
  if grep -q '[ \t]SEIDC' <<<`/usr/sbin/airport -s`; then
      whereAmI="work"
  fi
fi

echo $whereAmI
