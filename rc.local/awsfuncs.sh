awsRmAll () {
    # Remove all objects in an AWS bucket
    #
      aws s3 ls s3://$1 | sed 's/.*4 //' | sed 's/^/aws s3 rm s3:\/\/'$1'\//' | tee /dev/tty | sh
}

#

alias awsrmall=awsRmAll
