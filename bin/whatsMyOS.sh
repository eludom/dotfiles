#! /bin/bash -f

osName=""
if grep -q -i Darwin <<<"`uname -a`"; then
    osName="mac";
elif grep -q -i linux <<<"`uname -a`"; then
    osName="linux";
fi

echo $osName

