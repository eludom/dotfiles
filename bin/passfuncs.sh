# Functions and aliases for working wtih pass(1)
#
# Usage:
#   source passfuncs.sh
#
#     passurl pass-name  # print url
#     passuser pass-name # print user
#     passopen pass-name # print username, copy pasword to clipboard, open URL
# 


# define browser to use
export passBrowser=google-chrome

passurlFunc () {
    # print the URL for a password stored in pass
    #
    # Assumes the URL is stored in a line like:
    #
    #   url: https://example.com
    
    pass $1 | grep '^url:' | sed 's/^[ \t]*url:[ \t]*//i'
}

passuserFunc () {
    # print the username for a password stored in pass
    #
    # Assumes the username is stored in a line like:
    #
    #   username: FOO
    
    pass $1 | grep '^username:' | sed 's/^[ \t]*username:[ \t]*//i'
}

passopenFunc () {
    # Print username, copy password to clipboard, open url in browser
    #
    # Assumes the URL is stored in a line like:
    #
    #   username: FOO

    echo -n username: " "
    passuser $1
    pass -c $1
    $passBrowser `passurl $1`
}

alias passurl=passurlFunc
alias passuser=passuserFunc
alias passopen=passopenFunc
