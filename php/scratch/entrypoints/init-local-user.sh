#!/usr/bin/env sh

USER_ID=${LOCAL_USER_ID:-9001}
GROUP_ID=${LOCAL_GROUP_ID:-9001}

userExists=$(getent passwd ${USER_ID} | cut -d':' -f 1)
groupExists=$(getent group ${GROUP_ID} | cut -d':' -f 1)

if [ "${groupExists}" == "" ]; then
    addgroup \
      -g ${GROUP_ID} \
      dockerlocal
else
  groupmod --new-name dockerlocal ${groupExists}
fi

if [ "${userExists}" == "" ]; then
    adduser \
      -s /bin/sh \
      -u ${USER_ID} \
      -G dockerlocal \
      -S \
      docker
else
  usermod -l docker ${userExists}
fi
