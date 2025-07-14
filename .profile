# shellcheck disable=SC2148

# each time a login shell is started, /etc/profile and .profile are sourced
# stuff in here should happen once for root and then once for each user on login

# if $PROFILEREAD exists or is empty source /etc/profile else no error
test -z "$PROFILEREAD" && . /etc/profile || true

export EDITOR=/usr/bin/nano

# log
echo ".profile sourced"
