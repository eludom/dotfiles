#! /bin/bash

# Fix timestamps on tig files per ls-files
#
# Original from http://stackoverflow.com/questions/2179722/checking-out-old-file-with-original-create-modified-timestamps/30143117#30143117
#
# Fixed to work with ubuntu.


for FILE in $(git ls-files)
do
    TIME=$(git log --pretty=format:%cd -n 1 --date=iso $FILE)
    TIME2=`echo $TIME | sed 's/-//g;s/ //;s/://;s/:/\./;s/ .*//'`
    touch -m -t $TIME2 $FILE
done 
